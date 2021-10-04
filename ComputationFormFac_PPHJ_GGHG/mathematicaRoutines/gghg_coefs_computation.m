(* ::Package:: *)

(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)
ComputeFormFactors[args_,InterpolationDataLinker_]:=Block[{},
Print[];
Print["Parsed arguments received: " <> ToString[args, InputForm]];
Print[];
Print["Note that yb and yt are currently ignored.."];
Print[];

Print["Looking up arguments in linker file.."];

LinkerKey = Null;
Do[
  SatisfiesArguments = True;
  CurrentConditionals = {
    {((Chop[#,10^-5]&@*N)[(If[LinkerConditionals["mh"]!=0,Abs[(args["mh"] - LinkerConditionals["mh"])/LinkerConditionals["mh"]],Abs[(args["mh"] - LinkerConditionals["mh"])]])]) === 0, "mh doesn't match"},
    {((Chop[#,10^-5]&@*N)[(If[LinkerConditionals["mb"]!=0,Abs[(args["mb"] - LinkerConditionals["mb"])/LinkerConditionals["mb"]],Abs[(args["mb"] - LinkerConditionals["mb"])]])]) === 0, "mb doesn't match"},
    {((Chop[#,10^-5]&@*N)[(If[LinkerConditionals["mt"]!=0,Abs[(args["mt"] - LinkerConditionals["mt"])/LinkerConditionals["mt"]],Abs[(args["mt"] - LinkerConditionals["mt"])]])]) === 0, "mt doesn't match"},
    {MatchQ[args["nloop"], LinkerConditionals["nloop"]] === True, "nloop doesn't match"},
    {args["nf"] - LinkerConditionals["nf"] === 0, "nf doesn't match"},
    {args["is_HEFT"] === LinkerConditionals["is_HEFT"], "is_HEFT doesn't match"},
    {args["inc_ytqcd"] === LinkerConditionals["inc_ytqcd"], "inc_ytqcd doesn't match"},
    {((args["inc_ytmb"] === LinkerConditionals["inc_ytmb"])||(args["nloop"]==1)), "inc_ytmb doesn't match"},
    {((args["inc_ytmt"] === LinkerConditionals["inc_ytmt"])||(args["nloop"]==1)), "inc_ytmt doesn't match"},
    {args["inc_ybqcd"] === LinkerConditionals["inc_ybqcd"], "inc_ybqcd doesn't match"},
    {((args["inc_ybmb"] === LinkerConditionals["inc_ybmb"])||(args["nloop"]==1)), "inc_ybmb doesn't match"},
    {((args["inc_ybmt"] === LinkerConditionals["inc_ybmt"])||(args["nloop"]==1)), "inc_ybmt doesn't match"}
    (*{(LinkerConditionals["stRange"] /. {s -> args["s"], t -> args["t"]}) === True, "Range of s,t doesn't fit."}*)
  };
	
	If[!(And@@CurrentConditionals[[All,1]]),
		SatisfiesArguments = False;
		Print["Skipping entry. Reasons: ",
			CurrentConditionals[[Flatten[Position[CurrentConditionals[[All, 1]], False]],2]]
		];
	];
	
	If[SatisfiesArguments,
		Print["Found suitable datafile..: ", InterpolationDataLinker[LinkerConditionals][[2]]];
		LinkerKey = LinkerConditionals;
		Return["", Do];
	];
	, {LinkerConditionals, InterpolationDataLinker//Keys}
];

If[LinkerKey === Null,
	Print["No datafile found for the current configuration options.."];
];

InterpolationDataLinker2 = InterpolationDataLinker[LinkerKey];
If[ValueQ[InterpolationDataFiles],
	InterpolationData = InterpolationDataFiles[InterpolationDataLinker2[[2]]] // Association; 
	,
	InterpolationData = Import[InterpolationDataLinker2[[2]]] // Association; 	
];
nmFromst = {n,m} //. (InterpolationDataLinker2[[1]] /. {s -> args["s"], t -> args["t"]});

Print["n = ", nmFromst[[1]], ", m = ", nmFromst[[2]], "."];
Print[];

(* Possible values are 0, -1, -2 *)
epsilonPoleIndex = args["eps_order"];
FormFactors = Table[
	Sum[
		(
		  InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, epsilonPoleIndex, muord, Re}][Sequence @@ nmFromst] + 
		  I InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, epsilonPoleIndex, muord, Im}][Sequence @@ nmFromst]
		) * (Log[mmuu]^muord /. mmuu -> args["mu"])
	, {muord, 0, Which[args["nloop"] == 1, 0, args["nloop"] == 2, 2+epsilonPoleIndex]}]
, {ffind, 4}];

(* TODO understnad this Fudge better *)
(* TODO getting the correct phase will matter when doing 1L vs 2L interference *)
OneLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);
TwoLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);
FudgeFactor = If[args["nloop"]==1, OneLoopFudgeFactor, TwoLoopFudgeFactor];

(* TODO This will need further refinement when adding the possibility of both incyt and incyb together *)
FormFactors = FormFactors*FudgeFactor*args["yt"];

FormFactors
]
