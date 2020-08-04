#!/usr/bin/env /usr/bin/wolframscript
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
(* small helper to print c++ scientific notation *)
transToC[res_]:=StringReplace[ToString[(res /.y_/;NumberQ[y]&&(Abs@y>=1&&Abs@y<=10&&!IntegerQ[y]):>N[y,32])/.y_/;NumberQ[y]&&(Abs@y<1||Abs@y>10)&&!IntegerQ[y] :>ScientificForm[N[y,32],NumberFormat->(Row[{#1,"e",#3}]&)]],{"{"->"[","}"->"]"}];


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

computeFormFactors[$s_,$t_,$mH_,$mT_,locationAmps_:$myAmplitudePath]:=Block[{s12,t,mmH,kinematicData,testError,npLookUp,coeff,rescalingNorm,loopMeasure},
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

(* Lorentz tensors are computed in mg5. need additional rescaling, since I rescaled by mass mT *)
rescalingNorm=$mT^(-3);
loopMeasure=1/(16*Pi^2);

(* compute integrals *)
kinematicData={{s12,mmH-s12-t,mmH},{s12,t,mmH},{mmH-s12-t,t,mmH},{t,s12,mmH}};

(* analytic continuations *)
myRoot[x_,1/2]/;NumericQ[x]&&x>0:=Sqrt[x];
myRoot[x_,1/2]/;NumericQ[x]&&x<0:=If[(x==4-s12||x==4-t||x==4-mmH+s12+t||x==4-mmH),-I Sqrt[-x]  ,Sqrt[x] ];


(* error tests *)
testError=Table[(evalMI[canMI[1,0,Rationalize[#,10^-32]&/@input]]),{input,kinematicData}];
If[!FreeQ[testError,"error"],Print["errorGGGH"]];

(* load MIs *)
npLookUp=Table[Get["./BClist/BClist_GGHG_p"<>pointtostr[Rationalize[#,10^-32]&/@kinematics,3]<>".txt"],{kinematics,kinematicData}]//N[#,32]&;
canMI[id_,epsOrder_,kinematicData[[1]]]:=npLookUp[[1,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[2]]]:=npLookUp[[2,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[3]]]:=npLookUp[[3,2,epsOrder+1,id]];
canMI[id_,epsOrder_,kinematicData[[4]]]:=npLookUp[[4,2,epsOrder+1,id]];

(* load formfactors *)
coeff=loopMeasure*rescalingNorm*Import[locationAmps];
Print[coeff//N];
Print["START_OUTPUT_STREAM"];
Do[
	Print[transToC[Re@(coeff[[countCoeff]])]];
,{countCoeff,Length@coeff}];
Do[
		Print[transToC[Im@(coeff[[countCoeff]])]];
,{countCoeff,Length@coeff}];
Print["END OUTPUT STREAM"]
]




(* Do actual computation *)
	myVars=4;

	(* expect format s,t,mH,mT *)
	Do[kinvars[ii]=SetPrecision[ImportString[$ScriptCommandLine[[ii+1]],"CSV"],32][[1,1]],{ii,myVars}];
	computeFormFactors[kinvars[1],kinvars[2],kinvars[3],kinvars[4]] 

