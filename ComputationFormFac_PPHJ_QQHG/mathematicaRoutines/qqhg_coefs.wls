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

If[(Length@$ScriptCommandLine) < 21, Print["Not enough arguments received. Aborting.. "]; Abort[];];

precinput=16; 
floatArgs = Table[ SetPrecision[ImportString[$ScriptCommandLine[[i+1]],"CSV"][[1]][[1]],precinput], {i, 8} ];
intArgs = Table[ ImportString[$ScriptCommandLine[[i+9]],"CSV"][[1]][[1]], {i, 5} ];
boolArgs = Table[ (ImportString[$ScriptCommandLine[[i+14]],"CSV"][[1]][[1]]>0) , {i, 7} ];

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
  "selected_channel" -> intArgs[[3]],
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

Print[];
Print["Parsed arguments received: " <> ToString[args]];
Print[];
Print["Note that yb and yt are currently ignored.."];
Print[];

InterpolationDataLinker = Import["./InterpolationDataLinker.m"];
Get["./qqhg_coefs_computation.m"];

Print["Looking up arguments in linker file.."];

FormFactors=ComputeFormFactors[args, InterpolationDataLinker];

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
