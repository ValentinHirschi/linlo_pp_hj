
FileTag="Planar_EW1";

SetDirectory[basedir<>"/"<>FileTag];

$NOpti=1
$NSave=3;


nindvar=3;
nvar=4;



ordeps=4;
$PrecTarget=10^(-precinput);


tovv={s -> vv[1], t -> vv[2], b -> vv[3], u -> vv[4]};
tos=tovv/.(a_->b_):>(b->a);
matrix=Get[("atilde_"<>FileTag<>".txt")];
tominimalvars={vv[1] -> vv[1], vv[2] -> vv[2], vv[3] -> vv[3], vv[4] -> vv[3] - vv[2] - vv[1]};
atilde=matrix/.tovv;
preCanfuncList=Get[("preCan_functions_"<>FileTag<>".txt")];
dimbasis=atilde//Dimensions//First;
DEFactors=Join[Cases[atilde,Log[a_]:>a,Infinity],Cases[atilde,Sqrt[a_]:>a,Infinity]]//Union;


Do[tominV[vv[ii]]=(vv[ii]/.tominimalvars),{ii,nvar}]

thrV[vv[1]]={0,1};
thrV[vv[2]]={0,1};
thrV[vv[3]]={0,1,4};
thrV[vv[4]]={0,1,4};





time=(

Do[

p1=setp1;

ImportBC[];
Setp0[];
If[p0 === p1, print["Already computed"];Goto[skip]];
SetGlobalV[];


result01=ContourExpandMV[atilde,cov,pli,acc,ordeps];

SaveRes[];

Label[skip];

,{setp1,p1li}];


)//AbsoluteTiming//First;


(*PutAppend[{time,numpoint,Length@pli,p0->p1//N,p0->p1},"time.txt"];*)
print["done in :",time];

