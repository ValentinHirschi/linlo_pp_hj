
print["loading data... ",Date[]]

FileTag="HJ1L";

SetDirectory[basedir<>"/"<>FileTag]

$NOpti=1
$NSave=1;


nindvar=3;
nvar=4;


$SingBC=False;


ordeps=4;
$PrecTarget=10^(-precinput);
$Offset=10^-6;
$PrecStart=1;


tovv={s -> vv[1], t -> vv[2], b -> vv[3], u -> vv[4]};
tos=tovv/.(a_->b_):>(b->a);
matrix=Get[("atilde_"<>FileTag<>".txt")]//Expand;
tominimalvars={vv[1] -> vv[1], vv[2] -> vv[2], vv[3] -> vv[3], vv[4] -> vv[3] - vv[2] - vv[1]};
atilde=matrix/.tovv;
preCanfuncList=Get[("preCan_functions_"<>FileTag<>".txt")];
dimbasis=atilde//Dimensions//First;
DEFactors=Join[Cases[atilde,Log[a_]:>a,Infinity],Cases[atilde,Sqrt[a_]:>a,Infinity]]//Union;



Do[tominV[vv[ii]]=(vv[ii]/.tominimalvars),{ii,nvar}]

thrV[vv[1]]={4};
thrV[vv[2]]={4};
thrV[vv[3]]={4};
thrV[vv[4]]={4};



print["loaded. ",Date[]]


time=(

Do[

Cont=1;

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

