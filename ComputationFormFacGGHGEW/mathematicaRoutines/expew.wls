#!/usr/bin/env wolframscript
(* ::Package:: *)

(*#!/usr/bin/env /Applications/Mathematica.app/Contents/MacOS/wolframscript*)


If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
];


Get["ExpCan4_Reg.wl"];



$Verbose=False;

basedir=Directory[];


nvar=4;
nindvar=3;
myVars=4;

outFilename=ToString[$ScriptCommandLine[[-1]]];
WriteLine[outFilename, "Arguments received: "<>ToString[$ScriptCommandLine]];
Print["Arguments received: "<>ToString[$ScriptCommandLine]];
Do[kinvars[ii]=Rationalize[SetPrecision[ImportString[$ScriptCommandLine[[ii+1]],"CSV"],32][[1,1]],10^-36],{ii,myVars}];
kinvars[3]=kinvars[3]^2;
Do[inputcl[ii]=Rationalize[N[kinvars[ii]/kinvars[4]^2,100],10^-16],{ii,nindvar}];
(* three dimension from the projector and one from the couplings *)
rescalingNorm=kinvars[4]^(-4);
loopMeasure=-(1/(4 Pi)^4);
precinput=16;(*ToExpression[$ScriptCommandLine[[nindvar+2]]];*)
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

(*If[Length[posdiffWZ]=!=1||Length,Print["no mass ratio"];PutAppend[{" no mass ratio ",p1in},"err_log.txt"];Quit[]];*)

If[posdiffWZ==={1},$Mass="W";print[Boson->$Mass]];
If[posdiffWZ==={2},$Mass="Z";print[Boson->$Mass]];

p1in[[$PosMass]]=ratMli[[posdiffWZ//First]];
pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];


print["ps point ", pin, pin//N]


gram3 = -2 vv[1]^2 vv[2] - 2 vv[1] vv[2]^2 + 2 vv[1] vv[2] vv[3]/.pin;
print["gram ", gram3];
If[gram3<0,PrintAndSaveErrorAbort["non-phys point"]];

p1li={{vv[1],-vv[1]-vv[2]+vv[3],vv[3]},{vv[1],vv[2],vv[3]},{-vv[1]-vv[2]+vv[3],vv[2],vv[3]},{vv[2],vv[1],vv[3]}}/.pin;


print[p1li];

FileTagP="Planar_EW1";
FileTagNP="NP_EW1";


Table[

FileTag=famName;
Print[" *** ",famName, " *** "];
Get["expewmi.m"];

,{famName,{"Planar_EW1","NP_EW1"}}]





SetDirectory[basedir];

print["loading FF ",Date[]];

Get["FFlist.mx"];

print["loading FF : Done ",Date[]];

Do[INTP[p1li[[ii]]]=Transpose[Get["./"<>FileTagP<>"/BClist/BClist_"<>FileTagP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];
Do[INTNP[p1li[[ii]]]=Transpose[Get["./"<>FileTagNP<>"/BClist/BClist_"<>FileTagNP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];

print["n ff"];

(*fflistn=fflist/.pin/.{canMINP[a_,b_,c_]:>INTNP[c][[a,b+1]],canMIPlanar[a_,b_,c_]:>INTP[c][[a,b+1]]}//Rationalize[#,10^(-32)]&;*)

pinN=#[[1]]->N[#[[2]],acc]&/@pin;

(*print[pinN];*)

fflistn=(rescalingNorm*loopMeasure*fflist/.{canMINP[a_,b_,c_]:>INTNP[c/.pin][[a,b+1]],canMIPlanar[a_,b_,c_]:>INTP[c/.pin][[a,b+1]]}/.pinN//Rationalize[#,10^(-32)]&);


print["n ff done"];

print["Points evaluated ",p1li//N]

WriteLine[outFilename,"START_OUTPUT_STREAM"];

Do[
WriteLine[outFilename,Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
WriteLine[outFilename,Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

WriteLine[outFilename,"END_OUTPUT_STREAM"];

(* Safety short pause to make sure its flushed *)
Pause[0.1];

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
Print[Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Print["END_OUTPUT_STREAM"];

Exit[];
