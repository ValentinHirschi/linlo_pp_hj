#!/usr/bin/env wolframscript
(* ::Package:: *)

(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)

(* Note! Temporary hack puts yt at the end, until better support for the coupling constants is implemented!! *)


Print["Importing data files for interpolated mode.."];
InterpolatedModeDirectory = FileNameJoin[{BaseDirectory, "InterpolatedMode"}];
InterpolationDataLinker = Import[FileNameJoin[{InterpolatedModeDirectory, "InterpolationDataLinker.m"}]];
InterpolationDataFiles = Association[ # -> Import[FileNameJoin[{InterpolatedModeDirectory, #}]] & /@ Values[InterpolationDataLinker][[All, -1]] ];

LinkerFileChopPrecision = 10^-5;

ConditionalsList = {};

ProcessingFunctionInterpolated[args__]:=Module[{LinkerKey, SatisfiesArguments, CurrentConditionals, InterpolationDataLinker2, InterpolationData, nmFromst, epsilonPoleIndex, FormFactors},
	Print["Looking up arguments in linker file.."];

	LinkerKey = Null;
	Do[
	  SatisfiesArguments = True;
	  CurrentConditionals = {
	    {((Chop[#, LinkerFileChopPrecision]&@*N)[(If[LinkerConditionals["mh"]!=0,Abs[(args["mh"] - LinkerConditionals["mh"])/LinkerConditionals["mh"]],Abs[(args["mh"] - LinkerConditionals["mh"])]])]) === 0, "mh doesn't match"},
	    {((Chop[#, LinkerFileChopPrecision]&@*N)[(If[LinkerConditionals["mb"]!=0,Abs[(args["mb"] - LinkerConditionals["mb"])/LinkerConditionals["mb"]],Abs[(args["mb"] - LinkerConditionals["mb"])]])]) === 0, "mb doesn't match"},
	    {((Chop[#, LinkerFileChopPrecision]&@*N)[(If[LinkerConditionals["mt"]!=0,Abs[(args["mt"] - LinkerConditionals["mt"])/LinkerConditionals["mt"]],Abs[(args["mt"] - LinkerConditionals["mt"])]])]) === 0, "mt doesn't match"},
	    {MatchQ[args["nloop"], LinkerConditionals["nloop"]] === True, "nloop doesn't match"},
	    {args["nf"] - LinkerConditionals["nf"] === 0, "nf doesn't match"},
	    {args["is_HEFT"] === LinkerConditionals["is_HEFT"], "is_HEFT doesn't match"},
	    {args["inc_ytqcd"] === LinkerConditionals["inc_ytqcd"], "inc_ytqcd doesn't match"},
	    {((args["inc_ytmb"] === LinkerConditionals["inc_ytmb"])||(args["nloop"]==1)), "inc_ytmb doesn't match"},
	    {((args["inc_ytmt"] === LinkerConditionals["inc_ytmt"])||(args["nloop"]==1)), "inc_ytmt doesn't match"},
	    {args["inc_ybqcd"] === LinkerConditionals["inc_ybqcd"], "inc_ybqcd doesn't match"},
	    {((args["inc_ybmb"] === LinkerConditionals["inc_ybmb"])||(args["nloop"]==1)), "inc_ybmb doesn't match"},
	    {((args["inc_ybmt"] === LinkerConditionals["inc_ybmt"])||(args["nloop"]==1)), "inc_ybmt doesn't match"},
	    {AmplitudeType === LinkerConditionals["amplitude"], "amplitude type doesn't match"}
	    (*{(LinkerConditionals["stRange"] /. {s -> args["s"], t -> args["t"]}) === True, "Range of s,t doesn't fit."}*)
	  };
	
		If[!(And@@CurrentConditionals[[All,1]]),
			SatisfiesArguments = False;
			
			AppendTo[
				ConditionalsList,
				InterpolationDataLinker[LinkerConditionals][[2]] -> CurrentConditionals[[Flatten[Position[CurrentConditionals[[All, 1]], False]],2]]
			];
		];
	
		If[SatisfiesArguments,
			Print["Found suitable datafile..: ", InterpolationDataLinker[LinkerConditionals][[2]]];
			LinkerKey = LinkerConditionals;
		
			(* Not a very clean way to exit the Do loop, but it works for now.*)
			Return["", Do];
		];
		
		, {LinkerConditionals, InterpolationDataLinker//Keys}
	];

	If[LinkerKey === Null,
		Print["No datafile found for the current configuration options.."];
		Do[
			Print["************************************************"];
			Print["Skipped entry ", CurrentConditional[[1]], " due to:"];
			Print[CurrentConditional[[2]]];
			Print["************************************************"];
		, {CurrentConditional, ConditionalsList}];
		
		Abort[];
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
	FormFactors = args["yt"] * Table[
		Sum[
			(
			  InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, epsilonPoleIndex, muord, Re}][Sequence @@ nmFromst] + 
			  I InterpolationData[{"Top", ToString[args["nloop"]] <> "-Loop", ffind, epsilonPoleIndex, muord, Im}][Sequence @@ nmFromst]
			) * (Log[mmuu]^muord /. mmuu -> args["mu"])
		, {muord, 0, Which[args["nloop"] == 1, 0, args["nloop"] == 2, 2+epsilonPoleIndex]}]
	, {ffind, 4}];

	FormFactors
]
