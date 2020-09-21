(* ::Package:: *)

(* ::Input::Initialization:: *)
Print["The documented functions in this package are: \n ?contractLorentz \n ?contractColor \n ?contractSpin \n ?constructLorentzProjector \n Make sure you have the \"trace_form.log\" file for the gamma-algebra \n "];

contractLorentz::usage="contractLorentz[expr, additionalRules]: 
	contractLorentz: Contracts Lorentz-indices. It works with the following objects:
		vector[p, mu]: defines the Lorentz vector \!\(\*SuperscriptBox[\(p\), \(\[Mu]\)]\)
		SP[p,k]: is the scalar-product \!\(\*SubscriptBox[\(p\), \(\[Mu]\)]\)\!\(\*SuperscriptBox[\(k\), \(\[Mu]\)]\)
		g[mu,nu]: is the metric tensor \!\(\*SubscriptBox[\(g\), \(\[Mu], \[Nu]\)]\)
		gamma[s1,mu,s2]: is \!\(\*SubscriptBox[\((\*SuperscriptBox[\(\[Gamma]\), \(\[Mu]\)])\), \(s1, s2\)]\) where s1,s2 are spinor indices
		slash[p,s1,s2]: is  \!\(\*SubscriptBox[\(p\), \(\[Mu]\)]\)(\!\(\*SuperscriptBox[\(\[Gamma]\), \(\[Mu]\)]\)\!\(\*SubscriptBox[\()\), \(s1, s2\)]\). That replacement will only be done if p is an external momentum
	INPUT:
		expr: The expression to be contracted
		additionalRules: LIST of rules to be applied during the contraction. E.g. { SP[p1,p1]->0 } as on-shell condition for massless external particle with momentum vector[p1,mu]
	OUTPUT: Expression with contracted Lorentz indices.
	NEW CONSTANTS in Output: d for the dimension.
";
contractColor::usage=" contractColor[expr, quarkIndex , gluonIndex ]
	contractColor does the color-algebra. It works with the following objects:
		delta[gluonIndex[1],gluonIndex[2]],delta[quarkIndex[1],quarkIndex[2]] : Kronecker-delta k,n either \"quark-\" or \"gluon\"-indices
		f[gluonIndex[1],gluonIndex[2],gluonIndex[3]]: structure constant of su(Nc) (a,b,c): \"gluon-indices\"
		T[a,l,m]: (l,m)-th entry of the a-th generator of fundamental representation with (a): \"gluon-index \" and components (l,m): \"quark-indices\"
	INPUT: 
		expr: The expression on which color algebra should be performed
		quarkIndex: Symbol which is used to denote the entries of the generators of the fund. representation
		gluonIndex: Symbol used  to denote the a-th generator of the fundamental/adjoint-representation
					E.g. quarkIndex=i, gluonIndex=a expects generators like T[a[1],i[2],i[3]] and f[a[1],a[3],a[9]]
	OUTPUT: Expression with performed with color-algebra.
	NEW CONSTANTS: Nc from su(Nc), TF from normalization of su(Nc) (e.g. TF=1/2)
";
contractSpin::usage=" contractSpin[expr,Momenta,MomentumToLeft,MomentumToRight,additonalRules,massLeftRight ,fileLocation]
	contractSpin performs the spinor-algebra. It works with the following objects:
		gamma[s1,mu,s2]: is (\!\(\*SuperscriptBox[\(\[Gamma]\), \(\[Mu]\)]\)\!\(\*SubscriptBox[\()\), \(s1, s2\)]\) where s1,s2 are spinor indices
	INPUT: 
		expr: The expression on which the spinor algebra should be performed
		Momenta: LIST of momenta
		MomentaToLeft: anticommutes slash[pLeft] to the left and replaces slash[pLeft]*gamma[....] by massLeft (default: zero). (Usefull for external massless spinors ubar[pLeft] or vbar[pLeft])
		MomentaToRight: anticommutes slash[pRight] to the right and replaces gamma[....]slash[pRight] by massRight (default: zero). (Usefull for external massless spinors u[pRight] or v[pRight])
		additionalRules: LIST of rules to be applied during the contraction. E.g. { slash[p1,s1,s2]->0 } as a condition if contracted with ubar[p1,s1] gives zero
		massLeft (default: 0): mass from applying dirac equation for ubar,vbar
		massRight (default: 0): mass from applying dirac equation for u,v
		fileLocation: Location of the file \"trace_form.log\" containing the gamma-traces. Default: \"trace_form.log\"
	OUTPUT: Expression with performed spinor-algebra and lorentz-algebra.
