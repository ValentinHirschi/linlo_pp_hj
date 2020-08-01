(* ::Package:: *)

(* get absolute path for relative paths  *)
(* hack to avoid problems with file-naming schemes *)
If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
	];
 $myAmplitudePath=$myImportPath<>"/formfactorsMathematica/amp_Eps0.m"

(* set conversion to read in MIs *)
pointtostr[p1_,nindvar_]:=StringReplace[Table[StringReplace[(Rationalize[p1[[ii]],10^-32]//InputForm//ToString),{"/"->"o","-"->"m"}],{ii,nindvar}]//ToString,{","->".","{"->"","}"->""," "->""}];


(* set conversion to read in MIs *)
evalMI[canMI[intNum_,epsOrder_,kinematics_List],$precision_:16,locations_:$myImportPath]:=Block[{res,fileName,pointtostr,testComp,runMIComp},
pointtostr[p1_,nindvar_]:=StringReplace[Table[StringReplace[(Rationalize[p1[[ii]],10^-32]//InputForm//ToString),{"/"->"o","-"->"m"}],{ii,nindvar}]//ToString,{","->".","{"->"","}"->""," "->""}];
runMIComp[s_,t_,b_,$prec_]:=locations<>"/computeMIsGGGH.wls"~~" "~~ToString[s,InputForm]~~" "~~ToString[t,InputForm]~~" "~~ToString[b,InputForm]~~" "~~ToString@$prec;
	If[
	FileExistsQ[locations<>"/Exists/Exists_BClist_GGHG_p"<>pointtostr[kinematics,3]<>".txt"],
	res=(Get[locations<>"/BClist/BClist_GGHG_p"<>pointtostr[kinematics,3]<>".txt"])[[2,epsOrder+1,intNum]],
(*		Print[ToString@Directory[]<>runMIComp[kinematics[[1]],kinematics[[2]],kinematics[[3]],$precision]];*)
		testComp=Run[runMIComp[kinematics[[1]],kinematics[[2]],kinematics[[3]],$precision]];
		If[FileExistsQ[locations<>"/Exists/Exists_BClist_GGHG_p"<>pointtostr[kinematics,3]<>".txt"],
		res=(Get[locations<>"/BClist/BClist_GGHG_p"<>pointtostr[kinematics,3]<>".txt"])[[2,epsOrder+1,intNum]],
		Return["error"]
	]
	];
	SetPrecision[res,32]
	]

computeFormFactors[$s_,$t_,$mH_,$mT_,locationAmps_:$myAmplitudePath]:=Block[{s12,t,mmH,kinematicData,testError,npLookUp,coeff,formFac1,formFac2,formFac3,formFac4,rescalingNorm},
If[ByteCount[$mypath]==0,
	$myImportPath=FileNameJoin[{DirectoryName @ $InputFileName, ""}];
	SetDirectory[$myImportPath];
	$myImportPath=".";
	$mypath="."
	,
	$myImportPath=$mypath
	];
(* rescaling of mandelstam variables *)
s12=N[$s/$mT^2,32];
t=N[$t/$mT^2,32];
mmH=N[$mH^2/$mT^2,32];
(* Lorentz tensors are computed in mg5. need additional rescaling! *)
rescalingNorm=$mT^3;


(* compute integrals *)
kinematicData={{s12,mmH-s12-t,mmH},{s12,t,mmH},{mmH-s12-t,t,mmH},{t,s12,mmH}};
Print[kinematicData];
(* analytic continuations *)
myRoot[x_,1/2]/;NumericQ[x]&&x>0:=Sqrt[x];
myRoot[x_,1/2]/;NumericQ[x]&&x<0:=If[(x==4-s12||x==4-t||x==4-mmH+s12+t||x==4-mmH),-I Sqrt[-x]  ,Sqrt[x] ];

(* error tests *)
testError=Table[(*Print[input];*) (evalMI[canMI[1,0,Rationalize[input,10^-32]]]//Chop//Rationalize//Print),{input,kinematicData}];
If[!FreeQ[testError,"error"],Return["error"]];

(* load MIs *)
npLookUp=Table[Get["./BClist/BClist_GGHG_p"<>pointtostr[Rationalize[#,10^-32]&/@kinematics,3]<>".txt"],{kinematics,kinematicData}]//N[#,32]&;
canMI[id_,epsOrder_,kinematicData[[1]]]:=npLookUp[[1,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[2]]]:=npLookUp[[2,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[3]]]:=npLookUp[[3,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[4]]]:=npLookUp[[4,2,epsOrder+1,id]];

(* load formfactors *)
coeff=rescalingNorm*Import[locationAmps];
formFac1=coeff[[1]];
formFac2=coeff[[2]];
formFac3=coeff[[3]];
formFac4=coeff[[4]];

Return[{ReIm@formFac1,ReIm@formFac2,ReIm@formFac3,ReIm@formFac4}]
]
