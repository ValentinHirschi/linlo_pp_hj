#!/usr/bin/env wolframscript

If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
];


outFilename=ToString[$ScriptCommandLine[[-1]]];
WriteLine[outFilename,$ProcessID];
WriteLine[outFilename, "Arguments received: "<>ToString[$ScriptCommandLine]];


basedir=Directory[];

precinput=16; 


Print["Arguments received: "<>ToString[$ScriptCommandLine]];
floatArgs = Table[ SetPrecision[ImportString[$ScriptCommandLine[[i+1]],"CSV"][[1]][[1]],precinput], {i, 7} ];
intArgs = Table[ ImportString[$ScriptCommandLine[[i+8]],"CSV"][[1]][[1]], {i, 2} ];
boolArgs = Table[ (ImportString[$ScriptCommandLine[[i+10]],"CSV"][[1]][[1]]>0) , {i, 7} ];
args = <| 
  "s" -> floatArgs[[1]],
  "t" -> floatArgs[[2]],
  "mh" -> floatArgs[[3]],
  "mb" -> floatArgs[[4]],
  "mt" -> floatArgs[[5]],
  "yb" -> floatArgs[[4]],
  "yt" -> floatArgs[[5]],
  "nloop" -> intArgs[[1]],
  "nf" -> intArgs[[2]],
  "is_HEFT" -> boolArgs[[1]],
  "inc_ytqcd" -> boolArgs[[1]],
  "inc_ytmb" -> boolArgs[[2]],
  "inc_ytmt" -> boolArgs[[3]],
  "inc_ybqcd" -> boolArgs[[4]],
  "inc_ybmb" -> boolArgs[[5]],
  "inc_ybmt" -> boolArgs[[6]]
|>
Print["Parsed arguments received: "<>ToString[args]];

FormFactors = {
  Complex[1.1,1.2],
  Complex[1.3,1.4],
  Complex[1.5,1.6],
  Complex[1.7,1.8]
};

FormFactors = {
  Complex[1.1,1.2],
  Complex[1.3,1.4],
  Complex[1.5,1.6],
  Complex[1.7,1.8]
};

WriteLine[outFilename,"START_OUTPUT_STREAM"];

Do[
WriteLine[outFilename,Re[FormFactors[[i]]]//CForm//ToString]
,{i,Length@FormFactors}];

Do[ 
WriteLine[outFilename,Im[FormFactors[[i]]]//CForm//ToString]
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