";
constructLorentzProjector::usage=" constructLorentzProjector[openLorentzIndices,externalMomenta,wardMomenta,additionalRules]
	constructLorentzProjector: Constructs Ward identity fullfilling tensor structures and their projectors for external massless gauge bosons. Up to 3 open Lorentz indices are implemented.
	*****************************************************************************
	!!! WARNING: ANTISYMMETRIC STRUCTURES WITH LEVI-CIVITA ARE NOT IMPLEMENTED !!!
	*****************************************************************************
	*****************************************************************************
	!!! WARNING: ADDITIONAL GAUGES ARE NOT IMPLEMENTED !!!
	*****************************************************************************
	*****************************************************************************
	!!! WARNING: ONLY MASSLESS BOSONS ARE IMPLEMENTED (NO EXTERNAL FERMIONS OR MASSIVE BOSONS)!!!
	*****************************************************************************
	INPUT: 
		openLorentzIndices: LIST of open tensor indices
		externalMomenta: LIST of external momenta, if only one, write e.g. {p}
		wardMomenta, Default: {}: LIST of momenta which are used for Ward identities
					 e.g. gg->H-amplitude: epsilon(p1)_mu epsilon(p2)_nu A^{mu,nu} ==> {vector[p1,mu], vector[p2,nu]}
		additionalRules, Default: {}: LIST of rules to be applied during the construction
	OUTPUT: {tesorStructures,projectors}
";
PrintTemporary["load gamma traces"]
fileLocation="trace_form.log";
FromFormToMathe[filename_]:=Module[{imp},
		imp=StringJoin[ReadList[filename,String]];
		imp=StringReplace[imp,{"\\"->"","\n"->"","\r" -> "", "("->"[", ")"->"]"," "->"" ,"d_"->"g"}];
		ToExpression[StringSplit[imp,";"]]
	];
	tr=FromFormToMathe[fileLocation];
	trRepl={};
	trRepl=Table[gammaTrace@@Table[ToExpression["mu"~~ToString[i]~~"_"],{i,j}]->tr[[j]],{j,Length[tr]}];
  trRepl=Dispatch[trRepl];
Print["gamma traces loaded"]

