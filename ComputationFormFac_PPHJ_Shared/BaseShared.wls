#!/usr/bin/env wolframscript
(* ::Package:: *)

FloatRationalizePrecision = 10^-20;
FRationalize[a_] := Rationalize[a, FloatRationalizePrecision];

(* Fudge factors (ideally we'd like these to be 1.) *)
OneLoopFudgeFactor["gghg"] = 1/(2 Sqrt[2]);
TwoLoopFudgeFactor["gghg"] = 1/(2 Sqrt[2]);
OneLoopFudgeFactor["qqhg"] = 1/(Sqrt[2]);
TwoLoopFudgeFactor["qqhg"] = 1/(Sqrt[2]);

BaseDirectory = FileNameJoin[{PPHJSharedDirectory, "Dependencies"}];

ReadArguments[commandsin__] := Module[{floatArgs, intArgs, boolArgs, precinput = 16, args},
	floatArgs = StringReplace[commandsin[[1 ;; 8]], "e" -> "*10^"] // ToExpression // SetPrecision[#, precinput]& // Map[FRationalize];
	
	intArgs = StringReplace[commandsin[[8+1 ;; 8+5]], "e" -> "*10^"] // ToExpression;
	boolArgs = StringReplace[commandsin[[13+1 ;; 13+7]], "e" -> "*10^"] // ToExpression // Map[ # > 0 &];
	
	args = <| 
	  "s" -> floatArgs[[1]],
	  "t" -> floatArgs[[2]],
	  "mu" -> floatArgs[[3]],
	  "mh" -> floatArgs[[4]],
	  "mb" -> floatArgs[[5]],
	  "mt" -> floatArgs[[6]],
	  "yb" -> floatArgs[[7]],
	  "yt" -> floatArgs[[8]],
	  "nloop" -> intArgs[[1]],
	  "eval_mode" -> intArgs[[2]],
	  
	  (* 1, 2, 3 indicate the quark channels. 4 indicates the gluons. *)
	  "selected_channel" -> intArgs[[3]] + 1,
	  If[intArgs[[3]] <= 2,
	      "amplitude_type" -> "qqhg",
	      "amplitude_type" -> "gghg"
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
	
	args
];

ProcessingFunction[commandsin__] := Module[{args, outFilename, outString, FormFactors, FudgeFactor, argsAlt},
	Print["Arguments received: " <> ToString[commandsin]];
	
	outString = "";
	outString = StringJoin[outString, ToString[$ProcessID]<>"\\n"];
	outString = StringJoin[outString, ToString[Join[{$ScriptCommandLine[[1]]},commandsin]]<>"\\n"];
	
	outFilename = commandsin[[-1]];	

	args = ReadArguments[commandsin];
	
	If[Chop[args["mb"]] === 0 && args["nf"] === 4,
		Print["Cannot run plugin with mb = 0, and nf = 4.. Use nf = 5 for massless bottom quark contributions."];
		Abort[];
	];
	
	If[args["nloop"] === 1 && args["eval_mode"] === 2,
		Print["Can not use nloop = 1 and eval_mode = 2."];
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
