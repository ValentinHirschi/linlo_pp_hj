#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript
(* ::Package:: *)

Get["ExpCan3_Resc.m"];


$Verbose=True;

basedir=Directory[];

Print[basedir];

nvar=4;
nindvar=3;

Do[inputcl[ii]=ToExpression[$ScriptCommandLine[[ii+1]]],{ii,nindvar}];
precinput=ToExpression[$ScriptCommandLine[[nindvar+2]]];
Do[inputcl[ii]=If[Accuracy[inputcl[ii]]===Infinity,inputcl[ii],Rationalize[inputcl[ii],10^(-32)]],{ii,nindvar}]
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

fflistn=fflist/.pin/.canMI[a_,b_,c_]:>INTP[c][[a,b+1]]//Rationalize[#,10^(-32)]&;


print["points evaluated: ", p1li//N]

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
Print[Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Print["END_OUTPUT_STREAM"];