contractLorentz[expr_,addRules_:{}]:=Block[{resultContracted,rulesForContraction1, rulesForContraction2,vector,g,d,SP,gamma,epsstar,slash,reorderLorentz},
SetAttributes[SP,Orderless];
SetAttributes[g,Orderless];
reorderLorentz[myexpr_, pats_List] :=
  Module[{h, rls},
    rls = MapIndexed[x : # :> h[#2, Replace[x, rls, -1]] &, pats];
    HoldForm @@ {myexpr /. rls} //. h[_, x_] :> x
  ];
rulesForContraction1={
	vector[x_+y_,z_]:>vector[x,z]+vector[y,z],
	vector[-x_,z_]:>-vector[x,z],
	slash[x_+y_,z__]:>slash[x,z]+slash[y,z],
	slash[-x_,z__]:>-slash[x,z],
	SP[-x_,y_]:>-SP[x,y]
	};
rulesForContraction2={
	Times[g[mu_,nu_],gamma[s1__,mu_,s2__]]:>gamma[s1,nu,s2],
	Times[g[mu_,nu_],g[mu_,sigma_]]:>g[nu,sigma],
	Times[g[mu_,nu_],g[mu_,sigma_]]:>g[nu,sigma],
	Power[g[mu_,nu_],2]/;!StringMatchQ[ToString@mu,ToString@nu]:>d,
	g[mu_,mu_]:>d,
	Times[g[mu_,nu_],vector[p_,mu_]]:>vector[p,nu],
	Times[vector[vec1_,mu_],vector[vec2_,mu_]]:>SP[vec1,vec2],
	Power[vector[p1_,mu_],2]:>SP[p1,p1],
	vector[x_+y_,z_]:>vector[x,z]+vector[y,z],
	vector[-x_,z_]:>-vector[x,z],
slash[x_+y_,z__]:>slash[x,z]+slash[y,z],
	slash[-x_,z__]:>-slash[x,z],
	SP[-x_,y_]:>-SP[x,y],
	SP[Plus[x_,y_],z_]:>SP[x,z]+SP[y,z],
	Times[gamma[s1_,mu_,s2_],vector[x_,mu_]]:>slash[x,s1,s2],
gamma[a__,mu_,b__]vector[x_,mu_]:>gamma[a,x,b],
	gamma[a__,s2_]gamma[s2_,b__]:>gamma[a,b],
	slash[a_,s1_,s2_]gamma[s2_,b__]:>gamma[s1,a,b],
	slash[a_,s1_,s2_]gamma[b__,s1_]:>gamma[b,a,s2],
slash[x_,s1_,s2_]slash[y_,s2_,s3_]:>gamma[s1,x,y,s3]
};
     rulesForContraction1=Join[rulesForContraction1,addRules];
	rulesForContraction2=Join[rulesForContraction2,addRules];
	rulesForContraction2=Dispatch[rulesForContraction2];
	resultContracted=FixedPoint[ReplaceRepeated[Expand[#],rulesForContraction1]&,expr];

resultContracted=FixedPoint[ReleaseHold@(ReplaceRepeated[reorderLorentz[Expand[#],{g,vector,gamma}],rulesForContraction2])&,resultContracted];
	resultContracted
]


contractColor[expr_,indFundamental_,indAdjoint_ ]:=Block[{delta,T,resultContracted,f,rulesForContraction,TF,Nc,reorderColor},
SetAttributes[delta,Orderless];
reorderColor[myexpr_, pats_List] :=
  Module[{h, rls},
    rls = MapIndexed[x : # :> h[#2, Replace[x, rls, -1]] &, pats];
    HoldForm @@ {myexpr /. rls} //. h[_, x_] :> x
  ];
rulesForContraction=Dispatch@{
	delta[a_,b_]f[c__]/;(!FreeQ[{c},a]&&!StringMatchQ[ToString@a,ToString@b]):>ReplaceAll[f[c],a->b],
	f[a_,b_,c_]:>(-I/TF Module[{n1,n2,n3},T[a,indFundamental[n1],indFundamental[n2]]T[b,indFundamental[n2],indFundamental[n3]]T[c,indFundamental[n3],indFundamental[n1]]-T[a,indFundamental[n1],indFundamental[n2]]T[c,indFundamental[n2],indFundamental[n3]]T[b,indFundamental[n3],indFundamental[n1]]]), (* TF=1/2 *)
	delta[a_,b_]T[c__]/;(!FreeQ[{c},a]&&!StringMatchQ[ToString@a,ToString@b]):>ReplaceAll[T[c],a->b],
	Times[T[a_,i_,j_],T[a_,k_,l_]]:>TF(delta[i,l]delta[j,k]-Power[Nc,-1]delta[i,j]delta[k,l]), (* fierz *)
	T[a_,i_,i_]:>0, (* traceless *)
	T[a_,l_,m_]T[b_,m_,l_]:>TF delta[a,b], (* single trace *)
	delta[a_,b_]delta[b_,c_]/;!StringMatchQ[ToString@a,ToString@c]:>delta[a,c],
	Power[delta[indAdjoint[x_],indAdjoint[y_]],2]/;!StringMatchQ[ToString@x,ToString@y]:>Power[Nc,2]-1,(* adjoint representation *)
	delta[indAdjoint[x_],indAdjoint[x_]]:>Power[Nc,2]-1, (* adjoint *)
	Power[delta[indFundamental[x_],indFundamental[y_]],2]/;!StringMatchQ[ToString@x,ToString@y]:>Nc, (* fundamental rep. *)
	delta[indFundamental[x_],indFundamental[x_]]:>Nc,(* fundamental *)
	Power[T[b_,c_,d_],2]:>TF(Power[Nc,2]-1),
	Power[f[b_,c_,d_],2]:>2TF(Power[Nc,2]-1)Nc

};

resultContracted=FixedPoint[ ReleaseHold@(ReplaceRepeated[reorderColor[Expand[#],{delta,T,f}],rulesForContraction])&,expr];
resultContracted //.Times[T[a_,i_,j_],T[b_,j_,l_]]/;(!StringMatchQ[ToString@a,ToString@b]&&!StringMatchQ[ToString@i,ToString@l]):>T[a,b,i,l]
]

(* GAMMA-ALGEBRA *)
(*contractSpin[expr_/;FreeQ[expr,gamma[__]]&&FreeQ[expr,slash[__]],Mom_,toLeft_:{},toRight_:{},addRules_:{},massesLR_:0,trRules_:trRepl]:=expr;*)
contractSpin[expr_(*/;(!FreeQ[expr,gamma[__]]&&!FreeQ[expr,slash[__]])*),Mom_,toLeft_:{},toRight_:{},addRules_:{},massL_:0,massR_:0,trRules_:trRepl]:=Block[{vector,gamma,rulesForContraction,resultContracted,gammaTrace,slash,extCommuteRule,anticommLeft,toLeftRule,toRightRule,normalOrderRule,gammaNorm,keyPslash,valPslash,PslashRule,traces,tracesReplacements,tracesReplacementsRules,lorentzRule,reorderSpin},
(* reorder products *)
reorderSpin[myexpr_, pats_List] :=
  Module[{h, rls},
    rls = MapIndexed[x : # :> h[#2, Replace[x, rls, -1]] &, pats];
    HoldForm @@ {myexpr /. rls} //. h[_, x_] :> x
  ];
(* commute gamma-matrix one to the left *)
(*Print["doingStuff"];*)
anticommLeft[gamma[x__],p_,momenta_]:=Block[{erg,pos=Flatten@(Position[#,p]&@({x})),xList={x},IndOrVec,g},
	SetAttributes[g,Orderless];
	If[MemberQ[momenta,p],
		IndOrVec="vec",
		IndOrVec="ind"
];
	If[xList[[pos[[-1]]-1]]==p,
		If[StringMatchQ[IndOrVec,"vec"],
			erg=SP[p,p]gamma@@(Drop[#,{pos[[-1]]-1,pos[[-1]]}]&@xList)
		];
		If[StringMatchQ[IndOrVec,"ind"],
			erg=d*gamma@@(Drop[#,{pos[[-1]]-1,pos[[-1]]}]&@xList)
		]
	];
	If[xList[[pos[[-1]]-1]]==g5||xList[[pos[[-1]]]]==g5,
		erg=-gamma@@(Permute[xList,Cycles[{{pos[[-1]]-1,pos[[-1]]}}]]);
	];
	If[!(StringMatchQ[ToString@xList[[pos[[-1]]-1]],ToString@p]||StringMatchQ[ToString@xList[[pos[[-1]]-1]],ToString@g5]||StringMatchQ[ToString@xList[[pos[[-1]]]],ToString@g5]),
		If[StringMatchQ[IndOrVec,"vec"]&&MemberQ[momenta,xList[[pos[[-1]]-1]]],
			erg=2SP[p,xList[[pos[[-1]]-1]]]gamma@@(Drop[#,{pos[[-1]]-1,pos[[-1]]}]&@xList)-gamma@@(Permute[xList,Cycles[{{pos[[-1]]-1,pos[[-1]]}}]])
	];
		If[StringMatchQ[IndOrVec,"vec"]&&!MemberQ[momenta,xList[[pos[[-1]]-1]]],
			erg=2vector[p,xList[[pos[[-1]]-1]]]gamma@@(Drop[#,{pos[[-1]]-1,pos[[-1]]}]&@xList)-gamma@@(Permute[xList,Cycles[{{pos[[-1]]-1,pos[[-1]]}}]])
	];
		If[StringMatchQ[IndOrVec,"ind"]&&MemberQ[momenta,xList[[pos[[-1]]-1]]],
			erg=2vector[xList[[pos[[-1]]-1]],xList[[pos[[-1]]]]]gamma@@(Drop[(xList),{pos[[-1]]-1,pos[[-1]]}])-gamma@@(Permute[xList,Cycles[{{pos[[-1]]-1,pos[[-1]]}}]])
	];
		If[StringMatchQ[IndOrVec,"ind"]&&!MemberQ[momenta,xList[[pos[[-1]]-1]]],
			erg=2g[xList[[pos[[-1]]-1]],xList[[pos[[-1]]]]]gamma@@(Drop[(xList),{pos[[-1]]-1,pos[[-1]]}])-gamma@@(Permute[xList,Cycles[{{pos[[-1]]-1,pos[[-1]]}}]])
	];
];
	erg=erg/. g[mu_,nu_]*gamma[s1__]/;!FreeQ[{s1},mu]:>(gamma[s1]/. mu-> nu) /.vector[y_,nu_]*gamma[s1__]/;!FreeQ[{s1},nu]:>(gamma[s1]/. nu->y) ;
	erg =erg/. gamma[s1_,s2_]:>delta[s1,s2]; (* from gamma[s1,mu,mu,s2]*)
erg
];
(* write products of gamma matrices as gamma-strings *)

resultContracted=contractLorentz[Expand@expr,addRules];
rulesForContraction={
        delta[a_,b_]gamma[x__]/;!FreeQ[{x},a]:>(gamma[x]/. a->b),
        delta[a_,b_]gamma[x__]/;!FreeQ[{x},b]:>(gamma[x]/. b->a),
	         delta[a_,b_]slash[x__]/;!FreeQ[{x},a]:>(slash[x]/. a->b),
        delta[a_,b_]slash[x__]/;!FreeQ[{x},b]:>(slash[x]/. b->a),
	gamma[a__,mu_,b__]vector[x_,mu_]:>gamma[a,x,b],
	gamma[a__,s2_]gamma[s2_,b__]:>gamma[a,b],
	slash[a_,s1_,s2_]gamma[s2_,b__]:>gamma[s1,a,b],
	slash[a_,s1_,s2_]gamma[b__,s1_]:>gamma[b,a,s2],
slash[x_,s1_,s2_]slash[y_,s2_,s3_]:>gamma[s1,x,y,s3],
	(* anticommute gamma5 if there are two of them involved, until they match and then use gamma5^2=1 *)
	gamma[x__]/;Length@(Flatten@(Position[#,g5]&@({x})))==2:>(-1)^((Flatten@(Position[#,g5]&@({x})))[[2]]-(Flatten@(Position[#,g5]&@({x})))[[1]]-1) (gamma@@({x}/.g5:>Nothing)),
	gamma[s1_,c__,s1_]:>gammaTrace[c]
	};
rulesForContraction=Dispatch[Join[rulesForContraction,addRules]];
resultContracted=FixedPoint[ReleaseHold@(ReplaceAll[reorderSpin[Expand[#],{delta,slash,gamma}],rulesForContraction])&,resultContracted];
resultContracted=contractLorentz[resultContracted,addRules];
PrintTemporary["1/6. Contraction completed"];
PrintTemporary["2/6. anticommuting slashed momenta until they match: Started"];
	(* anticommuting slashed momenta until they match *)
Do[
	keyPslash=Cases[{resultContracted},gamma[x__]/;Length@(Flatten@(Position[List@@gamma[x],Mom[[count]]]))>1,Infinity];
	keyPslash=DeleteDuplicates@(Simplify[keyPslash/(keyPslash/.gamma[x__]:>1)]);
	valPslash=keyPslash;
	extCommuteRule={
		gamma[x__]/;Length@(Flatten@(Position[List@@gamma[x],Mom[[count]]]))>1:> anticommLeft[gamma[x],Mom[[count]],Mom],
		Times[gamma[s1__,mu_,s2__],vector[x_,mu_]]:>gamma[s1,x,s2]
		};
	extCommuteRule=Dispatch[Join[extCommuteRule,addRules]];
	valPslash=ReplaceRepeated[valPslash,extCommuteRule];
	PslashRule=Thread[Rule[keyPslash,valPslash]];
	PslashRule=Dispatch[Join[PslashRule,addRules]];
	resultContracted=ReplaceRepeated[Expand[resultContracted],PslashRule];
	extCommuteRule={};
,{count,1,Length@Mom}];
PrintTemporary["2/6. anticommuting slashed momenta until they match: Completed"];
PrintTemporary["3/6. anticommuting Lorentz indices until they match: Started"];
(* anticommute gamma_rho...gamma_mu gamma_sigma...gamma_mu...gamma_kappa until the mus match *)
extCommuteRule={
gamma[x__]/;Length@(Flatten@(List@@gamma[x]))>Length@(DeleteDuplicates@(Flatten@(List@@gamma[x])))&&!MemberQ[Mom,(Cases[Tally@{x},{y_,n_/;n>1}:>y])[[1]]]:>anticommLeft[gamma[x],(Cases[Tally@{x},{y_,n_/;n>1}:>y])[[1]],Mom]
};
extCommuteRule=Dispatch[Join[extCommuteRule,addRules]];
resultContracted=ReplaceRepeated[resultContracted,extCommuteRule];
PrintTemporary["3/6. anticommuting Lorentz indices until they match: Completed"];
PrintTemporary["4/6. anticommuting "<>ToString@toLeft<>" to the left: Started"];
(* bring slash[pk] to left and replace slash[pk]*gamma[....] by massesLR *)
Do[
	toLeftRule=Dispatch[{gamma[x__]/;(MemberQ[List@@gamma[x],toLeft[[j]]]&&Position[List@@gamma[x],toLeft[[j]]]!={{2}}):> anticommLeft[gamma[x],toLeft[[j]],Mom],gamma[s1_,toLeft[[j]],s2__]/;Length@{s2}>1:>massesLR*gamma[s1,s2],gamma[s1_,toLeft[[j]],s2__]/;Length@{s2}==1:>massL*delta[s1,s2]}];
	resultContracted=ReplaceRepeated[resultContracted,toLeftRule];
,{j,1,Length@toLeft}];
PrintTemporary["4/6. anticommuting "<>ToString@toLeft<>" to the left: Completed"];
PrintTemporary["5/6. anticommuting "<>ToString@toRight<>" to the right: Started"];(* bring slash[pr] to right and replace gamma[....]slash[pk] by massesLR (actually here everything right from pk is brought to the left )*)
Do[	
toRightRule=Dispatch[{
gamma[x__]/;(MemberQ[List@@gamma[x],toRight[[j]]]&&Position[List@@gamma[x],toRight[[j]]]!={{Length@(List@@gamma[x])-1}}):>anticommLeft[gamma[x],(List@@(gamma[x]))[[(Flatten@Position[List@@gamma[x],toRight[[j]]])[[1]]+1] ],Mom],gamma[s1__,toRight[[j]],s2_]/;Length@{s1}>1:>massR*gamma[s1,s2],gamma[s1__,toRight[[j]],s2_]/;Length@{s1}==1:>massesLR*delta[s1,s2](*,gamma[x__]/;(MemberQ[List@@gamma[x],toRight[[j]]]&&Position[List@@gamma[x],toRight[[j]]]=={{Length@(List@@gamma[x])-1}}):>here*)}];
	resultContracted=ReplaceRepeated[resultContracted,toRightRule];
,{j,1,Length@toRight}];
PrintTemporary["5/6. anticommuting "<>ToString@toRight<>" to the right: Completed"];
PrintTemporary["6/6. normal ordering: Started"];
(* bring matrices into canonical order *)
If[!FreeQ[resultContracted,gamma[w__]],
	Do[
normalOrderRule={
gamma[s1_,x__,s2_]/;Length@({x})<j:>gammaNorm[s1,x,s2], gamma[s1_,x__,s2_]/;(!StringMatchQ[ToString[(List@@gamma[s1,x,s2])[[j+1]]],ToString[Sort[{x}][[j]]]]):>anticommLeft[gamma[s1,x,s2],Sort[{x}][[j]],Mom]
};
	normalOrderRule=Dispatch[Join[normalOrderRule,addRules]];
	resultContracted=ReplaceRepeated[resultContracted,normalOrderRule];
,{j,1,Max@(Length/@(List@@(Cases[resultContracted,gamma[w__],Infinity])))}];
PrintTemporary["6/6. normal ordering: Completed"];

resultContracted=resultContracted/. gammaNorm[x__]:>gamma[x];
];
(* doing the traces *)
If[!FreeQ[resultContracted,gammaTrace[x__]],
PrintTemporary["Started Gamma traces"];
traces=Union@Cases[resultContracted,gammaTrace[x__]/; FreeQ[{x},g5],Infinity];
PrintTemporary[Length@traces];
lorentzRule=Dispatch[{g[x_,y_]/;(MemberQ[Mom,x]&&MemberQ[Mom,y]):>SP[x,y],g[x_,x_]/;MemberQ[Mom,x]:>SP[x,x],(*new code here*)g[x_,y_]/;(MemberQ[Mom,x]&&!MemberQ[Mom,y]):>vector[x,y],g[x_,y_]/;(!MemberQ[Mom,x]&&MemberQ[Mom,y]):>vector[y,x]}];
tracesReplacements=ParallelTable[traces[[countTraces]] //. trRepl //.lorentzRule,{countTraces,Length@traces}];
PrintTemporary["Lorentz contraction of replacements"];
tracesReplacements=Table[contractLorentz[tracesReplacements[[countLorentzReplacement]],addRules],{countLorentzReplacement,Length@tracesReplacements}];
tracesReplacementsRules=Thread@Rule[traces,tracesReplacements];
tracesReplacementsRules=Dispatch[tracesReplacementsRules];
PrintTemporary["start replacements"];
  resultContracted=resultContracted //. tracesReplacementsRules;
];
resultContracted=resultContracted//.gamma[s1_,x_,s2_]/;MemberQ[Mom,x]:>slash[x,s1,s2];
PrintTemporary["Final contraction of Lorentz indices"];
resultContracted=contractLorentz[resultContracted,addRules]
]
constructLorentzProjector[openIndices_List,externMom_List,wardMomenta_:{},addRules_:{}]:=Block[{SP,g,ansatzTuples,vecTerms,gTerms2,gaugeInvAnsatz, genericAnsatz , ansatz},
PrintTemporary["WARNING: ROUTINE IS NOT EXTENSIVELY TESTED!!!!"];
(* -------------------------------------------------------------------------------------------------------------------------------------------------------- *)
(* subroutine to find ward identity fullfilling ansatz from the most general ansatz: this way of constructing the tensor structures fails if additional gauge-conditions on the polarizations are imposed--> Therefore not implemented *)
gaugeInvAnsatz[ans_,wardMom_,rule_]:=Block[{allTransMom,lD,gaugeEQs,properEQs,allEQs,lorentzDummy,sInts,kinVar,ansForComp,allEqs,scalarIntRemain,ansGaugeInv,sol,scalarInt,allTens,tensStruct,allProjectors,projector},
allTransMom=Subsets[wardMom,{1,Length@wardMom}]/. {}:>Nothing /. {x_,b___}/;!ListQ[x]:>Times[x,b];
ansForComp={ans.Array[scalarInt,Length@ans] /. Thread@Rule[wardMom,0]};

SetAttributes[lorentzDummy,Orderless];
gaugeEQs=(ExpandAll@Flatten@(contractLorentz[KroneckerProduct[allTransMom,ansForComp],rule]) )//. vector[x__]:>lorentzDummy[{x}]//. g[x__]:>lorentzDummy[{x}] //. lorentzDummy[x___] lorentzDummy[y___]:>lorentzDummy[x,y]
;

lD=Cases[gaugeEQs,_lorentzDummy,Infinity]//Union;
properEQs=(((Normal/@(CoefficientArrays[#,lD]&/@gaugeEQs)//Flatten )/. 0:>Nothing));
sInts=Cases[properEQs,_scalarInt,Infinity]//Union;
kinVar=Complement[Variables@properEQs,sInts];
allEqs=Join[Thread@(properEQs==0),Thread@(kinVar!=0)];

sol=Join[Quiet[Flatten@Solve[And@@allEqs,Cases[properEQs,_scalarInt,Infinity]//Union]],{1->1}];
ansGaugeInv=((ansForComp/.sol)[[1]])/.Thread@(RuleDelayed[Join[wardMom],0]);
scalarIntRemain=Cases[ansGaugeInv,_scalarInt,Infinity]//Union;
ansGaugeInv=(Normal@CoefficientArrays[ansGaugeInv,scalarIntRemain][[2]]//Simplify);
(*ansGaugeInv={ansGaugeInv.Array[scalarInt,Length@ansGaugeInv]};*)
allTens=Thread@(Rule[Array[tensStruct,Length@ansGaugeInv],ansGaugeInv]);
allProjectors=Thread@Rule[Array[projector,Length@ansGaugeInv],(Inverse@(contractLorentz[KroneckerProduct[ansGaugeInv,ansGaugeInv],rule])//FullSimplify//Factor).Array[tensStruct,Length@ansGaugeInv]];
{allTens,allProjectors}
];

(* ----------------------------------------------------------------------------------------------------------------*)
(* subroutine for finding the projectors if no ward identeties are imposed *)
genericAnsatz[ans_,rule_]:=Block[{allTens,tensStruct,allProjectors,projector},
allTens=Thread@(Rule[Array[tensStruct,Length@ans],ans]);
allProjectors=Thread@Rule[Array[projector,Length@ans],(Inverse@(contractLorentz[KroneckerProduct[ans,ans],rule])//FullSimplify//Factor).Array[tensStruct,Length@ans]];
{allTens,allProjectors}
];
(* ----------------------------------------------------------------------------------------------------------------*)

(* Construct ansatz and solve it *)
(* Write down most general ansatz for Lorentz-structure for up-to 3 open Lorentz-indices *)
vecTerms=Times@@@(Table[vector[#[[i]],openIndices[[i]]],{i,1,Length@openIndices} ]&/@Tuples[externMom,Length@openIndices]);
SetAttributes[SP,Orderless];
SetAttributes[g,Orderless];
gTerms2={};
If[Length@openIndices==2,
	gTerms2=(DeleteDuplicates@(Times@@@(Join@@(Permutations/@ReplaceAll[vecTerms,Times:>List])/.{vector[x1_,y1_],vector[x2_,y2_]}:>{g[y1,y2]})))
	];
If[Length@openIndices==3,
	gTerms2=(DeleteDuplicates@(Times@@@(Join@@(Permutations/@ReplaceAll[vecTerms,Times:>List])/.{vector[x1_,y1_],vector[x2_,y2_],vector[x3_,y3_]}:>{g[y1,y2],vector[x3,y3]})))
];

ansatzTuples=Flatten@Join[vecTerms,gTerms2];
If[wardMomenta=!={},
ansatz=gaugeInvAnsatz[ansatzTuples,wardMomenta,addRules],
ansatz=genericAnsatz[ansatzTuples,addRules]
];
ansatz
]
