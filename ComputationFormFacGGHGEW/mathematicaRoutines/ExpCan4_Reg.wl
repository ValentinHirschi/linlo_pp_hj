(* ::Package:: *)

(*TODO 

*)

(*Assumes that the cov is linear*)
(*NOTE: singular boundary conditions must have only Log[x], no Log[-x] or Log[c x]*)




Print[">>>ExpCan4_Reg.m<<<"]



SetOptions[OpenAppend, PageWidth -> Infinity];

$forcestdbc=False;
$grid=True;
$script=True;
$PosMass=3;
saveQ=True;
$HistoryLength=1;
$MaxExtraPrecision=100;
$SingBC=False;
$ExtraPrec=10;
iBClist=1;
acc=200;
ieps0=I 10^(-acc/2);
distsing=1/2;
$debug=False;
$PercDrop=0.98;
$NOpti=1;
jacobianslist={};
ErrorLogFile="err_log.txt";
$NSave=1;
preCanfuncList={};
$Verbose=True;
$SegTolerance=10^(-3);
$Increment=10;


SetAttributes[print,HoldAll]


print[a__]:=If[$Verbose,Print[a," ",Date[]]]


ginsh[int_,prec_,{t1_?NumericQ,t2_?NumericQ}]:=Module[{
out,
dig,
def,
res,
eval,
chk,
quit},

out=StringReplace[StringReplace[StringReplace[ToString[int/.G[a__,x_]:>G[{a},x],CForm],{"Complex("~~Shortest[a__]~~","~~Shortest[b__]~~")":>"["~~a~~"+I*"~~b~~"]"}],{"List("~~Shortest[a__]~~")":>"{"~~a~~"}"}],{"e"->"E","Log"->"log","Sqrt"->"sqrt","Pi"->"pi","["->"(","]"->")"}];
dig="Digits="~~ToString[prec]~~":\n\n";
chk="iv={"~~ToString[t1,CForm]~~","~~ToString[t2,CForm]~~"}:\n\n";
def="exp="~~out~~":\n\n";
eval="evalf(exp);\n\n";
quit="quit:";

If[$deb==1,print[def];AppendTo[$ivli,{t1,t2}]];

Export["/Users/francescomoriello/Dropbox/HyperInt/ginac.txt",StringJoin[dig,chk,def,eval,quit]];
Run["/usr/local/Cellar/ginac/1.7.2/bin/ginsh /Users/francescomoriello/Dropbox/HyperInt/ginac.txt > /Users/francescomoriello/Dropbox/HyperInt/ginac_out.txt"];
res=StringReplace[Import["/Users/francescomoriello/Dropbox/HyperInt/ginac_out.txt"],{"E"->"*^","i"->"I"}]//ToExpression
(*print[res//ToExpression];*)

];




findrad[list_,pmid_,b_,c_]:=Module[{pre,post,rad},
pre=Cases[list,a_/;a<pmid]//Max;
post=Cases[list,a_/;a>pmid]//Min;
rad=Abs[Join[{pmid-pre,post-pmid}distsing,{pmid-b,c-pmid},{1}]]//Min;
{pmid-rad,pmid,pmid+rad}
]
(*------*)



int01=Table[Log[x]^n x^m_/;m!=-1->d Integrate[Log[x]^n x^m,x]/.x->v,{n,10}];
int02=Table[Log[x]^n/x->d Integrate[Log[x]^n x^-1,x]/.x->v,{n,10}];
int03=Table[Log[x]^n x->d Integrate[Log[x]^n x,x]/.x->v,{n,10}];
int04=Table[Log[x]^n->d Integrate[Log[x]^n,x]/.x->v,{n,10}];
int05={1/x->d Integrate[1/x,x]/.x->v};
int06={x^m_/;m!=-1->d Integrate[x^m,x]/.x->v};
int07={x->d Integrate[x,x]/.x->v};


repint=Join[int01,int02,int03,int04,int05,int06,int07]//Expand;
Clear@intexp;
chopp[expr_,truncord_]:=Chop[expr/.y_Symbol^a_/;a>truncord->0,10^-acc]
(*chopp[expr_,prec_]:=Chop[expr/.y_Symbol^a_/;a>prec->0,10^-(-$ChopPrec Log[10,$PrecTarget $Offset])]*)
intexp[exp0_,var_,prec_]:=Module[{exp=chopp[exp0//Expand,prec],out},
out=exp/.var->v/.repint;
chopp[out-(out/.d->0)+(out/.d->0)v/.d->1/.v->var,prec]
]



(*Canonical*)
DEcov[atilde_,cov_]:=atilde/.cov//Expand




CheckRootsSanity[AlgebraicArguments_]:=Module[{
test0,test0Q,
test1,test1Q,
test2,test2Q,
test3,test3Q,
test23Q,
algli=AlgebraicArguments//Expand//Union,
thrli},

$SingBC=False;
thrli=Table[thrV[vv[ii]][[jj]]-tominV[vv[ii]],{ii,nvar},{jj,Length@thrV[vv[ii]]}]//Flatten;
Print[thrli];
test0=(Length/@(FactorList/@algli))-1;
test1=#[[2]]&/@((#[[2,1]]&/@(FactorList/@algli))//Tally);
test2=Table[Length@Cases[algli,thrli[[ii]]],{ii,Length@thrli}];
test3=Table[Length@(Cases[NumericQ/@Simplify[algli/thrli[[ii]]],True]),{ii,Length@thrli}];

Print[test0, " factors per alg arg (should be 1)"];
Print[test1, " number of alg arg modulo overall factor (should be 1)"];
Print@Cases[(#[[2,1]]&/@(FactorList/@algli))//Tally,{a_,b_}/;b>1];
Print[test2, " threshold sr (non-0 means corresponding thr sr present - should be 1 and 0 ) "];
Print[test3, " number of threshold sr modulo factor (should be equal to previous) "];

test0Q=Union[test0]==={1};
test1Q=Union[test1]==={1};
test23Q=FreeQ[Table[test2[[ii]]=!=test3[[ii]],{ii,Length@test2}],True];

If[(test0Q&&test1Q&&test23Q),Print[" Success "];True,Print["Error: Redundant Square roots "];False]

]



FindExpSegments[atilde_,reprootsTab_,cov_]:=Module[{subsroots,atildex,logli,rli,arglifull,tab,tabroots,singli,singli0,singli1,singlimid,divcov,pli,list,test1,dmin,tmp,prec=2 acc+20},

print["Finding DEFactors "];


(*atildex=Table[DEFactors/.subsroots[[ii]]/.cov,{ii,Length@subsroots}];*)
atildex=DEFactorsRat/.cov;
arglifull=atildex;

print["len arg de ", Length@arglifull];

print["Finding singularities "];

tab=Last/@(Table[$i=ii;NSolve[{arglifull[[ii]]==0&&-2<Re[x]<3},x,WorkingPrecision->prec+100],{ii,Length@arglifull}]//Flatten);
print["sing li accuracy = ",Accuracy[tab]];
If[Accuracy[tab]<prec+50,PrintAndSaveErrorAbort["Low accuracy singularities DE"]];
singli={Re[#]- Im[#],Re[#],Re[#]+Im[#]}&/@Cases[tab,a_/;-2<Im[a]<2]//Flatten//SetPrecision[#,prec]&//Union;
divcov=Last/@(Solve[#==0]&/@(Last/@cov//Factor//Denominator)//Flatten);

singli=Join[singli,divcov]//Union;
$singli={tab,singli};

print["singli = ", Flatten[N[singli]], "segmentation "];

singli0=(tmp=(Cases[singli,a_/;-2<a<0]//Sort);
If[Length@tmp==0,{-2},If[Length@tmp==1,{-2,tmp[[-1]]},tmp[[-2;;]]]]
);

singli1=(tmp=(Cases[singli,a_/;1<a<3]//Sort);
If[Length@tmp==0,{3},If[Length@tmp==1,{tmp[[1]],3},tmp[[;;2]]]]);
singlimid=Cases[singli,a_/;0<=a<=1]//Sort;
singlimid=If[Length@singlimid==0,{1/2},singlimid];
part={x1___,pp[a__,b_],pp[c_,d__],x2___}/;b<c:>{x1,pp[a,b],pp[Sequence@@findrad[list,b+(c-b)/2,b,c]],pp[c,d],x2};

list={singli0,singlimid,singli1}//Flatten//Union//Sort;
$list=list;
pli=Table[dmin={(list[[ii]]-list[[ii-1]])distsing,(list[[ii+1]]-list[[ii]])distsing,1}//Min;
pp[list[[ii]]-dmin,list[[ii]],list[[ii]]+dmin],{ii,2,Length@list-1}];

pli=If[pli[[-1,-1]]<1,Join[pli,{pp[1-(1-pli[[-1,-2]])distsing,1,1+(1-pli[[-1,-2]])distsing]}],pli]//.part;
pli=If[pli[[1,1]]>0,Join[{pp[-pli[[1,-2]]distsing,0,pli[[1,-2]]distsing]},pli],pli]//.part;
pli=DeleteCases[(pli//.{a___,pp[x1__,x2_],pp[x3_,x4__],b___}/;x2>x3:>{a,pp[x1,x3],pp[x3,x4],b}),pp[a_,_,b_]/;a>1||b<0];
pli=Chop[pli,10^(-acc)]/.{pp[a1_,a2__],a___}:>{pp[0,a2],a}//.{pp[0,a1__],pp[0,a2__],a___}:>{pp[0,a2],a}/.{pp[a1_,a2_,a3_]}/;1/3<a2<2/3&&a3>1:>{pp[a1,a2,1]};

print["segmentation : done "];
print["pli accuracy = ",Accuracy[pli]];
If[Accuracy[pli]<2 acc,PrintAndSaveErrorAbort["Low accuracy singularities DE"]];

pli
]



IterateRationalDen[factor_]:=Module[{out},
out=den[Collect[Expand[factor]/.Sqrt[a_]:>Sqrt[a//Expand]//.Sqrt[a_] Sqrt[b_]:>Sqrt[a b],Sqrt[_]]];
out=out/.{den[a_+c_ Sqrt[b_]]:>a^2-c^2 b,den[a_+Sqrt[b_]]:>a^2-b}/.den[a_]:>a//Expand
]
RationalDen[letter_]:=Cases[{den[FixedPoint[IterateRationalDen[#]&,letter]//Factor]}//.{den[a_ b_]:>den[a]den[b],den[a_^n_]:>den[a]},den[a_]/;!NumericQ[a]:>a,Infinity]//Union


IntersectionSpuriousPhysicalQ[DEFactorsin_,pli_]:=Module[{
DEFactors,
RootsArguments,
toremove,
nophysfactors,
xrep,
zerotest,
output},

DEFactors=(Table[DEFactorsin[[ii]]//RationalDen,{ii,Length@DEFactorsin}]//Flatten//Union)/.jacobianslist;

If[!FreeQ[DEFactors,a_^r_Rational],PrintAndSaveErrorAbort["Non-Rational alphabet during overlapping sing check"]];

(*$DEF=DEFactors;*)

output=Table[
toremove={vv[ii]-thrV[vv[ii]][[jj]],-vv[ii]+thrV[vv[ii]][[jj]]}/.vv[ii]->tominV[vv[ii]]//Expand;
nophysfactors=DeleteCases[DEFactors,Alternatives@@toremove];
(*Assumes that the cov is linear*)
xrep=Flatten@Solve[cov[[ii,2]]==thrV[vv[ii]][[jj]]&&(Rationalize[Min[pli[[1,1]],pli[[1,2]],pli[[1,3]]]-10^(-acc/10),10^(-acc/2)]<x<Rationalize[Max[pli[[-1,1]],pli[[-1,2]],pli[[-1,3]]]+10^(-acc/10),10^(-acc/2)])];
If[Length[xrep]>1,PrintAndSaveErrorAbort["multiple zeros while overlapping sing check"]];
If[Accuracy[xrep]=!=Infinity,PrintAndSaveErrorAbort["Non exact solution while overlapping sing check"]];
zerotest=Times@@If[xrep==={},{1},Simplify[Expand[nophysfactors/.cov/.xrep]]];
If[zerotest==0,0,1]
,{ii,nvar},{jj,Length@thrV[vv[ii]]}]//Flatten;

If[(Times@@output)===0,PrintAndSaveErrorAbort["Bad contour: overlapping physical-physical or physical-spurious singularities"]]
]


PrintAndSaveErrorAbort[text__]:=(
Print["START_OUTPUT_STREAM"];
Print["NaN"];
Print["END_OUTPUT_STREAM"];
PutAppend[{{text},": "<>ToString[p0->p1//InputForm//ToString]},ErrorLogFile];
saveQ=False;
If[$script,Quit[],Abort[]]
)


CheckSpuriousSR[funcList_,cov_,rad_,x0_,signx_,xli_,trord_,solresc_]:=Module[{ffli,ffliexp,funcListExp,srli,out},

print["Checking sr cuts... ",Date[]];

ffli=Cases[funcList,ff[a_],Infinity]//Union;
ffliexp=ffli/.ff[a_]:>(ff[a]->Normal[Series[a/.cov/.x-> signx rad x+x0//N[#,acc]&,{x,0,trord},Assumptions->x>0]]);

funcListExp=chopp[funcList/.ffliexp/.MI[a_,b_]:>solresc[[a+1,b]]//Expand,trord];
funcListExp=funcListExp/. a_^r_Rational:>sr a^(r); 


srli=Cases[funcListExp,sr,Infinity]//Union;

If[srli==={},Print["no square root !"],

out=Table[Coefficient[funcListExp,sri]/. xli ,{sri,srli}]//Flatten//Abs//Max;
print["Square root cut : ", out//N];
PutAppend[{"sr cut ", out//N,cov/.x->x0//N},"srcut_log.txt"];
If[Chop[out,$PrecTarget]=!=0,PrintAndSaveErrorAbort["Anomalous Square root cut: "<>ToString[out//N//InputForm]]];
print["Checking sr cuts: Done ",Date[]];
];

]



CheckSpuriousLogs[solresc_,xli_,ordeps_,cov_,x0_]:=Module[{testdivlog,thelog,logli,coefflog},

print["checking spurious logs "];

logli=Cases[solresc,Log[a_],Infinity]//Flatten//Union;
If[Length@logli>1,
PrintAndSaveErrorAbort["multiple logs "],
thelog=logli//First];

coefflog=Table[Coefficient[solresc,thelog^ii]/. xli,{ii,ordeps}]//Flatten//Abs//Max//N;

PutAppend[{"log cut ",thelog//N ,": ",coefflog," @ ",(cov/.x->x0//N)/.vv[a_]:>vv[a//Rationalize[#,10^-100]&]},"logcut_log.txt"];
print["log coeff ", coefflog];
If[coefflog> $PrecTarget ,PrintAndSaveErrorAbort["log spurious singularity "]];

print["checking spurious logs: Done "];

]


ContourExpandMV[atilde_,cov_,pli_,acc_,ordeps_]:=Module[{
assumptions=x>0,
thrx,
x0,xb,xli,
toseroots,diffroots,diff,
logli,
signx,repabove,signim,
tose,dxse,solm1,
out,solord,solordc,solordg,solordp,result,
atildex,
rli,
tablog,
thelog,
testdivlog,
accli,
prec,
atildexnum,
dxsenum,
derlogli,
rad,
errli,
zerolett,
derlogliseries,
derloglin,
solresc,
logliresc,
xli0,
extratrunc,
negPowLi,
varlist,
VanishingSRQ,
AbsentThrQ,
zeroxbx0,
eqbc,
singbc,
deden,
dedense
},

print["::: from ",cov/.x->0//N];
print["::: to ",cov/.x->1//N," : ",Hash[p1]];


result=Table[
prec;
signx=1;
signim=0;
repabove={};
x0=pli[[nn]]/.pp[_,a_,_]:>Chop[a,10^-acc];
xb=pli[[nn]]/.pp[a_,__]:>Chop[a,10^-acc];
rad=pli[[nn]]/.pp[a_,b_,c_]:>Max[Abs[c-b],Abs[a-b]];
diff={1};
diffroots={1};
extratrunc=0;
zeroxbx0 = Abs[xb]<10^-acc&&Abs[x0]<10^-acc;

singbc=$SingBC&&nn==1;

If[singbc&&!ExactNumberQ[x0],PrintAndSaveErrorAbort["inexact x0 with singular boundary point"]];
If[singbc&&!ExactNumberQ[xb],PrintAndSaveErrorAbort["inexact xb with singular boundary point"]];
If[singbc&& ! zeroxbx0, PrintAndSaveErrorAbort[" Singular boundary point =! xb=0,x0=0"]];


print["--------------------------------------------------------------------------------------"];
print[nn,"/",Length@pli," ",FileTag," ) *** Expanding around ",cov[[;;nvar]]/.x->x0//N];
print["x0 = ", x0//N, " | xb = ", xb//N,"| radius : ",rad//N," | sing bc = ", singbc];
print["Accuracy x0 xb = ",Accuracy[{x0,xb}]];
If[Accuracy[{x0,xb}]<2 acc,PrintAndSaveErrorAbort["Low accuracy x0 xb"]];

Do[If[
((Association[cov][vv[ii]]/.x->x0)>thrV[vv[ii]][[jj]])&&Chop[vv[ii]-thrV[vv[ii]][[jj]]/.cov/.x->x0,10^-acc]!=0,
repabove=Join[repabove,repaboveV[vv[ii]][[jj]]]//Flatten//Union
],{ii,nvar},{jj,Length@thrV[vv[ii]]}];


tablog=Table[
If[Chop[vv[ii]-thrV[vv[ii]][[jj]]/.cov/.x->x0,10^-acc]==0,
signim=signimV[vv[ii]];
print["### Crossing Threshold ",vv[ii],"=",thrV[vv[ii]][[jj]]," sign ieps = ",signim];
zerolett=vv[ii]-thrV[vv[ii]][[jj]];1,0],{ii,nvar},{jj,Length@thrV[vv[ii]]}];
If[Total[Flatten[tablog]]>1,PrintAndSaveErrorAbort["crossed multiple phys thresholds"]];(*Possibly redundant, see IntersectionSpuriousPhysicalQ *)

print["Square roots repl: ",repabove];
print["Setting up DE..."];

atildex=DEcov[atilde/.repabove,cov];
rli=(Cases[atildex,a_^r_Rational/;!NumericQ[a],Infinity]//Union); (*There should be no denominators in atilde/atildex*)
logli=Cases[atildex,Log[a_],Infinity]//Union;


print["Finding sign x "];
prec=- 10 Log[10,$PrecTarget $Offset];
xli0={pli[[nn]]/.pp[a_,__]:>signx (a-x0)/rad,pli[[nn]]/.pp[__,a_]:>(a-x0)/rad}//Sort;
xli={x->#}&/@xli0;
If[singbc,xli=DeleteCases[xli,{x->0}]];


toseroots=Table[$i=ii;rli[[ii]]->Series[rli[[ii]]/.x-> rad x+x0//N[#,prec+acc]&,{x,0,prec},Assumptions->assumptions]//Normal,{ii,Length@rli}];
diffroots=(rli/.x->rad x+x0)-(rli/.toseroots)/.N[xli,acc]//Flatten//Abs//Max;

If[Max[diffroots]>($PrecTarget $Offset)^2,signx=-1,signx=1];
print["diff roots " ,diffroots//N," | sign x ", signx];
If[singbc&&signx===-1,PrintAndSaveErrorAbort["sing bc and negative signx"]];

xli=xli/.(x->a_):>(x->signx a);


print[xli0//N];
print[xli//N];

prec=$PrecStart;
print["Finding trunc ord..."];
logliresc=logli/.x-> signx rad x+x0;
derlogli=D[logliresc,x];
print["n der log ... "];
derloglin=derlogli/. N[xli,acc];

deden=1/DEFactorsRat/.cov/.x-> signx rad x+x0;


Label[IncrTrOrd];

While[Max[diff]>$PrecTarget $Offset,
prec=prec+$Increment;
(*print["Exp der logs ... "];*)
dedense=Normal[Series[N[deden,acc+prec],{x,0,prec},Assumptions->assumptions]];
(*print["checking diff ... "];*)
diff=(deden)-(dedense)/. N[xli,acc]//Flatten//Abs//Max;
print["prec"->prec,": ", " diff = " ,diff//N];
If[prec>200,PrintAndSaveErrorAbort["Reached max prec"]];
];

print["expanding dlogs "];

derlogli=D[logliresc/.Log[a_]:>Log[Normal[Series[N[a,acc+prec],{x,0,prec+5},Assumptions->assumptions]]],x];
derlogliseries=Series[derlogli,{x,0,prec},Assumptions->assumptions]//Normal;

tose=MapThread[#1->#2&,{logli,derlogliseries}];
dxse=(atildex/.Log[a_]/;NumericQ[a]->0/.Pi->0/.tose//Expand);

print["expanding dlogs done. "];

print["set extra trunc ord"];
negPowLi=Cases[dxse,a_^r_/;r<0:>Abs[r],Infinity]//Union;
print["===> negative powers DE =  ",-negPowLi];
If[negPowLi=!={}, extratrunc=Ceiling[Max[negPowLi//Abs](ordeps+1)]];
print["===> prec ", prec, ", extra trunc ",extratrunc];



varlist= Cases[dxse,a_^b_/;!FreeQ[a,x]:>a,Infinity]//Flatten//Union;
print["===> variables list = ",varlist];
If[varlist=!={x},PrintAndSaveErrorAbort["unomalous variables "<>ToString[varlist]]];


(*prec_,ordeps_,logliresc_,assumptions_,logli_*)

print["Expanding..."];

print["acc dxse ",Accuracy[dxse]];

print["accuracy bc = ", Accuracy[boundary0]];
If[Accuracy[boundary0]<acc(1-1/10),PrintAndSaveErrorAbort["low accuracy bc"]];
out[0]=Transpose[boundary0][[;;]]//Transpose//SetAccuracy[#,acc+Ceiling[0.5 acc]]&;
print["accuracy bc = ", Accuracy[out[0]]];
solm1=out[nn-1];
solord[0]=out[0][[1]];



Do[
print["started integrating order eps", oo];

solordp[oo]=intexp[Expand[dxse.solord[oo-1]],x,prec]//Expand;
print["acc primitive ",Accuracy[solordp[oo]]];
solordg[oo]=solordp[oo]+Table[c[i],{i,Length@solordp[oo]}];

print["fixing bc"];
eqbc[nn,oo]=Table[Expand[(solordg[oo][[ii]]/.Log[x]/;(singbc)->Log[signx /rad]+log0/.x->signx /rad( xb+signim  ieps0-x0))-(solm1[[oo+1,ii]]/.Log[x]/;(singbc)->log0/.x->xb/.ieps->ieps0)]==0,{ii,Length@solordg[oo]}];
solordc[oo]=NSolve[Chop[eqbc[nn,oo],10^-acc],Table[c[i],{i,Length@solordg[oo]}],WorkingPrecision->2 acc]//Flatten//Quiet//Chop[#,10^-(acc)]&;
print["done"];


If[!FreeQ[solordc[oo],log0],PrintAndSaveErrorAbort["div log (log0) in the solution "]];
print["acc BC ", Accuracy[solordc[oo]]];
If[Accuracy[solordc[oo]]<acc(1-1/10),PrintAndSaveErrorAbort["low acc bc ",Accuracy[solordc[oo]]]];
solordc[oo]=SetAccuracy[solordc[oo],acc+Ceiling[0.20 acc]]/.c[a__]:>Rationalize[c[a],10^-100];
print["acc BC -> ", Accuracy[solordc[oo]]];
solord[oo]=solordg[oo]/.solordc[oo];


print["sol ord c freeQ: ", FreeQ[solord[oo],c]];
If[! FreeQ[solord[oo],c], PrintAndSaveErrorAbort["c in sol"]];




print["bc sample ",(#[[1]]->N[#[[2]]])&/@solordc[oo][[;;1]]];

print["integrating order \[Epsilon] ",oo,", done ", Cases[solord[oo],Log[_],Infinity]//Union,Cases[solord[oo],a_^r_Rational:> a^(1/Denominator[r]),Infinity]//Union];

,{oo,ordeps}];


solresc=Table[solord[oo],{oo,0,ordeps}];
print["acc sol resc ",Accuracy[solresc]];
If[Accuracy[solresc] < acc(1-1/10),PrintAndSaveErrorAbort["low accuracy solresc "]];


out[nn]=solresc/.x->signx /rad (x-x0)/.x->x+signim  ieps//Chop[#,10^-(acc)]&;
print["accuracy resc back ",Accuracy[out[nn]/.x->pli[[nn,3]]/.ieps->ieps0]];
If[Accuracy[out[nn]/.x->pli[[nn,3]]/.ieps->ieps0] < acc(1-1/10),PrintAndSaveErrorAbort["low accuracy solrescback "]];
$out[nn]=out[nn];

errli[nn]=esterr[out[nn],nn,ordeps+1,extratrunc,prec];
print["===> estimated error on segment = ", errli[nn]];
If[errli[nn]>$PrecTarget $SegTolerance,diff={1};print["@@@ Large segment error, increasing truncation order "];Goto[IncrTrOrd]];


CheckSmallDenCan[solresc,xli,extratrunc];

AbsentThrQ=Times@@Chop[N[AbsentThrList[FileTag]/.cov/.x->N[x0,2 acc],2 acc],10^-acc];
VanishingSRQ=Times@@Chop[N[AlgebraicArguments/.cov/.x->N[x0,2 acc],2 acc],10^-acc];
print["prod sr value at x0 ", VanishingSRQ//N, "| prod absent thr value at x0 ",AbsentThrQ//N];

(*$srcheck[nn]={preCanfuncList,cov,rad,x0,signx,xli,prec,solresc};*)

If[!FreeQ[solresc,Log]&&(signim==0||AbsentThrQ===0)&&(!singbc),CheckSpuriousLogs[solresc,xli,ordeps,cov,x0]];
If[VanishingSRQ===0 &&(signim==0||AbsentThrQ===0)&&(!singbc),CheckSpuriousSR[preCanfuncList,cov,rad,x0,signx,xli,prec,solresc]];


out[nn]

,{nn,Length@pli}]//AbsoluteTiming;

delta1=Sum[errli[nn],{nn,Length@pli}];
delta=delta0+delta1;
print["estimated delta: 0: ",delta0," 1: ",delta1," tot :", delta0+delta1 ];
If[delta>$PrecTarget,PrintAndSaveErrorAbort["Large Error: "<>ToString[delta0+delta1]]];

print["Done in :",result[[1]], "s"];
print["--------------------------------------------------------------------------------------"];
result[[2]]
]



CheckSmallDenCan[solresc_,xli_,extratrunc_]:=Module[{testsmallden,cC},

print["checking small den"];
testsmallden=If[extratrunc>0,Cases[cC solresc//Expand,a_ x^r_/;r<0,Infinity]/.cC->1/.xli//Flatten//Union//Abs//Max,0];
print["small den contrib ",testsmallden];
If[testsmallden>$PrecTarget $SegTolerance,PrintAndSaveErrorAbort["small denominators / large error"]];

]



esterr[outn_,nn_,ordeps_,extratrunc_,prec_]:=Module[{mpowli,trunc0,trunc1,xli,maxpower},
If[$SingBC&&nn==1,
xli={{x->pli[[nn,3]]}},
xli={{x->pli[[nn,3]]},{x->pli[[nn,1]]}}];
xli=N[xli,acc];

maxpower=Cases[outn[[ordeps]],a_^b_/;!NumericQ[a]:>b,Infinity]//Max;
print["maxpow= ", maxpower];

Table[
mpowli=Table[Cases[(outn[[ordeps,jj]])/.ieps->ieps0,a_^b_/;!NumericQ[a]&&FreeQ[a,Log]:>b,Infinity]//Union//Max,{jj,dimbasis}];
trunc0=(outn[[ordeps,ii]]/.c[__]->0)/.ieps->ieps0/.xli;
trunc1=(outn[[ordeps,ii]]/.c[__]->0)/.ieps->ieps0/.a_^b_/;!NumericQ[a]&&FreeQ[a,Log]&&b>Floor[mpowli[[ii]] $PercDrop-If[Abs[prec-mpowli[[ii]]]>5,0,extratrunc]] :>0/.xli;
trunc0-trunc1//Abs,{ii,dimbasis}]//Flatten//Max//N

]



take1[a_,nan_]:=If[Length[a]==0,nan,a[[1]]]


FindContourMV[p0_,p1_]:=Module[{},
Table[vv[ii]->Rescale[x,{0,1},{p0[[ii]],p1[[ii]]}],{ii,Length@p0}]
]




CheckEndPSing[]:=Module[{},
If[(Times@@Chop[(DEFactors/.cov/.x->N[1,2 acc]),10^(-acc/2)])===0,PrintAndSaveErrorAbort["spurious sing @ x=1"]];
]


CheckSegments[]:=Module[{minrad},
minrad={#[[3]]-#[[2]],#[[2]]-#[[1]],#[[1]]-#[[3]]}&/@ReplacePart[pli,1->(pli[[1]]/.pp[0,0,a_]:>pp[-a,0,a])]//Flatten//Abs//Min;
If[minrad<$PrecTarget,PrintAndSaveErrorAbort[" small radius "]];
If[Length[pli]>200,PrintAndSaveErrorAbort["N seg exceeded"]];
If[(Length[pli]>1&&(Table[pli[[ii,1]]-pli[[ii-1,3]],{ii,2,Length@pli}]//Flatten//Union//Max)>10^-acc)||(Length[Cases[pli,pp[a_,b_,c_]/;a>=c,Infinity]//Flatten]>0)||(pli[[1,1]]!=0)||(pli[[-1,3]]<1),PrintAndSaveErrorAbort["unpatched regions"]];
]



SetGlobalV[]:=Module[{},
cov=Join[FindContourMV[p0,p1],Table[vv[ii]->tominV[vv[ii]]/.FindContourMV[p0,p1],{ii,nindvar+1,nvar}]];

If[Accuracy[cov]=!=Infinity,PrintAndSaveErrorAbort["Non exact cov"]];

(*-----------------------------*)
boundary0=Get["BClist/BClist_"<>FileTag<>"_p"<>hashp0str<>".txt"][[2]]/.tovv/.cov//.Log[a_ b_]:>Log[a]+Log[b]//Expand;
delta0=Get["BClist/BClist_"<>FileTag<>"_p"<>hashp0str<>".txt"][[3]];
If[boundary0===$Failed,PrintAndSaveErrorAbort["nofile"]];
p00=Last/@(Get["BClist/BClist_"<>FileTag<>"_p"<>hashp0str<>".txt"][[1]][[;;nindvar]]);
If[p0=!=p00,PrintAndSaveErrorAbort["wrong p0"]];

(*------------------------------*)

Table[signimV[vv[ii]]=Sign[Coefficient[Association[cov][vv[ii]],x]],{ii,nvar}];
rlivv=Cases[atilde,a_^r_Rational,Infinity]//Union;
reprootsTab=Table[Cases[rlivv,(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r_Rational:>(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r->-(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r],{ii,nvar},{jj,Length@thrV[vv[ii]]}];
Table[repaboveV[vv[ii]]=reprootsTab[[ii]],{ii,nvar}];
pli=FindExpSegments[atilde,reprootsTab,cov];

print["checking end-point"];
CheckEndPSing[];
print["checking segments"];
CheckSegments[];
print["checking overlaping phys-phys phys-spu sing"];
IntersectionSpuriousPhysicalQ[DEFactors,pli];

]


ImportBC[]:=Module[{import, import0},
print["loading bc ... "];
import0=Import["Exists/Exists_BClist_"<>FileTag<>"_p"<>"list.txt"]//Quiet;
If[import0===$Failed,PrintAndSaveErrorAbort["no bc files"]];
import=StringSplit[import0,"\n"]//ToExpression;

bclist=DeleteCases[import,a_/;Head[a]=!=List,1];
bclist=DeleteCases[bclist,a_/;Length[a]=!=nindvar,1];
bclist=DeleteCases[bclist,a_/;Union[NumericQ/@(a)]=!={True},1];
print["loading bc ... done "];
];


ImportBCRegion[]:=Module[{import,import0},
print["loading bc ... "];
import0=Import["Exists/Exists_BClist_"<>FileTag<>"_p"<>RegionLabel<>"list.txt"]//Quiet;
If[$forcestdbc,import0=$Failed];
If[import0===$Failed,
print["using default bc "];import0=Import["Exists/Exists_BClist_"<>FileTag<>"_p"<>"list.txt"],
print["using bc from ","Exists/Exists_BClist_"<>FileTag<>"_p"<>RegionLabel<>"list.txt" ];
];

If[import0===$Failed,PrintAndSaveErrorAbort["no bc files"]];

import=StringSplit[import0,"\n"]//ToExpression;
bclist=DeleteCases[import,a_/;Head[a]=!=List,1];
bclist=DeleteCases[bclist,a_/;Length[a]=!=nindvar,1];
bclist=DeleteCases[bclist,a_/;Union[NumericQ/@(a)]=!={True},1];
print["loading bc ... done "];
];






Setp0[]:=Module[{import,posreg,posmass},

print["setting p0, finding same region,  len bc list ", Length@bclist];


posreg=Position[(Sign/@(p1 #))&/@bclist,ConstantArray[1,nindvar],1]//Flatten;
If[posreg=!={},bclist1=bclist[[posreg]],bclist1=bclist];

print["done: len pos reg = ",Length@posreg];

(*bclist1=bclist;*)


print[ "len bc list = ", Length@bclist1];

p0li=Nearest[bclist1,p1,Min[iBClist,Length@bclist1]];

p0=p0li[[iBClist]];
If[Length[p0]=!=nindvar,PrintAndSaveErrorAbort["corrupted p0"]];
hashp0str=Hash[p0]//ToString;
print["p0 set"];
]


SaveExpm[out_,pli_,prefile_,nsp_]:=Module[{
expli,
bclist},

print["saving ..."];

expli=Table[If[pli[[ii]]/.pp[a_,b_,c_]:>(a<x<=c && (Abs[(x-b)]>$PrecTarget||x==1)),Evaluate[out[[ii]]],nan],{ii,Length@pli}];
bclist=Table[{(cov/.x->ii),take1[Cases[expli/.x->ii/.ieps->ieps0,a_/;a=!=nan],nan],delta},{ii,1/nsp,1,1/nsp}]//DeleteDuplicates;
bclist=DeleteCases[bclist,a_/;!FreeQ[a,nan]];

print["accuracy final result ",Accuracy[bclist[[;;,2]]]];
If[Accuracy[bclist[[;;,2]]]<acc(1-1/10),PrintAndSaveErrorAbort["Low Accuracy final values: "<>ToString[Accuracy[bclist[[;;,2]]]]]];

Do[Put[bclist[[ii]],"BClist/"<>prefile<>ToString[Hash[Last/@bclist[[ii,1,;;nindvar]]]]<>".txt"],{ii,Length@bclist}];
If[$grid,Do[PutAppend[Last/@bclist[[ii,1,;;nindvar]],"Exists/Exists_"<>prefile<>"list.txt"],{ii,Length@bclist}]];
print["Saved values ",Length@bclist];
]



SaveExpmRegion[out_,pli_,prefile_,nsp_]:=Module[{
expli,
bclist},

print["saving ..."];

expli=Table[If[pli[[ii]]/.pp[a_,b_,c_]:>(a<x<=c && (Abs[(x-b)]>$PrecTarget||x==1)),Evaluate[out[[ii]]],nan],{ii,Length@pli}];
bclist=Table[{(cov/.x->ii),take1[Cases[expli/.x->ii/.ieps->ieps0,a_/;a=!=nan],nan],delta},{ii,1/nsp,1,1/nsp}]//DeleteDuplicates;
bclist=DeleteCases[bclist,a_/;!FreeQ[a,nan]];

print["accuracy final result ",Accuracy[bclist[[;;,2]]]];
If[Accuracy[bclist[[;;,2]]]<acc(1-1/10),PrintAndSaveErrorAbort["Low Accuracy final values: "<>ToString[Accuracy[bclist[[;;,2]]]]]];

Do[Put[bclist[[ii]],"BClist/"<>prefile<>ToString[Hash[Last/@bclist[[ii,1,;;nindvar]]]]<>".txt"],{ii,Length@bclist}];
If[$grid,Do[PutAppend[Last/@bclist[[ii,1,;;nindvar]],"Exists/Exists_"<>prefile<>RegionLabel<>"list.txt"],{ii,Length@bclist}]];
print["Saved values ",Length@bclist];
]



SaveRes[]:=SaveExpm[result01,pli,"BClist_"<>FileTag<>"_p",$NSave]
SaveResRegion[]:=SaveExpmRegion[result01,pli,"BClist_"<>FileTag<>"_p",$NSave]
