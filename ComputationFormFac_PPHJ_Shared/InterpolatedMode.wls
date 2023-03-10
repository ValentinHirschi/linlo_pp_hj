#!/usr/bin/env wolframscript
(* ::Package:: *)

(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)

(* Note! Temporary hack puts inc_ytqcd at the end, until it is fixed in the amplitude grid!! *)


Print["Importing data files for interpolated mode.."];
InterpolatedModeDirectory = FileNameJoin[{BaseDirectory, "Data", "InterpolatedMode"}];
InterpolationDataLinker = Import[FileNameJoin[{BaseDirectory, "InterpolationDataLinker.wl"}]];
InterpolationDataFiles = Association[ # -> Import[FileNameJoin[{InterpolatedModeDirectory, #}]] & /@ Values[InterpolationDataLinker][[All, -1]] ];

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
				yt InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 1, 0, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ytmt"], TF10 @ args["inc_ybqcd"], TF10 @ args["inc_ybmb"], TF10 @ args["inc_ytmb"], TF10 @ args["inc_ybmt"], Re}][Sequence @@ nmFromst] +
				yb InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 0, 1, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ytmt"], TF10 @ args["inc_ybqcd"], TF10 @ args["inc_ybmb"], TF10 @ args["inc_ytmb"], TF10 @ args["inc_ybmt"], Re}][Sequence @@ nmFromst] +
				
				I (
					yt InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 1, 0, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ytmt"], TF10 @ args["inc_ybqcd"], TF10 @ args["inc_ybmb"], TF10 @ args["inc_ytmb"], TF10 @ args["inc_ybmt"], Im}][Sequence @@ nmFromst] +
					yb InterpolationData[{args["nloop"], ffind, epsilonPoleIndex, muord, 0, 1, TF10 @ args["inc_ytqcd"], TF10 @ args["inc_ytmt"], TF10 @ args["inc_ybqcd"], TF10 @ args["inc_ybmb"], TF10 @ args["inc_ytmb"], TF10 @ args["inc_ybmt"], Im}][Sequence @@ nmFromst]
				)
			) * Log[mmuu]^muord /. {mmuu -> args["mu"], yt -> args["yt"], yb -> args["yb"]}
		, {muord, 0, Which[args["nloop"] == 1, 0, args["nloop"] == 2 || args["nloop"] == "2/1", 2 + epsilonPoleIndex]}]
	, {ffind, Which[args["amplitude_type"] == "gghg", 4, args["amplitude_type"] == "qqhg", 2]}];

	FormFactors
]
