#!/usr/bin/env wolframscript
(* ::Package:: *)

If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
];


outFilename=ToString[$ScriptCommandLine[[-1]]];
WriteLine[outFilename, $ProcessID];
WriteLine[outFilename, "Arguments received: "<>ToString[$ScriptCommandLine]];


Print["Arguments received: "<>ToString[$ScriptCommandLine]];

If[(Length@$ScriptCommandLine) < 18, Print["Not enough arguments received. Aborting.. "]; Abort[];];

floatArgs = $ScriptCommandLine[[2;;9]] // Map[N@*ToExpression];
intArgs = $ScriptCommandLine[[10;;11]] // Map[Round@*N@*ToExpression];
boolArgs = $ScriptCommandLine[[12;;18]] // Map[ToExpression[#]>0&];

args = <| 
  "s" -> floatArgs[[1]],
  "t" -> floatArgs[[2]],
  "mh" -> floatArgs[[3]],
  "mb" -> floatArgs[[4]],
  "mt" -> floatArgs[[5]],
  "yb" -> floatArgs[[6]],
  "yt" -> floatArgs[[7]],
  "mu" -> floatArgs[[8]],
  "nloop" -> intArgs[[1]],
  "nf" -> intArgs[[2]],
  "is_HEFT" -> boolArgs[[1]],
  "inc_ytqcd" -> boolArgs[[2]],
  "inc_ytmb" -> boolArgs[[3]],
  "inc_ytmt" -> boolArgs[[4]],
  "inc_ybqcd" -> boolArgs[[5]],
  "inc_ybmb" -> boolArgs[[6]],
  "inc_ybmt" -> boolArgs[[7]]
|>

Print[];
Print["Parsed arguments received: " <> ToString[args]];
Print[];
Print["Note that yb and yt are currently ignored.."];
Print[];

InterpolationDataLinker = Import["./InterpolationDataLinker.m"];

Print["Looking up arguments in linker file.."];

LinkerKey = Null;
Do[
	SatisfiesArguments = True;
	
	CurrentConditionals = {
		{N[args["mh"] - LinkerConditionals["mh"]] === 0., "mh doesn't match"},
		{N[args["mb"] - LinkerConditionals["mb"]] === 0., "mb doesn't match"},
		{N[args["mt"] - LinkerConditionals["mt"]] === 0., "mt doesn't match"},
		{MatchQ[args["nloop"], LinkerConditionals["nloop"]] === True, "nloop doesn't match"},
		{args["nf"] - LinkerConditionals["nf"] === 0, "nf doesn't match"},
		{args["is_HEFT"] === LinkerConditionals["is_HEFT"], "is_HEFT doesn't match"},
		{args["inc_ytqcd"] === LinkerConditionals["inc_ytqcd"], "inc_ytqcd doesn't match"},
		{args["inc_ytmb"] === LinkerConditionals["inc_ytmb"], "inc_ytmb doesn't match"},
		{args["inc_ytmt"] === LinkerConditionals["inc_ytmt"], "inc_ytmt doesn't match"},
		{args["inc_ybqcd"] === LinkerConditionals["inc_ybqcd"], "inc_ybqcd doesn't match"},
		{args["inc_ybmb"] === LinkerConditionals["inc_ybmb"], "inc_ybmb doesn't match"},
		{args["inc_ybmt"] === LinkerConditionals["inc_ybmt"], "inc_ybmt doesn't match"},
		{(LinkerConditionals["stRange"] /. {s -> args["s"], t -> args["t"]}) === True, "Range of s,t doesn't fit."}
	};
	
	If[!(And@@CurrentConditionals[[All,1]]),
		SatisfiesArguments = False;
		Print["Skipping entry. Reasons: ",
			CurrentConditionals[[Flatten[Position[CurrentConditionals[[All, 1]], False]],2]]
		];
	];
	
	If[SatisfiesArguments,
		Print["Found suitable datafile..: ", InterpolationDataLinker[LinkerConditionals][[2]]];
		LinkerKey = LinkerConditionals;
		Return["", Do];
	];
	, {LinkerConditionals, InterpolationDataLinker//Keys}
];

If[LinkerKey === Null,
	Print["No datafile found for the current configuration options.."];
];

InterpolationDataLinker2 = InterpolationDataLinker[LinkerKey];
InterpolationData = Import[InterpolationDataLinker2[[2]]] // Association; 
nmFromst = {n,m} //. (InterpolationDataLinker2[[1]] /. {s -> args["s"], t -> args["t"]});

Print["n = ", nmFromst[[1]], ", m = ", nmFromst[[2]], "."];
Print[];

FormFactors = Table[
	Sum[
		(
		  InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, 0, muord, Re}][Sequence @@ nmFromst] + 
		  I InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, 0, muord, Im}][Sequence @@ nmFromst]
		) * (Log[mmuu]^muord /. mmuu -> args["mu"])
	, {muord, 0, Which[args["nloop"] == 1, 0, args["nloop"] == 2, 2]}]
, {ffind, 4}];

WriteLine[outFilename,"START_OUTPUT_STREAM"];

Do[
WriteLine[outFilename, Re[FormFactors[[i]]] // CForm // ToString]
,{i,Length@FormFactors}];

Do[ 
WriteLine[outFilename, Im[FormFactors[[i]]] // CForm // ToString]
,{i,Length@FormFactors}];

WriteLine[outFilename,"END_OUTPUT_STREAM"];

(* Safety short pause to make sure its flushed *)
Pause[0.03];

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[FormFactors[[i]]]//CForm//ToString]
,{i,Length@FormFactors}];

Do[ 
Print[Im[FormFactors[[i]]]//CForm//ToString]
,{i,Length@FormFactors}];

Print["END_OUTPUT_STREAM"];

Exit[];
