#!/usr/bin/env /usr/bin/wolframscript	
(* ::Package:: *)

	$myEvalPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myEvalPath];
	$myEvalPath=".";
	Get["./computeMIsGGGH.m"];
	Get["./evaluation_amp.m"];
	myVars=4;
	Print[$ScriptCommandLine]
	(* expect format s,t,mH,mT *)
	
	Do[kinvars[ii]=SetPrecision[ImportString[$ScriptCommandLine[[ii+1]],"PythonExpression"],32],{ii,myVars}];
	
	allResults=computeFormFactors[kinvars[1],kinvars[2],kinvars[3],kinvars[4]];
	transToPyt[res_]:=StringReplace[ToString[(res /.y_/;NumberQ[y]&&(Abs@y>=1&&Abs@y<=10&&!IntegerQ[y]):>N[y,32])/.y_/;NumberQ[y]&&(Abs@y<1||Abs@y>10)&&!IntegerQ[y] :>ScientificForm[N[y,32],NumberFormat->(Row[{#1,"e",#3}]&)]],{"{"->"[","}"->"]"}];
	Table[Print["forfac "<>ToString[forfacCount]]; Print[transToPyt[allResults[[forfacCount]]]],{forfacCount,4}]
	
