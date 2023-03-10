#!/usr/bin/env wolframscript
(* ::Package:: *)

If[!ValueQ[ExactModeDirectory],
	ExactModeDirectory = DefaultExactModeDirectory;
];
Print["Directory for exact mode results: ", ExactModeDirectory];

NotationPath = FileNameJoin[{BaseDirectory, "Dependencies"}];
SessionsPath = FileNameJoin[{BaseDirectory, "Server", "Sessions"}];
DiffExpPath = FileNameJoin[{BaseDirectory, "DiffExp", "DiffExp.m"}];

Get[DiffExpPath];

DataDirectory = FileNameJoin[{BaseDirectory, "Data"}];
Data1LDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "1LCombined", "DataPoints/"}];
Data2LDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "2LCombined", "DataPoints/"}];
DataHeDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "HeCombined", "DataPoints/"}];
DynamicIntegralsTopDirectory = FileNameJoin[{DataDirectory, ExactModeDirectory, "Integrals"}];
ProcessedIntegralsDirectory = FileNameJoin[{DataDirectory, ExactModeDirectory, "Processed"}];

ProcessedIntegralRAMCache = <||>;
PermutationTagCounter = 0;

TrimDataDirectory[fl_] := StringReplace[fl, DataDirectory -> ""];

FloatToString:=Module[{Digs=(RealDigits@*N)[#]},
	If[Digs[[2]] > 0,
		StringJoin[Insert[Digs[[1]]//Map[ToString],".",Digs[[2]]+1]],
		Join[{"0","."},ConstantArray["0", -Digs[[2]]],Digs[[1]] // Map[ToString]] // StringJoin
	]
]&;

If[!ValueQ[IndexingFile],
	IndexingFile = FileNameJoin[{DataDirectory, ExactModeDirectory, "Indexing.mx"}];
	,
	(* Append data directory to the path *)
	IndexingFile = FileNameJoin[{DataDirectory, IndexingFile}];
	
	If[DynamicIndexing === True,
		DynamicIndexing = False;

		Print[];
		Print["Note: dynamic indexing is automatically turned off when a global indexing file is specified."];
		Print[];
	];
];

If[EnablePermutationHack,
	Print["Permutation hack enabled."];
	Print["KeepIntegralsInRAM = True;"];
	KeepIntegralsInRAM = True;
	Print["Internal permutation scan of integral families is done at precision of ", PermutationHackRationalizeDigits, "."];
];

PermutationHackPointPreprocessor := If[InexactNumberQ[#], RationalizeDigits[SetPrecision[#, FloatInputSetPrecisionDigits], PermutationHackRationalizeDigits], #] &;

If[KeepIntegralsInRAM === True,
	Print["KeepIntegralsInRAM is enabled. Dynamic indexing is turned off. Only form factors are written to file-system cache."];
	DynamicIndexing = False;
	WriteIntegralsToCacheBoundaryData = False;
	
	If[DynamicIndexing === True,
		Print[];
		Print["Note: dynamic indexing is automatically turned off when the integrals are kept in RAM."];
		Print[];
	];
];

If[FIFOListeners > 1 && ParallelMatrixExpansionCores > 1,
	Print["FIFOListeners is greater than 1. Setting ParallelMatrixExpansionCores = 1."];
	ParallelMatrixExpansionCores = 1;
];

Print["Indexing file for boundary points: ", IndexingFile];

AmplitudeDataDirectory = FileNameJoin[{DataDirectory, "Amplitude"}];

GaveThreadSafeWarning = False;
ThreadSafeExport[fn_,data_]:=Module[{TmpFile = CreateFile[], FileDirectory = fn // FileNameSplit // Part[#, 1 ;; -2]& // FileNameJoin, fFileExtension = fn // FileExtension},
	If[$OperatingSystem == "MacOSX" || $OperatingSystem == "Unix",
		If[fFileExtension == "mx",
			Export[TmpFile, data, "MX"];
			,
			Export[TmpFile, data  // ToString[#, InputForm]&, "Text"];
		];
	
		If[!DirectoryQ[FileDirectory], CreateDirectory[FileDirectory]];
	
		Run["mv -f \"" <> TmpFile <> "\" \"" <> fn <> "\""];
		
		,
		If[!GaveThreadSafeWarning,
			Print["Warning, thread-safe exporting of results does not work on Windows."];
			GaveThreadSafeWarning = True;
		];
		
		Export[fn, data];
	]
];

Print["Loading dependencies for exact mode.."];
Get[FileNameJoin[{NotationPath, "StandardDefinitions.m"}]];
Get[FileNameJoin[{NotationPath, "2LoopProcessing.m"}]];
Get[FileNameJoin[{NotationPath, "1LoopProcessing.m"}]];
Get[FileNameJoin[{NotationPath, "FamilyHeProcessing.m"}]];

Module[{MyFile},
	Do[
		MyFile = FileNameJoin[{AmplitudeDataDirectory, CurrAmpType <> "-" <> "top" <> ".mx"}];
		If[FileExistsQ[MyFile],
			Print["Importing: ", MyFile];
			{FFs1Loop[CurrAmpType, "top"], FFs2Loop[CurrAmpType, "top"]} = Import[MyFile];
		];
		
		MyFile = FileNameJoin[{AmplitudeDataDirectory, CurrAmpType <> "-" <> "topbottom" <> ".mx"}];
		If[FileExistsQ[MyFile],
			Print["Importing: ", MyFile];
			{FFs1Loop[CurrAmpType, "topbottom"], FFs2Loop[CurrAmpType, "topbottom"]} = Import[MyFile];
		];
		,
		{CurrAmpType, {"gghg", "qqhg1", "qqhg2", "qqhg3", "abelian"}}
	];
];


(* Linker for points on the grid and their associated file. *)
IndexingData = Association[
	{"2L" -> {},	"1L" -> {},	"He" -> {}}
];

GetPointHash = Hash[Normal[KeySort[#]], "SHA256", "HexString"] &;

PointCanonical[FamType_, Pnt_] := Module[{CurrPoint}, 
	(* Remove the Association structure, as this way it is easier to use with the Nearest function.. A replacement is used so the keys are ordered in a consistent way. *)
	Which[
		FamType === "1L", CurrPoint = {s, t, pp4} /. Pnt,
		FamType === "2L", CurrPoint = {s, t, pp4} /. Pnt,
		FamType === "He", CurrPoint = {s, t, pp4, mmt, mmb} /. Pnt
	];
			
	CurrPoint
];

EndOfFileToBlank[ex_] := If[ex === EndOfFile, "", ex];

DoIndexing[Dirs_, IndType_] := Module[{HaveRead, CurrFileStream, Counter = 0, CurrPoint},
	Print["Indexing data from ", Dirs];
	
	Do[
		Counter++; 
		
		If[Mod[Counter, 1000] == 0, Print @ Counter];
		
		CurrFileStream = OpenRead[CurrFile];
	
		HaveRead = {};
	
		AppendTo[HaveRead, ReadLine[CurrFileStream] // EndOfFileToBlank];
		AppendTo[HaveRead, ReadLine[CurrFileStream] // EndOfFileToBlank];
		AppendTo[HaveRead, ReadLine[CurrFileStream] // EndOfFileToBlank];
		AppendTo[HaveRead, ReadLine[CurrFileStream] // EndOfFileToBlank];
		AppendTo[HaveRead, ReadLine[CurrFileStream] // EndOfFileToBlank];
	
		(* Seemed faster than using AppendTo? Might have been HDD caching. I keep it like this for now. *)
		IndexingData[IndType] = {IndexingData[IndType], A @ {TrimDataDirectory @ CurrFile, 
			Check[
			CurrPoint = (HaveRead // StringJoin // StringReplace[#, "\n" -> ""]& // StringCases[#, "<|" ~~ Shortest[a__] ~~ "|>" ]& // First // ToExpression);
			,
			Print[CurrFile];
			Abort[];
			];
			
			PointCanonical[IndType, CurrPoint]
		}};
	
		Close[CurrFileStream];
	
	, {CurrFile, Flatten[FileNames[FileNameJoin[{#, "*"}]]& /@ Dirs]}];
	
	IndexingData[IndType] = Flatten[IndexingData[IndType]] /. A -> Identity;
];


If[!FileExistsQ[IndexingFile],
	If[DynamicIndexing === True,
		DoIndexing[{Data1LDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "1L"}]}, "1L"];
		DoIndexing[{Data2LDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "2L"}]}, "2L"];
		DoIndexing[{DataHeDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "He"}]}, "He"];
		,
		DoIndexing[{Data1LDirectoryStatic}, "1L"];
		DoIndexing[{Data2LDirectoryStatic}, "2L"];
		DoIndexing[{DataHeDirectoryStatic}, "He"];
	];
	
	Export[IndexingFile, IndexingData];
	
	Print["Indexing finished."];
	,
	
	Print["Loading index of points.."];
	IndexingData = Import[IndexingFile];
];


(* There are functions for converting notation in the **Processing.m notebooks. However, the notation changed once more, so this is a function to move to the final notation. 
	This can be improved in the future by combining it with the previous notebooks. *)
GiulioToHjalteSwaps = SwapRelations[[2]] // Normal // Map[#[[2,1]] -> #[[1]]&];
ConvertNotationFinal[or_,labreps_]:=Table[
	RR[or[[All,1]] /. Table[
		With[{llr = lr},
			llr[[1]][perm_][int_] :> MS[llr[[2]], int, perm /. GiulioToHjalteSwaps, order]
		], {lr, labreps}],
		SeriesCoefficient[or[[All,2]], {\[Epsilon], 0, order}]
		] /. RR -> Rule // Thread
	, {order,0,5}] // Flatten;
TLNamingReps = {FamA -> "A", FamAf -> "Af", FamBs -> "Bs", FamC -> "C", FamD -> "D", FamF -> "F", FamG -> "G"};

(* Function for plugging numerics into the amplitudes.*)
PlugNumericsIntoExpression[ex_, point_, maxepsord_] := Module[{Tmp},
	Tmp = ex /.{mt->Sqrt[mmt],mb->Sqrt[mmb],mch->Sqrt[mmc]}/.{(* Doing the replacement for the MS in this way is a lot faster for some reason.. *)MS[a__]:>(MS[a]/.point[[2]]),
	Sequence@@Normal@Map[Rationalize[#, NumericsPlugInFFPrecision]&]@point[[1]]
	};
	Series[Tmp,{eps,0,maxepsord}]//Normal//ReplaceAll[Log[a_]:>PowerExpand[Log[a]]]//Expand//N
];

ProcessingFunctionExact[args__] := Module[{MyPoint, MyPointOrig, MyPointPermuted, MyPointTop, MyPointBottom, NewPointComputedProcessed, AllDataComputed = {},
		ComputeNext, DataFilesExported, ComputeParts, NumericalPointData, FFs1LoopNum, FFs2LoopNum, NewPointComputed, FFExportFileName, FFExportFileNameGen, CouplingReplacements, RunMode,
		(* Variable definitions copied over from the original script. *)
		floatArgs, intArgs, boolArgs, FormFactors,
		Compute1L = True (* Note that the 1L integrals also appear in the 2-loop form factors, due to the UV subtraction. *), Compute2L, ComputeHe,
		CurrAmplitudeType, FormFactorsExist, FormFactorsExistTop, FormFactorsExistBottom,
		FoundProcessedIntegrals, IntegralsProcessedSplit, IntegralsProcessedSinglePerm, ImportProcessedIntegrals, ProcessIntegrals, BenchMarkTimes = {}, PointMetaData,
		MyPointPermutedLowPrecision, MyPointPermutedHackAware, ComputeAndExportFFs,
		MyPointHe1, MyPointHe2},

	Which[
		Chop[args["mb"]] === 0, 
		Print["Running in \"top\" mode, with mb = 0."];
		RunMode = "top";,
		
		True,
		Print["Running in \"topbottom\" mode, with mb != 0."];
		RunMode = "topbottom";
	];	
	
	Print["Calltag: ", args["calltag"]];
	
	Which[
		args["amplitude_type"] == "qqhg",
		(* Add channel index from argument. *)
		CurrAmplitudeType = args["amplitude_type"] <> ToString[args["selected_channel"]];
		
		, True,
		CurrAmplitudeType = args["amplitude_type"];
	];
		
	MyPoint = {s -> args["s"], t -> args["t"], pp4 -> args["mh"]^2, mmt -> args["mt"]^2, mmb -> args["mb"]^2} // Association;
	MyPointOrig = {s -> args["s_orig"], t -> args["t_orig"], pp4 -> args["mh_orig"]^2, mmt -> args["mt_orig"]^2, mmb -> args["mb_orig"]^2} // Association;
	MyPointPermuted = Table[
		Perm -> Thread[{s, t, pp4, mmt, mmb} -> ({s, t, pp4, mmt, mmb} /. SwapRelations[[1]][Perm] /. MyPointOrig // Map[PointPreprocessor])]
	, {Perm, 6}] // Association;
	
	(* MyPointPermutedHackAware is used for internal lookups. *)
	MyPointPermutedLowPrecision = Table[
		Perm -> Thread[{s, t, pp4, mmt, mmb} -> ({s, t, pp4, mmt, mmb} /. SwapRelations[[1]][Perm] /. MyPointOrig // Map[PermutationHackPointPreprocessor])]
	, {Perm, 6}] // Association;
	MyPointPermutedHackAware = If[EnablePermutationHack === True, MyPointPermutedLowPrecision, MyPointPermuted];
	If[EnablePermutationHack,
		If[!Length[Values[MyPointPermutedLowPrecision] // DeleteDuplicates] === Length[Values[MyPointPermuted] // DeleteDuplicates],
			Print["Unable to distinguish permutations within internal lookups. Please increase precision of the permutation hack."];
			Abort[];
		];
	];
	
	MyPointTop = MyPoint // Map[#/MyPoint[mmt]&] // KeyTake[{s, t, pp4}];
	Which[
		! Chop[args["mb"]] === 0, 
		MyPointBottom = MyPoint // Map[#/MyPoint[mmb]&] // KeyTake[{s, t, pp4}];
	];
	
	Compute2L = args["nloop"] > 1;
	ComputeHe = (args["nloop"] > 1) && (RunMode === "topbottom");

	Print["Processing point: ", MyPoint];
	
	(* Since the script can be called multiple times for the same point with different options for eps order and mu, we check if the FormFactors are already in the data directory. *)
	FFExportFileNameGen[fftype_] := FileNameJoin[{DataDirectory, ExactModeDirectory, "FormFactors", fftype <> "-" <> ToString[args["nloop"]] <> "L" <> "-" <> CurrAmplitudeType, (GetPointHash @ MyPoint) <> ".mx"}];
	FFExportFileName = FFExportFileNameGen[RunMode];
	
	FormFactorsExistTop = (FileExistsQ[FFExportFileNameGen["top"]] && ReuseFFs);
	FormFactorsExistBottom = (FileExistsQ[FFExportFileNameGen["topbottom"]] && ReuseFFs);
	
	
	
	Which[
		RunMode === "top",
		FormFactorsExist = FormFactorsExistTop,
			
		RunMode === "topbottom",
		FormFactorsExist = FormFactorsExistBottom
	];
	
	Which[
		RunMode === "top", ComputeParts = {"top"};,
		RunMode === "topbottom", 
			If[!FormFactorsExistTop || (!RecycleFFTop === True),
				ComputeParts = {"top", "bottom"};
				,
				ComputeParts = {"bottom"};
			];
	];
	
	ComputeNext[ComputeType_, ComputePoint_] := Module[{MyHash, NearestPointFile, NearestPointData, FExport},
			Print["Computing " <> ComputeType <> " integrals.."];
			Get[FileNameJoin[{SessionsPath, ComputeType <> ".mx"}]];
			
			UpdateConfiguration[WorkingPrecision -> 700, ChopPrecision -> 300, RadiusOfConvergence -> 4, AccuracyGoal -> 15];
			
			(*Print[CurrentConfiguration[]];
			Abort[];*)
			
			(* Override some options from the session files. *)
			Block[{Print}, 
				If[ComputeType === "1L", 
					UpdateConfiguration[
						ExpansionOrder -> ExpansionOrder1L,
						"Parallel" -> False
					],
					
					UpdateConfiguration[
						ExpansionOrder -> ExpansionOrder2L,
						If[ParallelMatrixExpansionCores > 1,
							"Parallel" -> ParallelMatrixExpansionCores,
							"Parallel" -> False
						]
					]
				]
			];
	
			Print["Nearest point: "];
			Print[NearestPointFile = Nearest[IndexingData[ComputeType][[All, 2]] -> IndexingData[ComputeType][[All, 1]], ComputePoint // Values] // Last];
			NearestPointFile = FileNameJoin[{DataDirectory, NearestPointFile}];
			Print["Nearest point file is: ", NearestPointFile];
			
			If[!FileExistsQ[NearestPointFile],
				Print["Could not find boundary conditions file. Remove Indexing.mx and try again."];
				Abort[];
			];
			
			NearestPointData = Import @ NearestPointFile;
			If[Length[Cases[NearestPointData, $Failed, Infinity]] > 0,
				Print["There seems to be an error with the imported file."];
				Abort[];
			];
			
			If[DeleteDuplicates[Chop[N[({s, t, pp4, mmt, mmb, mm} /. ComputePoint) - ({s, t, pp4, mmt, mmb, mm} /. NearestPointData[[1]]), 200], BoundaryPointDelta]] === {0},
				Print["Nearest available point is within delta of: ", BoundaryPointDelta];
				NewPointComputed = NearestPointData;
				
				,
				
				NewPointComputed = TransportTo[
					NearestPointData,
					ComputePoint
				];
			
				(*  
				   We save the point in a notation suitable for DiffExp, so we can always run cross-checks.
				   We lower the precision, to reduce the storage size. In addition we use the mx file format, which is more compact.
				*)
				NewPointComputed[[2]] = NewPointComputed[[2]] // N[#, ExportPrecision] &; 
				
				MyHash = (GetPointHash @ ComputePoint);
				
				If[!WriteIntegralsToCacheBoundaryData === False,
					ThreadSafeExport[FExport = FileNameJoin[{DynamicIntegralsTopDirectory, ComputeType, MyHash <> ".m"}], NewPointComputed];
					
					If[DynamicIndexing === True,
						(* This is not fully thread-safe but at worst a point is lost in the indexing. *)
						IndexingData = Import[IndexingFile];
						IndexingData[ComputeType] = Append[IndexingData[ComputeType], {TrimDataDirectory @ FExport, PointCanonical[ComputeType, NewPointComputed[[1]]]}];
						ThreadSafeExport[IndexingFile, IndexingData];
					];
				];
			];
		];
	
	ProcessIntegrals[] := Module[{},
		If[Compute1L, 
			If[MemberQ[ComputeParts, "top"], 
				ComputeNext["1L", MyPointTop];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults1L // Last // ConvertNotationFinal[#, {Fam1L -> "O"}] & // ReplaceAll[MS["O", a__] :> MS[{"O", "top"}, a]]];
			];
			If[MemberQ[ComputeParts, "bottom"], 
				ComputeNext["1L", MyPointBottom];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults1L // Last // ConvertNotationFinal[#, {Fam1L -> "O"}] & // ReplaceAll[MS["O", a__] :> MS[{"O", "bottom"}, a]]];
			];
		];
	
		If[Compute2L, 
			If[MemberQ[ComputeParts, "top"], 
				ComputeNext["2L", MyPointTop];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults2L // Last // ConvertNotationFinal[#, TLNamingReps] & // ReplaceAll[MS[lab_, a__] :> MS[{lab, "top"}, a]]];
			];
			If[MemberQ[ComputeParts, "bottom"], 
				ComputeNext["2L", MyPointBottom];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults2L // Last // ConvertNotationFinal[#, TLNamingReps] & // ReplaceAll[MS[lab_, a__] :> MS[{lab, "bottom"}, a]]];
			];
		];
	
		If[ComputeHe, 
			If[MemberQ[ComputeParts, "bottom"],
				MyPointHe1 = MyPoint // Map[# / MyPoint[mmt]&];
				MyPointHe2 = {s, t, pp4, mmt, mmb} -> ((* Flipped! *){s, t, pp4, mmb, mmt} /. Normal[MyPoint]) // Thread // Association // Map[# / MyPoint[mmb]&];
										
				ComputeNext["He", MyPointHe1];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResultsHe // Last  // ConvertNotationFinal[#, {FamHe -> "He"}] & // ReplaceAll[MS["He", a__] :> MS[{"He", "top", "bottom"}, a]]];
				
				ComputeNext["He", MyPointHe2];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResultsHe // Last  // ConvertNotationFinal[#, {FamHe -> "He"}] & // ReplaceAll[MS["He", a__] :> MS[{"He", "bottom", "top"}, a]]];
			]; 
		];
		
		AllDataComputed = AllDataComputed // Flatten;
		
		NumericalPointData = {
				MyPoint,
				AllDataComputed
			};
	];
	
	BenchMarkTimes = {};
	AppendTo[BenchMarkTimes, {"Start", AbsoluteTime[]}];
	
	PointMetaData = RunMode <> "-" <> ToString[args["nloop"]] <> "L";
		
	(* Check if entry for current calltag *)
	If[!KeyExistsQ[ProcessedIntegralRAMCache, args["calltag"]], 
		(* Make sure the memory cache has an entry for the current runmode. *)
		ProcessedIntegralRAMCache[args["calltag"]] = Association[];
	];
		
	(* Make sure the memory cache has an entry for the current runmode. *)
	If[!KeyExistsQ[ProcessedIntegralRAMCache[args["calltag"]], PointMetaData], 
		ProcessedIntegralRAMCache[args["calltag"]][PointMetaData] = Association[];
	];
	
	If[FormFactorsExist,
		Print["Form factors already computed. Loading result."];
		FormFactors = Import[FFExportFileName];
		
		(* Check if point was saved together with the form factors. This was not the case in an older version of the code. *)
		If[FormFactors[[1,0]] === Association,
			FormFactors = FormFactors[[2]];
		];
		
		AppendTo[BenchMarkTimes, {"FormFactorsImported", AbsoluteTime[]}];
		
		,
		(* We are keeping integrals in RAM. *)
		FoundProcessedIntegrals = And @@ (KeyExistsQ[ProcessedIntegralRAMCache[args["calltag"]][PointMetaData], #]& /@ Values[MyPointPermutedHackAware]);
		If[FoundProcessedIntegrals,
			(* Check that all integrals have the same tag. If there are mixed tags, we don't buffer these results, as they are affected by the lookup precision. *)
			If[!SameQ[Sequence @@ ((ProcessedIntegralRAMCache[args["calltag"]][PointMetaData][#][[3]] & /@ Values[MyPointPermutedHackAware]))],
				Print["Warning: Mixed tags found in internal lookup table. Discarding buffered results and recomputing.!"];
				FoundProcessedIntegrals = False;
			];
		];
		
		Print["Found match for processed integrals: ", FoundProcessedIntegrals];
		Print[];
		Print["Location of the form factors:", FFExportFileName];
		Print["Form factors exist: ", FormFactorsExist];
		If[RunMode === "topbottom" && RecycleFFTop === True,
			Print["Running in topbottom mode with recycling enabled."];
			Print["Form factors exist top: ", FormFactorsExistTop];
		];
		
		Print[];
(*		Print["My point permuted"];
		MyPointPermuted // Map[Print];*)
		
		AppendTo[BenchMarkTimes, {"SearchCompleted", AbsoluteTime[]}];
		
		If[!(FoundProcessedIntegrals),
			(* Integrals not available or re-use is off. *)
			(* The below function sets the variable NumericalPointData *)
			ProcessIntegrals[];
			
			AppendTo[BenchMarkTimes, {"IntegralsProcessed", AbsoluteTime[]}];
			
			(* Split up all the processed integrals into separate parts, for each respective permutation. *)
			IntegralsProcessedSplit = Table[
				perm -> Select[AllDataComputed, MatchQ[#[[1]], MS[_, _, perm /. SwapRelations[[3]], _]]&] /. MS[a_, b_, perm_, c_] :> MS[a, b, c]
			, {perm, 6}] // Association;
			
			PermutationTagCounter += 1;
			KeyValueMap[
				(ProcessedIntegralRAMCache[args["calltag"]][PointMetaData][MyPointPermutedHackAware[#1]] = {MyPointPermuted[#1], #2, PermutationTagCounter};) &
				, IntegralsProcessedSplit
			];
			
			AppendTo[BenchMarkTimes, {"IntegralsWritten", AbsoluteTime[]}];
			
			,
			
			(* Integrals are found, and we are re-using results *)
			NumericalPointData = {
				(* We take the point from the RAMCache since it is higher precision than the lookup precision, and is less likely to cause a problem A/(A+delta) *)
				ProcessedIntegralRAMCache[args["calltag"]][PointMetaData][MyPointPermutedHackAware[1]][[1]],
				Table[ProcessedIntegralRAMCache[args["calltag"]][PointMetaData][MyPointPermutedHackAware[perm]][[2]] /. MS[a_, b_, c_] :> MS[a, b, perm /. SwapRelations[[3]], c], {perm, 6}] // Flatten
			};
		];
		
		Print["Plugging results into form factors.."];
		
		ComputeAndExportFFs[fftype_] := Module[{ZeroIfPartial, ffload},
			If[fftype === "topbottompartial", 
				ffload = "topbottom",
				ffload = fftype;			
			];
			
			ZeroIfPartial[ex_] := If[
				fftype === "topbottompartial",
				(* Remove top contributions, we'll add them from the recycled result. *)
				ex /. {incytqcd -> 0, incytmt -> 0}, 
				(* Otherwise, return the default expression. *)
				ex
			];
		
			If[args["nloop"] === 1,
				FormFactors = FFs1Loop[CurrAmplitudeType, ffload] // ZeroIfPartial // PlugNumericsIntoExpression[#, NumericalPointData, 2] &;
			];
			
			If[args["nloop"] === 2,
				FormFactors = FFs2Loop[CurrAmplitudeType, ffload] // ZeroIfPartial // PlugNumericsIntoExpression[#, NumericalPointData, 0] &;
			];
			
			ThreadSafeExport[FFExportFileNameGen[fftype], {MyPoint, FormFactors}];
		];
		
		Which[
			RunMode === "top",
			ComputeAndExportFFs["top"];
			
			, RunMode === "topbottom",
			If[RecycleFFTop === True,
				If[!FormFactorsExistTop,
					ComputeAndExportFFs["top"];
				];
				ComputeAndExportFFs["topbottompartial"];
				
				(* Add top contribution *)
				FormFactors = FormFactors + (Import[FFExportFileNameGen["top"]] // If[#[[1, 0]] === Association, #[[2]], #]&);
				ThreadSafeExport[FFExportFileNameGen["topbottom"], {MyPoint, FormFactors}];
				,
				
				(* No recycling happening. *)
				ComputeAndExportFFs["topbottom"];
			]
		];
		
		
		AppendTo[BenchMarkTimes, {"FormFactorsComputed", AbsoluteTime[]}];
	];
	
	(* Form factors are loaded into the appropriate variable. Plug in the free parameters: *)
	CouplingReplacements = {
		yt -> args["yt"],
		yb -> args["yb"],
		mu -> args["mu"],
		incytqcd -> If[args["inc_ytqcd"], 1, 0],
		incytmt -> If[args["inc_ytmt"], 1, 0],
		incybqcd -> If[args["inc_ybqcd"], 1, 0],
		incybmb -> If[args["inc_ybmb"], 1, 0],
		incytmb -> If[args["inc_ytmb"], 1, 0],
		incybmt -> If[args["inc_ybmt"], 1, 0],
		nq -> args["nf"],
		Kmos -> KmOSReplace,
		Kyos -> KyOSReplace
	};

	Do[
		If[Length[ProcessedIntegralRAMCache[args["calltag"]][k]] > 6 * MaxPointsInRAM,
			(* Clear a point from the cache. *)
			Print["Clearing a point from memory: ", k];
			ProcessedIntegralRAMCache[args["calltag"]][k] = ProcessedIntegralRAMCache[args["calltag"]][k][[7 ;; -1]];
		];
	, {k, Keys @ ProcessedIntegralRAMCache[args["calltag"]]}];

	FormFactors = SeriesCoefficient[FormFactors /. CouplingReplacements, {eps, 0, args["eps_order"]}];
	
	AppendTo[BenchMarkTimes, {"End", AbsoluteTime[]}];
	
	Print[];
	Print["Benchmarking:"];
	Partition[BenchMarkTimes, 2, 1] // Map[Print[#[[1,1]] <> " - " <> #[[2,1]] <> " = ", FloatToString @ (#[[2,2]] - #[[1,2]])] &];
	Print[BenchMarkTimes[[-1,1]] <> " - " <> BenchMarkTimes[[1,1]], " = ", FloatToString @ (BenchMarkTimes[[-1,2]] - BenchMarkTimes[[1,2]])];
	Print[];
	
	If[!ShortLogFN === "",
		PutAppend[{DateString[], "OUT", "Recycled FF's: " <> ToString[FormFactorsExist], MyPoint}, AppendKernelIDToFileName[ShortLogFN], CharacterEncoding -> "UTF-8"]
	];
	
	FormFactors
];
