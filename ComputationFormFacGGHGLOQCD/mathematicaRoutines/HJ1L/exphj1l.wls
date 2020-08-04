#!/usr/bin/env /usr/bin/wolframscript
(* ::Package:: *)

If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
	];


Get[$myImportPath<>"/ExpCan3_Resc.m"];


$Verbose=False;

basedir=Directory[](*$myImportPath*);

Print[basedir];

nvar=4;
nindvar=3;
myVars=4;
Do[kinvars[ii]=Rationalize[SetPrecision[ImportString[$ScriptCommandLine[[ii+1]],"CSV"],32][[1,1]],10^-32],{ii,myVars}];
kinvars[3]=kinvars[3]^2;
Do[inputcl[ii]=kinvars[ii]/kinvars[4]^2,{ii,nindvar}];
rescalingNorm=kinvars[4]^(-3);
loopMeasure=1/(16*Pi^2);
precinput=16;(*ToExpression[$ScriptCommandLine[[nindvar+2]]];*)
p1in=Table[inputcl[ii],{ii,nindvar}];
pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];




p1li={{vv[1],-vv[1]-vv[2]+vv[3],vv[3]},{vv[1],vv[2],vv[3]},{-vv[1]-vv[2]+vv[3],vv[2],vv[3]},{vv[2],vv[1],vv[3]}}/.pin;



FileTagP="HJ1L";
$PrecStart=5;




print[" -------------> PLANAR"];


Get[basedir<>"/"<>FileTagP<>"/"<>FileTagP<>".m"];


print["loading FF ",Date[]];

SetDirectory[basedir];

fflist=Get["FFlist_HJ1L.txt"];

print["loading FF : Done ",Date[]];







Do[INTP[p1li[[ii]]]=Transpose[Get["./"<>FileTagP<>"/BClist/BClist_HJ1L_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];

fflistn=fflist*loopMeasure*rescalingNorm/.pin/.canMI[a_,b_,c_]:>INTP[c][[a,b+1]]//Rationalize[#,10^(-32)]&;


Print["points evaluated: ", p1li//N]

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
Print[Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Print["END_OUTPUT_STREAM"];



