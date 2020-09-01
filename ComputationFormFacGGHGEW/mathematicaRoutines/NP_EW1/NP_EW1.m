(* ::Package:: *)

Quit[]


SetDirectory[NotebookDirectory[]];


Get["../../Expansion/ExpCan4.m"];
FileTag="NP_EW1";




precinput=16;
$PrecStart=10;
$SegTolerance=10^(-2);
$Offset=10^(-4);
$Increment=10;
$NSave=1;
$NOpti=1

nindvar=3;
nvar=4;



ordeps=4;
$PrecTarget=10^(-precinput);




tovv={s -> vv[1], t -> vv[2], b -> vv[3], u -> vv[4]};
tos=tovv/.(a_->b_):>(b->a);
tominimalvars={vv[1] -> vv[1], vv[2] -> vv[2], vv[3] -> vv[3], vv[4] -> vv[3] - vv[2] - vv[1]};
matrix=Get[("atilde_"<>FileTag<>".txt")];
atilde=matrix/.tovv;
preCanfuncList=Get[("preCan_functions_"<>FileTag<>".txt")];
dimbasis=atilde//Dimensions//First;
DEFactors=Join[Cases[atilde,Log[a_]:>a,Infinity],Cases[atilde,a_^r_Rational:>a,Infinity]]//Union;
AlgebraicArguments=Cases[atilde,a_^r_Rational:>Expand[a],Infinity]//Union;


Do[tominV[vv[ii]]=(vv[ii]/.tominimalvars),{ii,nvar}]

thrV[vv[1]]:={If[$SingBC,{},0],1}//Flatten
thrV[vv[2]]:={If[$SingBC,{},0],1}//Flatten
thrV[vv[3]]:={If[$SingBC,{},0],1,4}//Flatten
thrV[vv[4]]:={If[$SingBC,{},0],1,4}//Flatten


AbsentThrList["Planar_EW1"]={};
AbsentThrList["NP_EW1"]={vv[2],vv[3]};


(*CheckRootsSanity[Cases[atilde,a_^r_Rational:>Expand[a],Infinity]//Union];*)


test={1694906024/901248013, -107726/73243417, 14631/7775} -> {256988549/136691081, -44917/55341766, 14631/7775};
CheckGram[a_]:=Module[{},

pmap=MapThread[#1->#2&,{Table[vv[ii],{ii,3}],a}];
gram3 = -2 vv[1]^2 vv[2] - 2 vv[1] vv[2]^2 + 2 vv[1] vv[2] vv[3]/.pmap;
If[gram3<0,False,True]

]



p1={24298717/12913573, -28738/159140007, 14631/7775};

ImportBC[];
Setp0[];


$SingBC=If[Union[p0]==={0},True,False];
If[p0 === p1, print["Already computed"]];
SetGlobalV[];


$script=False


result01=ContourExpandMV[atilde,cov,pli,acc,ordeps];

(*If[saveQ,SaveRes[]];*)




If[saveQ,SaveRes[]];


Get["BClist/BClist_NP_EW1_p"<>ToString[Hash[p1]]<>".txt"][[2]]-Get["BClist/backup/BClist_NP_EW1_p"<>ToString[Hash[p1]]<>".txt"][[2]]//N//Abs//Max





(*-----*)

fnli="BClist/"<>#&/@StringSplit["BClist_NP_EW1_p2486544694660305787.txt
BClist_NP_EW1_p3258978574170028993.txt
BClist_NP_EW1_p2470122677842289500.txt
BClist_NP_EW1_p3403084517130045782.txt"]
fnlib=StringReplace[#,"/"->"/backup/"]&/@fnli


Table[Get[fnli[[ii]]][[2]]-Get[fnlib[[ii]]][[2]]//N//Abs//Max,{ii,Length@fnli}]//Abs//Max


Position[{1,2},a_/;a>1]//Flatten


{1,2}[[2]]


tominV[vv[4]]/.{vv[1]->0.9689655172413794`,vv[2]->-0.47586206896551725`,vv[3]->-0.47586206896551725`}




