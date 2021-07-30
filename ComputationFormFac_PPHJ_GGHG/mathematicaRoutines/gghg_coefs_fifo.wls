#!/usr/bin/env wolframscript
(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)

If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
];


PrintAndSaveErrorAbort[text__]:=(
PutAppend[{{text},": "<>ToString[p0->p1//InputForm//ToString]},ErrorLogFile];
outString=StringJoin[outString,"START_OUTPUT_STREAM"<>"\\n"];
outString=StringJoin[outString,"NaN"<>"\\n"];
outString=StringJoin[outString,"END_OUTPUT_STREAM\\n"];
(*Run["echo '"<>outString<>"' > "<>outFilename];*)
Run["python3 -c \"open('"<>outFilename<>"','w').write('"<>outString<>"');\""];
saveQ=False;
If[$script,Quit[],Abort[]]
)

basedir=Directory[];

lenfifoin=16;

fifoFilename=ToString[$ScriptCommandLine[[-1]]];


While[True,



fifoin={};
While[
Length[fifoin]=!=lenfifoin&&(Head/@fifoin)=!=ConstantArray[String, lenfifoin],
fifoproc=StartProcess[{"cat",fifoFilename}];
While[ProcessStatus[fifoproc]==="Running",Pause[1]];
fifoin=StringSplit[ReadString[fifoproc]];
KillProcess[fifoproc]
];
Print["fifo read! ", fifoin];


outString="";
outString=StringJoin[outString,ToString[$ProcessID]<>"\\n"];
outString=StringJoin[outString,ToString[Join[{$ScriptCommandLine[[1]]},fifoin]]<>"\\n"];

outFilename=fifoin[[-1]];

Print["Arguments received: "<>ToString[fifoin]];
floatArgs = Table[ SetPrecision[ImportString[fifoin[[i+1]],"CSV"][[1]][[1]],precinput], {i, 7} ];
intArgs = Table[ ImportString[fifoin[[i+8]],"CSV"][[1]][[1]], {i, 1} ];
boolArgs = Table[ (ImportString[fifoin[[i+9]],"CSV"][[1]][[1]]>0), {i, 7} ];
args = <| 
  "s" -> floatArgs[[1]],
  "t" -> floatArgs[[2]],
  "mh" -> floatArgs[[3]],
  "mb" -> floatArgs[[4]],
  "mt" -> floatArgs[[5]],
  "yb" -> floatArgs[[4]],
  "yt" -> floatArgs[[5]],
  "nloop" -> intArgs[[1]],
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

(*-----------------------------*)

outString=StringJoin[outString,"START_OUTPUT_STREAM"<>"\\n"];

Do[
outString=StringJoin[outString,(Re[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
,{ii,Length@FormFactors}];

Do[ 
outString=StringJoin[outString,(Im[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
,{ii,Length@FormFactors}];

outString=StringJoin[outString,"END_OUTPUT_STREAM\\n"];

print[outString];

(*Run["echo '"<>outString<>"' > "<>outFilename];*)
Run["python3 -c \"open('"<>outFilename<>"','w').write('"<>outString<>"');\""];

];
