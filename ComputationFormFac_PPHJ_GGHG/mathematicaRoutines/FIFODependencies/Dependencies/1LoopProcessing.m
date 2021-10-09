(* ::Package:: *)

(* ::Input::Initialization:: *)
OLMasters=Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases","1LCombined.m"}]];
OLRules=Import[FileNameJoin[{BaseDirectory,"Dependencies", "1LRules.m"}]];
OLRootsRestore=Module[{Tmp,CurrMasters},
CurrMasters=(Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases","Family1L.m"}]]);

Table[
Tmp=Table[SWAPMAS["1L",ind,perm],{ind,Length@CurrMasters}];
Tmp->Together[(CurrMasters/.SwapRelations[[1]][perm])/(CurrMasters/.SwapRelations[[1]][perm]/.RootFlips)]Tmp//Thread

,
{perm,{1,2,3,4,5,6}}
]//Flatten];

OLAllFinalIntegrals=OLRootsRestore[[All,1]];
OLAllFinalIntegralsCombinedRules=OLAllFinalIntegrals/.OLRootsRestore/.OLRules;

ConvertDiffExpResults1L[data_]:={
Append[data[[1]],mm->1],
Module[{FirstRules},
FirstRules=OLMasters->(
(data[[2]]//Map[(Sum[#[[ind]]\[Epsilon]^(ind-1),{ind,Length@#}]+O[\[Epsilon]]^(Length@#))&])(*+err (SetPrecision[data[[3]],data[[2]]//Accuracy]//Map[(Sum[#[[ind]]\[Epsilon]^(ind-1),{ind,Length@#}]+O[\[Epsilon]]^(Length@#))&])*)
)//Thread;
Thread[OLAllFinalIntegrals->(OLAllFinalIntegralsCombinedRules/.data[[1]]/.mm->1/.FirstRules)]/.SWAPMAS[fam_,ind_,perm_]:>ToExpression["Fam"<>fam][perm][ind]
](*//MapAt[N[#,Accuracy[#]]&,{All,2}]*)};
