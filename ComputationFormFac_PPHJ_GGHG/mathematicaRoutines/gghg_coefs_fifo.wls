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

lenfifoin=19;

fifoFilename=ToString[$ScriptCommandLine[[-1]]];

InterpolationDataLinker = Import["./InterpolationDataLinker.m"];
Get["./gghg_coefs_computation.m"];

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

If[(Length@fifoin) < 19, Print["Not enough arguments received. Aborting.. "]; Abort[];];

precinput=16; 

floatArgs = Table[ SetPrecision[ImportString[fifoin[[i]],"CSV"][[1]][[1]],precinput], {i, 8} ];
intArgs = Table[ ImportString[fifoin[[i+8]],"CSV"][[1]][[1]], {i, 3} ];
boolArgs = Table[ (ImportString[fifoin[[i+11]],"CSV"][[1]][[1]]>0) , {i, 7} ];

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
"eps_order" -> intArgs[[2]],
"nf" -> intArgs[[3]],
"is_HEFT" -> boolArgs[[1]],
"inc_ytqcd" -> boolArgs[[2]],
"inc_ytmb" -> boolArgs[[3]],
"inc_ytmt" -> boolArgs[[4]],
"inc_ybqcd" -> boolArgs[[5]],
"inc_ybmb" -> boolArgs[[6]],
"inc_ybmt" -> boolArgs[[7]]
|>;

FormFactors=ComputeFormFactors[args, InterpolationDataLinker];

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
