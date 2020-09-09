(* ::Package:: *)

SetDirectory[basedir<>"/"<>FileTag];


acc=100;
ieps0=I 10^(-acc/2);




$PrecStart=5;
$SegTolerance=10^(-2);
$Offset=10^(-4);
$Increment=5;
$NSave=1;
$NOpti=1

nindvar=3;
nvar=4;



ordeps=4;
$PrecTarget=10^(-precinput);


print["loading..."];

tovv={s -> vv[1], t -> vv[2], b -> vv[3], u -> vv[4]};
tos=tovv/.(a_->b_):>(b->a);
matrix=Get[("atilde_"<>FileTag<>".txt")];
tominimalvars={vv[1] -> vv[1], vv[2] -> vv[2], vv[3] -> vv[3], vv[4] -> vv[3] - vv[2] - vv[1]};
atilde=matrix/.tovv;
preCanfuncList=Get[("preCan_functions_"<>FileTag<>".txt")];
dimbasis=atilde//Dimensions//First;
DEFactors=Join[Cases[atilde,Log[a_]:>a,Infinity],Cases[atilde,a_^r_Rational:>a,Infinity]]//Union;
DEFactorsRat=(RationalDen/@DEFactors)//Flatten//Union;
AlgebraicArguments=Cases[atilde,a_^r_Rational:>Expand[a],Infinity]//Union;

print["loading done"];

(*print[DEFactorsRat];*)

Do[tominV[vv[ii]]=(vv[ii]/.tominimalvars),{ii,nvar}]

thrV[vv[1]]={0,1};
thrV[vv[2]]={0,1};
thrV[vv[3]]={0,1,4};
thrV[vv[4]]={0,1,4};



AbsentThrList["Planar_EW1"]={};
AbsentThrList["NP_EW1"]={vv[2],vv[3]};



RegionLabel=$Mass;
ImportBCRegion[];

time=(

Do[

print[RegionLabel];

p1=p1li[[iip1]];
Setp0[];

If[p0===p1,
print["Already computed"];
$delQ=False;
Goto[skip]
];



SetGlobalV[];


result01=ContourExpandMV[atilde,cov,pli,acc,ordeps];

If[saveQ,SaveResRegion[]];

Label[skip];

,{iip1,Length@p1li}];


)//AbsoluteTiming//First;


(*PutAppend[{time,numpoint,Length@pli,p0->p1//N,p0->p1},"time.txt"];*)
print["done in :",time];

SetDirectory[basedir];
