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
(* three dimension from the projector and one from the couplings *)
rescalingNorm=kinvars[4]^(-4);
loopMeasure=-(1/(4 Pi)^4);
precinput=16;(*ToExpression[$ScriptCommandLine[[nindvar+2]]];*)
p1in=Table[inputcl[ii],{ii,nindvar}];
pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];




p1li={{vv[1],-vv[1]-vv[2]+vv[3],vv[3]},{vv[1],vv[2],vv[3]},{-vv[1]-vv[2]+vv[3],vv[2],vv[3]},{vv[2],vv[1],vv[3]}}/.pin;


FileTagP="Planar_EW1";
FileTagNP="NP_EW1";
$PrecStart=2;
$SegTolerance=10^(-2);
$Offset=10^(-4);
$Increment=10;


print[" -------------> PLANAR"];

Get[basedir<>"/"<>FileTagP<>"/"<>FileTagP<>".m"];

print[" -------------> NON-PLANAR"];

Get[basedir<>"/"<>FileTagNP<>"/"<>FileTagNP<>".m"];





print["loading FF ",Date[]];

SetDirectory[basedir];

Get["FFlist.mx"];

print["loading FF : Done ",Date[]];

Do[INTP[p1li[[ii]]]=Transpose[Get["./"<>FileTagP<>"/BClist/BClist_Planar_EW1_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];
Do[INTNP[p1li[[ii]]]=Transpose[Get["./"<>FileTagNP<>"/BClist/BClist_NP_EW1_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];

fflistn=rescalingNorm*loopMeasure*fflist/.pin/.{canMINP[a_,b_,c_]:>INTNP[c][[a,b+1]],canMIPlanar[a_,b_,c_]:>INTP[c][[a,b+1]]}//Rationalize[#,10^(-32)]&;

print["Points evaluated ",p1li//N]

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
Print[Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Print["END_OUTPUT_STREAM"];


