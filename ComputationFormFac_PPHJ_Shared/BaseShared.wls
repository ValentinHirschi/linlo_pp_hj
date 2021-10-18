#!/usr/bin/env wolframscript
(* ::Package:: *)

OneLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);
TwoLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);

BaseDirectory = FileNameJoin[{PPHJSharedDirectory, "Dependencies"}];

ReadArguments[commandsin__] := Module[{floatArgs, intArgs, boolArgs, precinput = 16},
	floatArgs = Table[ SetPrecision[ImportString[commandsin[[i]],"CSV"][[1]][[1]],precinput], {i, 8} ];
	intArgs = Table[ ImportString[commandsin[[i+8]],"CSV"][[1]][[1]], {i, 4} ];
	boolArgs = Table[ (ImportString[commandsin[[i+12]],"CSV"][[1]][[1]]>0) , {i, 7} ];
	
	<|
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
		"eps_order" -> intArgs[[3]],
		"nf" -> intArgs[[4]],
		"is_HEFT" -> boolArgs[[1]],
		"inc_ytqcd" -> boolArgs[[2]],
		"inc_ytmb" -> boolArgs[[3]],
		"inc_ytmt" -> boolArgs[[4]],
		"inc_ybqcd" -> boolArgs[[5]],
		"inc_ybmb" -> boolArgs[[6]],
		"inc_ybmt" -> boolArgs[[7]]
	|>
];

ProcessingFunction[commandsin__] := Module[{args, outFilename, outString, FormFactors, FudgeFactor},
	Print["Arguments received: " <> ToString[commandsin]];
	
	outString = "";
	outString = StringJoin[outString, ToString[$ProcessID]<>"\\n"];
	outString = StringJoin[outString, ToString[Join[{$ScriptCommandLine[[1]]},commandsin]]<>"\\n"];
	
	outFilename = commandsin[[-1]];	

	args = ReadArguments[commandsin];
	
	If[!(args["inc_ytqcd"] === args["inc_ytmt"]),
		Print["inc_ytqcd and inc_ytmt cannot currently be separated."];
		Abort[];
	];
	
	If[!(args["inc_ybqcd"] === args["inc_ybmb"]),
		Print["inc_ybqcd and inc_ybmb cannot currently be separated."];
		Abort[];
	];
	
	If[Chop[args["mb"]] === 0 && args["nf"] === 4,
		Print["Cannot run plugin with mb = 0, and nf = 4.. Use nf = 5 for massless bottom quark contributions."];
		Abort[];
	];
(*	
	If[(Or @@ {args["inc_ytmb"], args["inc_ybqcd"], args["inc_ybmb"], args["inc_ybmt"]}) || (args["nf"] \[NotEqual] 5),
		Print["Massive bottom contributions not supported at the moment."];
		Abort[];
	];*)
	
	Which[
		args["eval_mode"] === 0,
		FormFactors = ProcessingFunctionExact[args];

		, args["eval_mode"] === 1,
		FormFactors = ProcessingFunctionInterpolated[args];
		
		, args["eval_mode"] === 2,
		Print["This mode is not supported yet.."];
		Abort[];
	];
	
	Which[args["nloop"] == 1, FudgeFactor = OneLoopFudgeFactor;
		, args["nloop"] == 2, FudgeFactor = TwoLoopFudgeFactor; ];
	
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