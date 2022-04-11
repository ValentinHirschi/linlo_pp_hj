#!/usr/bin/env wolframscript
(* ::Package:: *)

BaseDirectory = FileNameJoin[{PPHJSharedDirectory, "Dependencies"}];

Print["Importing configuration."];
ConfigurationFile = FileNameJoin[{PPHJSharedDirectory, "BaseConfiguration.wls"}];
Get[ConfigurationFile];

SetOptions[OpenAppend, PageWidth -> Infinity]

AppendKernelIDToFileName[fn_] := If[
	$KernelID === 0,
		ExpandFileName[fn],
		ExpandFileName[fn // StringReplace[#, a__ ~~ "." ~~ FileExtension[#] :> a <> "_" <> ToString[$KernelID] <> "." <> FileExtension[#]]&]
	];
	
If[!ShortLogFN === "",
	PutAppend[{DateString[], "INIT"}, AppendKernelIDToFileName[ShortLogFN], CharacterEncoding -> "UTF-8"];
];

RationalizeDigits[ex_, d_] := Sign[ex]FromDigits[RealDigits[ex] // MapAt[#[[1 ;; Min[d, Length @ #]]]&, 1]];
PointPreprocessor := If[InexactNumberQ[#], RationalizeDigits[SetPrecision[#, FloatInputSetPrecisionDigits], FloatInputRationalizeDigits], #]&;

ReadArguments[commandsin2_] := Module[{floatArgs, floatArgsOrig, intArgs, boolArgs, args, commandsin = commandsin2[[2 ;; -1]], calltag},
	calltag = commandsin2[[1]] // ToExpression;
	
	floatArgs = StringReplace[commandsin[[1 ;; 8]], "e" -> "*10^"] // ToExpression // Map[PointPreprocessor];
	floatArgsOrig = StringReplace[commandsin[[1 ;; 8]], "e" -> "*10^"] // ToExpression;
	intArgs = StringReplace[commandsin[[8+1 ;; 8+5]], "e" -> "*10^"] // ToExpression;
	boolArgs = StringReplace[commandsin[[13+1 ;; 13+7]], "e" -> "*10^"] // ToExpression // Map[ # > 0 &];
	
	(* We keep also the unprocessed input, in order to scan for permutations. *)
	args = <| 
	  "calltag" -> calltag,
	  "s" -> floatArgs[[1]],
	  "t" -> floatArgs[[2]],
	  "s_orig" -> floatArgsOrig[[1]],
	  "t_orig" -> floatArgsOrig[[2]],
	  "mu" -> floatArgs[[3]],
	  "mh" -> floatArgs[[4]],
	  "mb" -> floatArgs[[5]],
	  "mt" -> floatArgs[[6]],
	  "mh_orig" -> floatArgsOrig[[4]],
	  "mb_orig" -> floatArgsOrig[[5]],
	  "mt_orig" -> floatArgsOrig[[6]],
	  "yb" -> floatArgs[[7]],
	  "yt" -> floatArgs[[8]],
	  "nloop" -> intArgs[[1]],
	  "eval_mode" -> intArgs[[2]],
	  
	  (* 1, 2, 3 indicate the quark channels. 4 indicates the gluons, 5 the abelian expression provided by Hjalte. *)
	  "selected_channel" -> intArgs[[3]] + 1,
	  
	  Which[
		  ToLowerCase[FFMode] === "abelian",
		     "amplitude_type" -> "abelian",
		  (*ToLowerCase[FFMode] === "full",*)
		  True,
   		  Which[
   		      intArgs[[3]] <= 2,
   		      "amplitude_type" -> "qqhg",
   		      intArgs[[3]] == 3,
   		      "amplitude_type" -> "gghg"
   		  ]
		],
	  
	  "eps_order" -> intArgs[[4]],
	  "nf" -> intArgs[[5]],
	  "is_HEFT" -> boolArgs[[1]],
	  "inc_ytqcd" -> boolArgs[[2]],
	  "inc_ytmb" -> boolArgs[[3]],
	  "inc_ytmt" -> boolArgs[[4]],
	  "inc_ybqcd" -> boolArgs[[5]],
	  "inc_ybmb" -> boolArgs[[6]],
	  "inc_ybmt" -> boolArgs[[7]]
	|>;
	
	Print["Arguments translated: "];
	
	Do[Print @ arg, {arg, Normal @ args}];
	
	If[! MatchQ[args["eval_mode"], 0],
		Print["Only exact mode (0) is enabled in the current version."];
	];
	
	args
];

ProcessingFunctionParallel[commandsin_, kernel_] := Module[{},
	If[$KernelID === kernel,
		Print["Kernel ", $KernelID, " running commands: ", commandsin];
		ProcessingFunction[commandsin];
		,
		Print["Skipping: ", $KernelID, " ", kernel];
	];
];

ProcessingFunction[commandsin_] := Module[{args, outFilename, outString, FormFactors, FudgeFactor, argsAlt},
	(*Print["Arguments received: " <> ToString[commandsin]];*)
	(* Export arguments and sent to log file. *)
	If[!ShortLogFN === "",
		PutAppend[{DateString[], "IN", commandsin}, AppendKernelIDToFileName[ShortLogFN], CharacterEncoding -> "UTF-8"]
	];
	
	outString = "";
	outString = StringJoin[outString, ToString[$ProcessID]<>"\\n"];
	outString = StringJoin[outString, ToString[Join[{ScriptName},commandsin]]<>"\\n"];
	
	outFilename = commandsin[[-1]];	
	args = ReadArguments[commandsin];
	
	If[args["eval_mode"] > 0,
		Print["The interpolated modes are broken at the moment."];
		Abort[];
	];
	
	Which[
		args["eval_mode"] === 0,
		FormFactors = ProcessingFunctionExact[args];

		, args["eval_mode"] === 1,
		FormFactors = ProcessingFunctionInterpolated[args];
		
		, args["eval_mode"] === 2,
		Print["Interpolating 2/1 part."];
		argsAlt = args;
		argsAlt["nloop"] = "2/1";
		FormFactors = ProcessingFunctionInterpolated[argsAlt];
		Print["Processing exact 1L part."];
		
		argsAlt["nloop"] = 1;
		argsAlt["eps_order"] = 0;
		FormFactors *= (ProcessingFunctionExact[argsAlt] // Map[Sqrt[Re[#]^2 + Im[#]^2] &]);
	];
	
	Which[args["nloop"] == 1, FudgeFactor = OneLoopFudgeFactor[args["amplitude_type"]];
		, args["nloop"] == 2, FudgeFactor = TwoLoopFudgeFactor[args["amplitude_type"]];];
	
	FormFactors = FudgeFactor * FormFactors;
	
	(*-----------------------------*)
	outString = StringJoin[outString,"START_OUTPUT_STREAM"<>"\\n"];

	Do[
		outString = StringJoin[outString,(Re[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
	,{ii,Length@FormFactors}];

	Do[ 
		outString = StringJoin[outString,(Im[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
	,{ii,Length@FormFactors}];

	outString = StringJoin[outString,"END_OUTPUT_STREAM\\n"];

	Print[outString // StringReplace[#, "\\n" -> "\n"]&];
	
	Run["python3 -c \"open('"<>outFilename<>"','w').write('"<>outString<>"');\""];
];
