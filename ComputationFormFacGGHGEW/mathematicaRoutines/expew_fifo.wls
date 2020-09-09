#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript
(* ::Package:: *)

(*#!/usr/bin/env wolframscript*)


If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
];


Get["ExpCan4_Reg.wl"];


PrintAndSaveErrorAbort[text__]:=(
PutAppend[{{text},": "<>ToString[p0->p1//InputForm//ToString]},ErrorLogFile];
outString=StringJoin[outString,"START_OUTPUT_STREAM"<>"\n"];
outString=StringJoin[outString,"NaN"<>"\n"];
outString=StringJoin[outString,"END_OUTPUT_STREAM"];
Run["echo '"<>outString<>"' > "<>outFilename];
saveQ=False;
If[$script,Quit[],Abort[]]
)


$grid=False;
$Verbose=False;
$delQ=True;


basedir=Directory[];


nvar=4;
nindvar=3;
myVars=4;
precinput=16; 
lenfifoin=5;


fifoFilename=ToString[$ScriptCommandLine[[-1]]];


While[True,



fifoin={};
While[
Length[fifoin]=!=lenfifoin&&(Head/@fifoin)=!=ConstantArray[String, lenfifoin],
fifoin=StringSplit[RunProcess[{"cat",fifoFilename}]["StandardOutput"]]
];

print["fifo read! ", fifoin];


outString="";
outString=StringJoin[outString,ToString[$ProcessID]<>"\n"];
outString=StringJoin[outString,ToString[Join[{$ScriptCommandLine[[1]]},fifoin]]<>" \n"];



outFilename=fifoin[[-1]];



Do[kinvars[ii]=Rationalize[SetPrecision[ImportString[fifoin[[ii]],"CSV"],32][[1,1]],10^-36],{ii,myVars}];
kinvars[3]=kinvars[3]^2;


Do[inputcl[ii]=Rationalize[N[kinvars[ii]/kinvars[4]^2,100],10^-(precinput)],{ii,nindvar}];

rescalingNorm=kinvars[4]^(-4);
loopMeasure=-(1/(4 Pi)^4);


p1in=Table[inputcl[ii],{ii,nindvar}];


ratHW=13074/5399;
ratHZ=14631/7775;


(*ratW*)
(*2.4215595462944548356.*)
(*ratZ*)
(*1.8818006492491412770.*)


ratMli={ratHW,ratHZ};
posdiffWZ=Position[p1in[[$PosMass]]-ratMli//Abs,a_/;a<10^-4]//Flatten;
If[Length[posdiffWZ]=!=1,PrintAndSaveErrorAbort["no mass ratio"]];

If[posdiffWZ==={1},$Mass="W";print[Boson->$Mass]];
If[posdiffWZ==={2},$Mass="Z";print[Boson->$Mass]];

p1in[[$PosMass]]=ratMli[[posdiffWZ//First]];
pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];


print["ps point ", pin, pin//N];


gram3 = -2 vv[1]^2 vv[2] - 2 vv[1] vv[2]^2 + 2 vv[1] vv[2] vv[3]/.pin;
print["gram ", gram3];
If[gram3<0,PrintAndSaveErrorAbort["non-phys point"]];

p1li={{vv[1],-vv[1]-vv[2]+vv[3],vv[3]},{vv[1],vv[2],vv[3]},{-vv[1]-vv[2]+vv[3],vv[2],vv[3]},{vv[2],vv[1],vv[3]}}/.pin;


print[p1li];

FileTagP="Planar_EW1";
FileTagNP="NP_EW1";


Table[

FileTag=famName;
print[" *** ",famName, " *** "];
Get["expewmi_fifo.m"];

,{famName,{"Planar_EW1","NP_EW1"}}];





SetDirectory[basedir];

print["loading FF ",Date[]];

Get["FFlist.mx"];

print["loading FF : Done ",Date[]];

Do[INTP[p1li[[ii]]]=Transpose[Get["./"<>FileTagP<>"/BClist/BClist_"<>FileTagP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];
Do[INTNP[p1li[[ii]]]=Transpose[Get["./"<>FileTagNP<>"/BClist/BClist_"<>FileTagNP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];

print["n ff"];


pinN=#[[1]]->N[#[[2]],acc]&/@pin;

(*print[pinN];*)

fflistn=(rescalingNorm*loopMeasure*fflist/.{canMINP[a_,b_,c_]:>INTNP[c/.pin][[a,b+1]],canMIPlanar[a_,b_,c_]:>INTP[c/.pin][[a,b+1]]}/.pinN//Rationalize[#,10^(-32)]&);


print["n ff done"];



(*--------delete files----------*)


If[!$grid && $delQ===True,

Do[

fileToBeDeleted=("./"<>famName<>"/BClist/BClist_"<>famName<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt");
print["deleting ",fileToBeDeleted];
DeleteFile[fileToBeDeleted]
,{famName,{"Planar_EW1","NP_EW1"}},{ii,Length@p1li}];

];



(*-----------------------------*)



print["Points evaluated ",p1li//N];

outString=StringJoin[outString,"START_OUTPUT_STREAM"<>"\n"];

Do[
outString=StringJoin[outString,(Re[fflistn[[ii]]]//CForm//ToString)<>"\n"]
,{ii,Length@fflistn}];

Do[ 
outString=StringJoin[outString,(Im[fflistn[[ii]]]//CForm//ToString)<>"\n"]
,{ii,Length@fflistn}];

outString=StringJoin[outString,"END_OUTPUT_STREAM"];

print[outString];

Run["echo '"<>outString<>"' > "<>outFilename];




];
