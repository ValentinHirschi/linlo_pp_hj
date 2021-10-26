#!/usr/bin/env wolframscript
(* ::Package:: *)

(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)

(* Note! Temporary hack puts yt at the end, until better support for the coupling constants is implemented!! *)


Print["Importing data files for interpolated mode.."];
InterpolatedModeDirectory = FileNameJoin[{BaseDirectory, "NumericalData", "InterpolatedMode"}];
InterpolationDataLinker = Import[FileNameJoin[{InterpolatedModeDirectory, "InterpolationDataLinker.wl"}]];
InterpolationDataFiles = Association[ # -> Import[FileNameJoin[{InterpolatedModeDirectory, #}]] & /@ Values[InterpolationDataLinker][[All, -1]] ];

LinkerFileChopPrecision = 10^-5;

ConditionalsList = {};

ProcessingFunctionInterpolated[args__]:=Module[{LinkerKey, SatisfiesArguments, CurrentConditionals, InterpolationDataLinker2, InterpolationData, 
	nmFromst, epsilonPoleIndex, FormFactors, TF10 = (If[# === True, 1, 0] &)},
	
	Print["Looking up arguments in linker file.."];

	LinkerKey = Null;
	Do[
		Print["Trying ", InterpolationDataLinker[LinkerConditionals][[2]]];
		
		SatisfiesArguments = True;
		If[!(LinkerConditionals[args]),
			SatisfiesArguments = False;
			
			AppendTo[
				ConditionalsList,
				(* Todo: add back error reporting *)
				InterpolationDataLinker[LinkerConditionals][[2]]
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
			Print["Skipped entry ", CurrentConditional, "."];
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
	FormFactors = Table[
		Sum[
			(
				yt InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 1, 0, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ybqcd"], Re}][Sequence @@ nmFromst] +
				yb InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 0, 1, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ybqcd"], Re}][Sequence @@ nmFromst] +
				
				I (
					yt InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 1, 0, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ybqcd"], Im}][Sequence @@ nmFromst] +
					yb InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 0, 1, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ybqcd"], Im}][Sequence @@ nmFromst]
				)
			) * Log[mmuu]^muord /. {mmuu -> args["mu"], yt -> args["yt"], yb -> args["yb"]}
		, {muord, 0, Which[args["nloop"] == 1, 0, args["nloop"] == 2 || args["nloop"] == "2/1", 2 + epsilonPoleIndex]}]
	, {ffind, Which[AmplitudeType == "gghg", 4, AmplitudeType == "qqhg", 2]}];

	FormFactors
]
