(* ::Package:: *)

(* hack to avoid problems with file-naming schemes *)
If[ByteCount[$mypath]==0,
	$myExpansionPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myExpansionPath];
	$myExpansionPath=".";
	$mypath="."
	,
	$myExpansionPath=$mypath
	];


$HistoryLength=1;
$MaxExtraPrecision=100;
SingBC=False;
$ExtraPrec=10;
iBClist=1;
acc=300;
ieps0=I 10^(-acc/2);
Cont=1;
distsing=1/2;


findrad[list_,pmid_]:=Module[{pre,post,rad},
pre=Cases[list,a_/;a<pmid]//Max;
post=Cases[list,a_/;a>pmid]//Min;
rad=Join[{pmid-pre,post-pmid}distsing,{1}]//Min;
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
Clear@intexp
chopp[expr_,prec_]:=Chop[expr/.y_Symbol^a_/;a>prec->0,10^-(prec+$ExtraPrec)]
intexp[exp0_,var_,prec_]:=Module[{exp=chopp[exp0//Expand,prec],out},
out=exp/.var->v/.repint;
out-(out/.d->0)+(out/.d->0)v/.d->1/.v->var
]



(*Canonical*)
DEcov[atilde_,cov_]:=atilde/.cov//Expand




FindExpSegments[atilde_,reprootsTab_,cov_]:=Module[{subsroots,atildex,logli,rli,arglifull,tab,tabroots,singli,singli0,singli1,singlimid,divcov,pli,list,test1,dmin,tmp,prec=400},

subsroots=reprootsTab//Flatten//Subsets;

atildex=Table[DEcov[atilde/.subsroots[[ii]],cov],{ii,Length@subsroots}];
arglifull=Cases[atildex,Log[a_]:>a,Infinity]//Union//Factor;
rli=(Cases[atildex,a_^r_Rational/;!NumericQ[a],Infinity]//Union);

tab=Last/@(Table[$i=ii;NSolve[{arglifull[[ii]]==0},x,WorkingPrecision->prec+100],{ii,Length@arglifull}]//Flatten);
tabroots=Last/@(Table[$i=ii;NSolve[{rli[[ii]]==0},x,WorkingPrecision->prec+100],{ii,Length@rli}]//Flatten);
singli={Re[#]- Im[#],Re[#],Re[#]+Im[#]}&/@Cases[Join[tabroots,tab],a_/;-2<Re[a]<3&&-2<Im[a]<2]//Flatten//SetPrecision[#,prec]&//Union;divcov=Last/@(Solve[#==0]&/@(Last/@cov//Factor//Denominator)//Flatten);

singli=Join[singli,divcov]//Union;
$singli=singli;

singli0=(tmp=(Cases[singli,a_/;-2<a<0]//Sort);
If[Length@tmp==0,{-2},If[Length@tmp==1,{-2,tmp[[-1]]},tmp[[-2;;]]]]
);

singli1=(tmp=(Cases[singli,a_/;1<a<3]//Sort);
If[Length@tmp==0,{3},If[Length@tmp==1,{tmp[[1]],3},tmp[[;;2]]]]);
singlimid=Cases[singli,a_/;0<=a<=1]//Sort;
singlimid=If[Length@singlimid==0,{1/2},singlimid];part={x1___,pp[a__,b_],pp[c_,d__],x2___}/;b<c:>{x1,pp[a,b],pp[Sequence@@findrad[list,b+(c-b)distsing]],pp[c,d],x2};

list={singli0,singlimid,singli1}//Flatten//Union//Sort;
$list=list;
pli=Table[dmin={(list[[ii]]-list[[ii-1]])distsing,(list[[ii+1]]-list[[ii]])distsing,1}//Min;
pp[list[[ii]]-dmin,list[[ii]],list[[ii]]+dmin],{ii,2,Length@list-1}];

pli=If[pli[[-1,-1]]<1,Join[pli,{pp[1-(1-pli[[-1,-2]])distsing,1,1+(1-pli[[-1,-2]])distsing]}],pli]//.part;
pli=If[pli[[1,1]]>0,Join[{pp[-pli[[1,-2]]distsing,0,pli[[1,-2]]distsing]},pli],pli]//.part;
pli=DeleteCases[(pli//.{a___,pp[x1__,x2_],pp[x3_,x4__],b___}/;x2>x3:>{a,pp[x1,x3],pp[x3,x4],b}),pp[a_,_,b_]/;a>1||b<0];
pli=Chop[pli,10^(-acc)]/.{pp[a1_,a2__],a___}:>{pp[0,a2],a}//.{pp[0,a1__],pp[0,a2__],a___}:>{pp[0,a2],a}
]



CheckThrSingInter[atilde_,cov_,x0_,acc_,$verbose_:False]:=Module[{alphabet,arglogp,argsrp,arglognp,argsrnp,tmpv},
alphabet=atilde//Variables;
argsrp=Table[
{Cases[alphabet,(thrV[vv[ii]][[jj]]-vv[ii]/.vv[ii]->tominV[vv[ii]]//Expand)^r_Rational:>(thrV[vv[ii]][[jj]]-vv[ii]/.vv[ii]->tominV[vv[ii]]//Expand),Infinity],
Cases[alphabet,(vv[ii]-thrV[vv[ii]][[jj]]/.vv[ii]->tominV[vv[ii]]//Expand)^r_Rational:>(vv[ii]-thrV[vv[ii]][[jj]]/.vv[ii]->tominV[vv[ii]]//Expand),Infinity]},{ii,nvar},{jj,Length@thrV[vv[ii]]}]//Flatten//Union;
argsrnp=Complement[Cases[alphabet,(a_)^r_Rational:>a,Infinity]//Union,argsrp];

tmpv=Chop[N[(argsrnp/.cov/.x->x0),2 acc],10^-acc];

If[Times@@tmpv==0,If[$verbose==True,Print[argsrnp[[Position[tmpv,0]//Flatten]]]];True,False]

]



ContourExpandMV[atilde_,cov_,pli_,logfile_,acc_,ordeps_,$verbose_:False]:=Module[{
assumptions=x>0,
thrx,
x0,xb,xli,
toseroots,diffroots,diff,
logli,
signx,repabove,signim,
tose,dxse,solm1,
out,solord,solordc,solordg,solordp,result,
diffli={},
atildex,
rli,
errlog={},
tablog,
thelog,
testdivlog,
accli,
prec,
atildexnum,
dxsenum,
derlogli
},

Catch[


If[(Length[pli]>1&&(Table[pli[[ii,1]]-pli[[ii-1,3]],{ii,2,Length@pli}]//Flatten//Union//Max)>10^-acc)||(Length[Cases[pli,pp[a_,b_,c_]/;a>=c,Infinity]//Flatten]>0)||(pli[[1,1]]!=0)||(pli[[-1,3]]<1),errlog=Join[errlog,{0,{"ERROR: unpatched regions"}}];Throw["err"->errlog]];


result=Table[
prec=20;
signx=1;
signim=0;
repabove={};
x0=pli[[nn]]/.pp[_,a_,_]:>a;
xb=pli[[nn]]/.pp[a_,__]:>a;
diff={1};
diffroots={1};
If[$verbose==True,
Print[nn,"/",Length@pli,") *** Expanding around ",x0//N,cov/.x->x0//N," with boundary @ ",xb//N];
];
Do[If[((Association[cov][vv[ii]]/.x->x0)>thrV[vv[ii]][[jj]])&&Chop[vv[ii]-thrV[vv[ii]][[jj]]/.cov/.x->x0,10^-acc]!=0,repabove=Join[repabove,repaboveV[vv[ii]][[jj]]]//Flatten//Union],{ii,nvar},{jj,Length@thrV[vv[ii]]}];


tablog=Table[
	If[Chop[vv[ii]-thrV[vv[ii]][[jj]]/.cov/.x->x0,10^-acc]==0,
		signim=signimV[vv[ii]];
		If[$verbose==True,
		Print["### Crossing Threshold ",vv[ii],"=",thrV[vv[ii]][[jj]]," sign ieps = ",signim]];
		1
	,0]
,{ii,nvar},{jj,Length@thrV[vv[ii]]}];

If[Total[Flatten[tablog]]>1,errlog=Join[errlog,{1,"ERROR: crossed multiple phys thresholds @ seg ",nn}];Throw["err"->errlog]];
If[CheckThrSingInter[atilde,cov,x0,acc,$verbose]&&signim=!=0,errlog=Join[errlog,{2,"ERROR: crossed multiple thresholds during analytic continuation @ seg ",nn}];
Throw["err"->errlog]];

If[$verbose==True,Print["Square roots repl: ",repabove]];

atildex=DEcov[atilde/.repabove,cov];
rli=(Cases[atildex,a_^r_Rational/;!NumericQ[a],Infinity]//Union);
logli=Cases[atildex,Log[a_],Infinity]//Union;


prec=200;
xli={x->(pli[[nn]]/.pp[a_,__]:>a),x->(pli[[nn]]/.pp[__,a_]:>a)}/.(x->a_):>(x->signx(a-x0));
toseroots=Table[$i=ii;rli[[ii]]->Series[rli[[ii]]/.x->  x+x0//N[#,prec+acc]&,{x,0,prec},Assumptions->assumptions]//Normal,{ii,Length@rli}];
diffroots=Table[$i=ii;(rli/.x->  x+x0)-(rli/.toseroots)/.N[xli[[ii]],acc]//Abs//Max,{ii,Length@xli}]//Quiet;

If[Max[diffroots]>$PrecTarget,If[$verbose==True,Print["sign x =-1"]];signx=-1,signx=1];
If[$verbose==True,Print[x0//N, " diff roots" ,diffroots//N]];

xli={x->(pli[[nn]]/.pp[a_,__]:>a),x->(pli[[nn]]/.pp[__,a_]:>a)}/.(x->a_):>(x->signx(a-x0));

prec=-2 Log[10,$PrecTarget];

derlogli=logli/.x-> signx x+x0/.Log[a_]:>D[Log[a],x]/.Pi->0;

While[Max[diff]>$PrecTarget 10^-6,
prec=prec+10;
tose=Table[$i={ii};logli[[ii]]->Series[D[logli[[ii]]/.x-> signx x+x0,x]//N[#,prec+acc]&,{x,0,prec},Assumptions->assumptions]//Normal,{ii,Length@logli}];
diff=Table[$i=ii;(derlogli)-(logli/.tose)/.N[xli[[ii]],acc/3]//Abs//Max,{ii,Length@xli}]//Quiet;
diff=DeleteCases[diff,a_/;!NumericQ[a]];
If[$verbose==True,Print["prec"->prec,": ", " diff " ,diff//N,xli//N,Date[]]];
If[prec>200,If[$verbose==True,Print["ERROR: Reached max prec"]];errlog=Join[errlog,{3,"ERROR: Reached max prec @ seg",nn}];Throw["err"->errlog]];
];


dxse=atildex/.Log[a_]/;NumericQ[a]->0/.Pi->0/.tose//Expand;
If[$verbose==True,Print[Cases[dxse,a_^r_/;r<1,Infinity]//Union]];

diffli=Join[diffli,diff];

out[0]=Transpose[boundary0][[;;]]//Transpose;
solm1=out[nn-1];
solord[0]=out[0][[1]];

Do[
solordp[oo]=intexp[Expand[dxse.solord[oo-1]],x,prec]//Expand;
solordg[oo]=solordp[oo]+Table[c[i],{i,Length@solordp[oo]}];
solordc[oo]=Solve[Table[(solordg[oo][[ii]]/.Log[x]/;(xb==0&&x0==0&&SingBC)->log0/.Log[a_]:>Log[a]/.x->signx( xb+signim  ieps-x0)/.ieps->ieps0)==(solm1[[oo+1,ii]]/.Log[x]/;(xb==0&&x0==0&&SingBC)->log0/.Log[a_]:>Log[a]/.x->xb/.ieps->ieps0),{ii,Length@solordg[oo]}],Table[c[i],{i,Length@solordg[oo]}]]//Flatten//Expand//Chop[#,10^-(acc)]&;
solord[oo]=solordg[oo]/.solordc[oo];
$solordc[nn,oo]=solordc[oo];

If[$verbose==True,Print[x0//N," integrating order \[Epsilon] ",oo,", done ", Date[], Variables[solord[oo]],Cases[solord[oo],a_^r_/;r<1,Infinity]//Union]];
,{oo,ordeps}];
If[$verbose==True,
Print[solordc[ordeps][[;;ordeps+1]]//N,"Acc"->Accuracy[solordc[ordeps]]];
Print["sign ieps = ",signim];
];
out[nn]=Table[solord[oo],{oo,0,ordeps}]/.x->signx (x-x0)/.x->x+signim  ieps//Chop[#,10^-(acc)]&;
signx=1;
If[$verbose==True,Print["vars: ", Variables[out[nn]]//N]];
$out[nn]=out[nn];

testdivlog=If[(!FreeQ[dxse,a_^r_/;r==-1])&&signim==0,
thelog=Cases[out[nn]//Variables,Log[a_],Infinity]//Union//If[Length@#>0,First[#]]&;
Table[Coefficient[out[nn],thelog^ii]/.x->pli[[nn,3]]/.ieps->ieps0//N//Abs//Max,{ii,ordeps}]//Max,0
];

If[$verbose==True,Print[testdivlog]];
If[testdivlog> $PrecTarget &&(!SingBC),errlog=Join[errlog,{ 4,"ERROR: log spurious singularity @ seg ",nn,testdivlog}];Throw["err"->errlog];];
If[!FreeQ[out[nn],log0],errlog=Join[errlog,{5,"ERROR: div log (log0) in the solution @ seg ", nn}];Throw["err"->errlog]];
If[$verbose==True,Print[errlog]];
out[nn]

,{nn,Length@pli}]//AbsoluteTiming;

accli=Table[result[[2]][[ii]]/.ieps->ieps0/.{x->pli[[ii,3]],x->pli[[ii,1]]}//Accuracy,{ii,Length@pli}];
If[Min[accli]<200,errlog=Join[errlog,{6,"ERROR: low accuracy"}];Throw["err"->errlog]];
Put[{cov,pli,"diffli"->diffli,"acc"->accli,"Expected Prec"->Max[Abs[Flatten[diffli]]]},$myExpansionPath<>"/Log/"<>logfile];

If[$verbose==True,Print["Done in :",result[[1]], "s"]];
result[[2]]
]]



take1[a_,nan_,$verbose_:False]:=If[Length[a]==0,nan,a[[1]]]

SaveExpm[out_,pli_,prefile_]:=Module[{expli,bclist},
expli=Table[If[pli[[ii]]/.pp[a_,b_,c_]:>(a<=x<=c && (Abs[(x-b)]>$PrecTarget||Abs[(x-1)]<=$PrecTarget)),Evaluate[out[[ii]]],nan],{ii,Length@pli}];bclist=Table[{(cov/.x->ii),take1[Cases[expli/.x->ii/.ieps->ieps0,a_/;a=!=nan],nan],cov},{ii,1/10,1,1/10}]//DeleteDuplicates;
bclist=DeleteCases[bclist,a_/;!FreeQ[a,nan]];
Do[Put[bclist[[ii]],$myExpansionPath<>"/BClist/"<>prefile<>pointtostr[Last/@bclist[[ii,1,;;nindvar]]]<>".txt"],{ii,Length@bclist}];
Do[Put[1,$myExpansionPath<>"/Exists/Exists_"<>prefile<>pointtostr[Last/@bclist[[ii,1,;;nindvar]]]<>".txt"],{ii,Length@bclist}];
If[$verbose==True,Print["Saved values ",Length@bclist]];
]



FindContourMV[p0_,p1_]:=Module[{},
Table[vv[ii]->Rescale[x,{0,1},{p0[[ii]],p1[[ii]]}],{ii,Length@p0}]
]




pointtostr[p1_]:=StringReplace[Table[StringReplace[(p1[[ii]]//InputForm//ToString),{"/"->"o","-"->"m"}],{ii,nindvar}]//ToString,{","->".","{"->"","}"->""," "->""}]
strtopoint[str_]:=ToExpression[StringReplace[StringSplit[str,"."],{"m"->"-","o"->"/"}]]





SetGlobalV[]:=Module[{},
cov=Join[FindContourMV[p0,p1],Table[vv[ii]->tominV[vv[ii]]/.FindContourMV[p0,p1],{ii,nindvar+1,nvar}]];
(*-----------------------------*)
boundary0=Get[$myExpansionPath<>"/BClist/BClist_"<>FileTag<>"_p"<>pointtostr[p0]<>".txt"][[2]]/.tovv/.cov//.Log[a_ b_]:>Log[a]+Log[b]//Expand;
(*------------------------------*)
Table[signimV[vv[ii]]=Sign[Coefficient[Association[cov][vv[ii]],x]],{ii,nvar}];
rlivv=Cases[atilde,a_^r_Rational,Infinity]//Union;
reprootsTab=Table[Cases[rlivv,(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r_Rational:>(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r->-(thrV[vv[ii]][[jj]]-tominV[vv[ii]])^r],{ii,nvar},{jj,Length@thrV[vv[ii]]}];Table[repaboveV[vv[ii]]=reprootsTab[[ii]],{ii,nvar}];pli=FindExpSegments[atilde,reprootsTab,cov];
]


CheckEndPSing[$verbose_]:=Module[{},
Do[If[(thrV[vv[ii]][[jj]]-vv[ii]/.cov/.x->1//Simplify)==0,Cont=0;If[$verbose==True,Print["1: ERROR: Sing. orbiting"]];result01="err"->{nan,"ERROR: Physical sing."}; Return[0]],{ii,nvar},{jj,Length@thrV[vv[ii]]}];
If[(Times@@Simplify[Join[(Variables[atilde]/.Log[a_]:>a/.cov)]])===0,Cont=0;If[$verbose==True,Print["1: ERROR: Sing. orbiting"]];result01="err"->{nan,"ERROR: Sing. orbiting"};Return[0]];
If[(Times@@Simplify[Join[(Variables[atilde]/.Log[a_]:>a/.cov/.x->1)]])===0,Cont=0;If[$verbose==True,Print["2: ERROR: spurious sing @ x=1"]];result01="err"->{nan,"ERROR: spurious sing @ x=1"};Return[0]];
If[((Times@@Simplify[Join[(Variables[atilde]/.Log[a_]:>a/.cov/.x->0)]])===0)&&(!SingBC),Cont=0;If[$verbose==True,Print["3: ERROR: spurious sing @ x=0"]];result01="err"->{nan,"ERROR: spurious sing @ x=0"};Return[0]];

]


CheckSegments[]:=Module[{minrad},
minrad={#[[3]]-#[[2]],#[[2]]-#[[1]]}&/@ReplacePart[pli,1->(pli[[1]]/.pp[0,0,a_]:>pp[-a,0,a])]//Flatten//Abs//Min;
If[minrad<$PrecTarget,result01="err"->{-1,"ERROR: small radius "};iBClist=iBClist+1; p0=Nearest[bclist,p1,iBClist][[iBClist]];SetGlobalV[]];
If[Length[pli]>200,result01="err"->{-2,"ERROR: N seg exceeded"};iBClist=iBClist+1; p0=Nearest[bclist,p1,iBClist][[iBClist]];SetGlobalV[]];
]

CheckErr[]:=Module[{},
If[result01[[1]]==="err"&&result01[[2,1]]===0,Cont=0];
If[result01[[1]]==="err"&&result01[[2,1]]===1,iBClist=iBClist+1; p0=Nearest[bclist,p1,iBClist][[iBClist]];SetGlobalV[]];
If[result01[[1]]==="err"&&result01[[2,1]]===2,iBClist=iBClist+1; p0=Nearest[bclist,p1,iBClist][[iBClist]];SetGlobalV[]];
If[result01[[1]]==="err"&&result01[[2,1]]===3,Cont=0];
If[result01[[1]]==="err"&&result01[[2,1]]===4,Cont=0];
If[result01[[1]]==="err"&&result01[[2,1]]===5,Cont=0];
If[result01[[1]]==="err"&&result01[[2,1]]===6,acc=acc+50];
]


Setp0[]:=Module[{},
bclist=strtopoint[#]&/@(StringCases[FileNames["./Exists/Exists_BClist_"<>FileTag<>"_p*"],"p"~~Shortest[a__]~~".txt":>a]//Flatten);

p0=Nearest[bclist,p1,iBClist][[iBClist]]
]


SaveRes[]:=Module[{},
If[result01[[1]]==="err",
PutAppend[{$myExpansionPath<>"/BClist/BClist_"<>FileTag<>"_p"<>pointtostr[p1]<>".txt",p0->p1,cov,result01},$myExpansionPath<>"/err_log.txt"];
Put[{FileTag,p0->p1,cov,result01},$myExpansionPath<>"/BClist/BClist_"<>FileTag<>"_p"<>pointtostr[p1]<>".txt"],
SaveExpm[result01,pli,"BClist_"<>FileTag<>"_p"]];
]



CheckLargeLogs[]:=Module[{poslog,num1,num2,num0,difflog},
poslog=Position[Table[FreeQ[result01[[ii]],ieps]&&!FreeQ[result01[[ii]],Log],{ii,Length@result01}],True]//Flatten;
If[SingBC,poslog=DeleteCases[poslog,1]];
num1=Table[result01[[ii]]/.x->pli[[ii,posp]]+10^(-acc/2),{ii,poslog},{posp,{2}}];
num2=Table[result01[[ii]]/.x->pli[[ii,posp]]-10^(-acc/2),{ii,poslog},{posp,{2}}];
num0=Table[result01[[ii]]/.Log[_]->0/.x->pli[[ii,posp]],{ii,poslog},{posp,{2}}];
difflog={num1-num0,num2-num0}//N//Flatten//Abs;
If[Length[difflog]>0&&Max[difflog]>$PrecTarget,PutAppend[{$myExpansionPath<>"/BClist_"<>FileTag<>"_p"<>pointtostr[p1]<>".txt",p0->p1,cov,"warn"->{7,"WARNING: large logs",Max[difflog]}},$myExpansionPath<>"/warn_log.txt"]]]

