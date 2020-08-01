#!/usr/bin/env /usr/bin/wolframscript  
(* ::Package:: *)

(* francescos huge filenames lead to errors with maximal length of path variables :( *)

$mypath= FileNameJoin[{DirectoryName @ $InputFileName, ""}];
SetDirectory[$mypath]
$mypath = ".";
$verbose=False;


Get[$mypath<>"/ExpCan2.m"];

nindvar=3;
nvar=4;

Do[inputcl[ii]=ToExpression[$ScriptCommandLine[[ii+1]]],{ii,nindvar}];
precinput=ToExpression[$ScriptCommandLine[[nindvar+2]]];
Do[inputcl[ii]=If[Accuracy[inputcl[ii]]===Infinity,inputcl[ii],Rationalize[inputcl[ii],10^(-32)]],{ii,nindvar}];
p1=Table[inputcl[ii],{ii,nindvar}];



FileTag="GGHG";
ordeps=3;
$PrecTarget=10^(-precinput);


tovv={s -> vv[1], t -> vv[2], b -> vv[3], u -> vv[4]};
tos=tovv/.(a_->b_):>(b->a);
tominimalvars={vv[1] -> vv[1], vv[2] -> vv[2], vv[3] -> vv[3], vv[4] -> vv[3] - vv[2] - vv[1]};
matrix=Get[($mypath<>"/atilde_"<>FileTag<>".txt")]/.mm->1/.eps->1//Expand;
atilde=matrix/.tovv;
dimbasis=atilde//Dimensions//First;





Do[tominV[vv[ii]]=(vv[ii]/.tominimalvars),{ii,nvar}];

thrV[vv[1]]={4};
thrV[vv[2]]={4};
thrV[vv[3]]={4};
thrV[vv[4]]={4};


Setp0[];


If[$verbose==True, Print[p0]];



If[p0===p1,If[$verbose==True,Print["Already Computed"]];Return[1]];

If[$verbose==True,
Print["Expanding from -> to: ", N[p0->p1]]
];


SetGlobalV[];
result01="err"->"err";
errCheck=CheckEndPSing[$verbose];
If[errCheck==0,Return[0]];
Length@pli;
While[result01[[1]]==="err"&&iBClist<=Length[bclist]&&iBClist<10&&acc<=500&&Cont===1,
CheckSegments[];
result01=ContourExpandMV[atilde,cov,pli,$mypath<>"/Log_"<>FileTag<>"_p"<>pointtostr[p1]<>".txt",acc,ordeps,$verbose];
CheckErr[];
];
CheckLargeLogs[];
SaveRes[];
1

