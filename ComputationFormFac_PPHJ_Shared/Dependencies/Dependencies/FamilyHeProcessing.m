(* ::Package:: *)

(* ::Input::Initialization:: *)
(* Many definitions here are for family H, but that is ok, since H and He differ by eps^2, so that He is finite. *)
FamHMasters=Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases","HCombined.m"}]];
FamHRules=Import[FileNameJoin[{BaseDirectory,"Dependencies", "HRules.m"}]];
FamHRootsRestore=Module[{Tmp,CurrMasters},
CurrMasters=(Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases","FamilyH.m"}]]);

Table[
Tmp=Table[SWAPMAS["H",ind,perm],{ind,Length@CurrMasters}];
Tmp->Together[(CurrMasters/.SwapRelations[[1]][perm])/(CurrMasters/.SwapRelations[[1]][perm]/.RootFlips)]Tmp//Thread

,
{perm,{1,2,3,4,5,6}}
]//Flatten];

FamHAllFinalIntegrals=FamHRootsRestore[[All,1]];
FamHAllFinalIntegralsCombinedRules=FamHAllFinalIntegrals/.FamHRootsRestore/.FamHRules;

ConvertDiffExpResultsHe[data_]:={
data[[1]],
Module[{FirstRules},
FirstRules=FamHMasters->(
(data[[2]]//Map[(Sum[#[[ind]]\[Epsilon]^(ind-1),{ind,Length@#}]+O[\[Epsilon]]^(Length@#))&])(*+err (SetPrecision[data[[3]],data[[2]]//Accuracy]//Map[(Sum[#[[ind]]\[Epsilon]^(ind-1),{ind,Length@#}]+O[\[Epsilon]]^(Length@#))&])*)
)//Thread;
Thread[(FamHAllFinalIntegrals/."H"->"He")->(FamHAllFinalIntegralsCombinedRules/.data[[1]]/.FirstRules)]/.SWAPMAS[fam_,ind_,perm_]:>ToExpression["Fam"<>fam][perm][ind]
](*//MapAt[N[#,Accuracy[#]]&,{All,2}]*)};
