(* ::Package:: *)

(* ::Input:: *)
(*(* Save to 2LoopProcessing.m *)*)


(* ::Input::Initialization:: *)
(* Masters in the expansion basis *)
MyMasters=Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases", "2LCombined.m"}]]/.SWAPMAS[fam_,ind_,perm_]:>SWAPMAS[fam,ind,perm/.SwapRelations[[3]]];
(* A (2016) in terms of Af. Roots are unflipped. *)
AToAf=Import[FileNameJoin[{BaseDirectory,"Dependencies","AToAf.m"}]];
(* The rules between the master integrals obtained by Hjalte. Extra processing has been done to rewrite to the Af family, and family B has been removed. The roots are unflipped. *)
HjalteRulesProcessed=Import[FileNameJoin[{BaseDirectory,"Dependencies","HjalteRulesProcessed.m"}]];
(* Lastly, we compute on the fly the prefactors which are needed to restore the original +Idelta prescriptions of the roots, from the Feynman prescription that is used in the expansions. *)
RootsRestore=Module[{Tmp,CurrMasters},Table[
CurrMasters=(Import[FileNameJoin[{BaseDirectory,"Dependencies","Bases","Family"<>fam<>".m"}]]);

Tmp=Table[SWAPMAS[fam,ind,perm/.SwapRelations[[3]]],{ind,Length@CurrMasters}];

(* We could also include "B", since RootFlips also contains the rules needed to split up the roots of family B in the Euclidean region, and simultaneously flip the roots so that they have + Idelta when using Feynman prescription. For example, in the Euclidean region we have s < 0, t < 0. So Sqrt[s t] would be split up as Sqrt[-s] Sqrt[-t]. But the two factors on the right have a -Idelta when using the Feynman prescription. So they get flipped according to Sqrt[-s]\[Rule]-\[ImaginaryI] Sqrt[s],Sqrt[-t]\[Rule]-\[ImaginaryI] Sqrt[t]. This would leave us with Sqrt[s t]\[Rule]-Sqrt[s] Sqrt[t]. (Though actually Sqrt[s t] is not a prefactor in the B basis.) *)
Tmp->Together[(CurrMasters/.SwapRelations[[1]][perm])/(CurrMasters/.SwapRelations[[1]][perm]/.RootFlips)]//Thread

,
{fam,{"A","Af","Bs","C","D","F","G"}},{perm,6}
]//Flatten];
(* Combined rules *)
AllFinalIntegrals=Select[RootsRestore[[All,1]],!MatchQ[#,SWAPMAS["Af",_,_]]&];
AllFinalIntegralsCombinedRules=AllFinalIntegrals/.AToAf/.HjalteRulesProcessed;
(* Converts the DiffExp results such that we have rules for all masters and their permutations, in the default root conventions (not the Feynman prescription ones), and for families A,Bs,C,D,F,G. *)
ConvertDiffExpResults2L[data_]:={
Append[data[[1]],mm->1],
Module[{FirstRules},
MyFirstRules=FirstRules=MyMasters->((MyMasters/.RootsRestore/.data[[1]])(
(data[[2]]//Map[(Sum[#[[ind]]eps^(ind-1),{ind,Length@#}]+O[eps]^(Length@#))&])(*+err (SetPrecision[data[[3]],data[[2]]//Accuracy]//Map[(Sum[#[[ind]]\[Epsilon]^(ind-1),{ind,Length@#}]+O[\[Epsilon]]^(Length@#))&])*)
))//Thread;
Thread[AllFinalIntegrals->(AllFinalIntegralsCombinedRules/.Flatten[{
SWAPMAS[a__]:>(SWAPMAS[a]/.FirstRules),
mm->1,Normal[data[[1]]]
}])]/.SWAPMAS[fam_,ind_,perm_]:>ToExpression["Fam"<>fam][perm/.SwapRelations[[2]]//First][ind]
]/.eps->\[Epsilon](*//MapAt[N[#,Accuracy[#]]&,{All,2}]*)};
