#!/usr/bin/env wolframscript
(* ::Package:: *)

ExportPrecision = 100;
RationalizePointsPrecision = 10^-25;
NumericsPlugInFFPrecision = 10^-50;

ReuseProcessedIntegrals = True;
ReuseFFs = True;

NotationPath = FileNameJoin[{BaseDirectory, "Dependencies"}];
SessionsPath = FileNameJoin[{BaseDirectory, "Server", "Sessions"}];
DiffExpPath = FileNameJoin[{BaseDirectory, "DiffExp", "DiffExp.m"}];

Get[DiffExpPath];

ParallelMatrixExpansionCores = 16;

DataDirectory = FileNameJoin[{BaseDirectory, "Data"}];
Data1LDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "1LCombined", "DataPoints/"}];
Data2LDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "2LCombined", "DataPoints/"}];
DataHeDirectoryStatic = FileNameJoin[{DataDirectory, "GridPrecomputed", "HeCombined", "DataPoints/"}];
DynamicIntegralsTopDirectory = FileNameJoin[{DataDirectory, "ExactMode", "Integrals"}];

IndexingFile = FileNameJoin[{DataDirectory, "ExactMode", "Indexing.mx"}];

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
			{FFs1Loop[CurrAmpType, "top"], FFs2Loop[CurrAmpType, "top"]} = Import[MyFile];
		];
		
		MyFile = FileNameJoin[{AmplitudeDataDirectory, CurrAmpType <> "-" <> "topbottom" <> ".mx"}];
		If[FileExistsQ[MyFile],
			{FFs1Loop[CurrAmpType, "topbottom"], FFs2Loop[CurrAmpType, "topbottom"]} = Import[MyFile];
		];
		,
		{CurrAmpType, {"gghg", "qqhg1", "qqhg2", "qqhg3"}}
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

DoIndexing[Dirs_, IndType_] := Module[{HaveRead, CurrFileStream, Counter = 0, CurrPoint},
	Print["Indexing data from ", Dirs];
	
	Do[
		Counter++; 
		
		If[Mod[Counter, 1000] == 0, Print @ Counter];
		
		CurrFileStream = OpenRead[CurrFile];
	
		HaveRead = {};
	
		AppendTo[HaveRead, ReadLine[CurrFileStream]];
		AppendTo[HaveRead, ReadLine[CurrFileStream]];
		AppendTo[HaveRead, ReadLine[CurrFileStream]];
	
		(* Seemed faster than using AppendTo? Might have been HDD caching. I keep it like this for now. *)
		IndexingData[IndType] = {IndexingData[IndType], A @ {CurrFile, 
			CurrPoint = (HaveRead // StringJoin // StringCases[#, "<|" ~~ Shortest[a__] ~~ "|>" ]& // First // ToExpression);
			
			PointCanonical[IndType, CurrPoint]
		}};
	
		Close[CurrFileStream];
	
	, {CurrFile, Flatten[FileNames[FileNameJoin[{#, "*"}]]& /@ Dirs]}];
	
	IndexingData[IndType] = Flatten[IndexingData[IndType]] /. A -> Identity;
];


If[!FileExistsQ[IndexingFile],
	DoIndexing[{Data1LDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "1L"}]}, "1L"];
	DoIndexing[{Data2LDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "2L"}]}, "2L"];
	DoIndexing[{DataHeDirectoryStatic, FileNameJoin[{DynamicIntegralsTopDirectory, "He"}]}, "He"];
	
	Export[IndexingFile, IndexingData]
	,
	
	Print["Loading index of points.."];
	IndexingData = Import[IndexingFile];
];


Print["Indexing finished."];

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

ProcessingFunctionExact[args__] := Module[{MyPoint, MyPointTop, MyPointBottom, NewPointComputedProcessed, AllDataComputed = {},
		ComputeNext, DataFilesExported, RunModes, NumericalPointData, FFs1LoopNum, FFs2LoopNum, NewPointComputed, ExportFileName, FFExportFileName, CouplingReplacements, RunMode,
		(* Variable definitions copied over from the original script. *)
		floatArgs, intArgs, boolArgs, FormFactors,
		Compute1L = True (* Note that the 1L integrals also appear in the 2-loop form factors, due to the UV subtraction. *), Compute2L, ComputeHe,
		CurrAmplitudeType},
		
	Which[
		args["nf"] === 5, 
		RunMode = "top";,
		
		args["nf"] === 4, 
		RunMode = "topbottom";,
		
		True,
		Print["Only nf = 5 (top contributions) and nf = 4 (top-bottom contributions) are supported..!"];
	];	
	
	Which[
		AmplitudeType == "gghg",
		CurrAmplitudeType = AmplitudeType;
		
		, AmplitudeType == "qqhg",
		(* Add channel index from argument. *)
		CurrAmplitudeType = AmplitudeType <> ToString[args["selected_channel"]];
	];
		
	MyPoint = {s -> args["s"], t -> args["t"], pp4 -> args["mh"]^2, mmt -> args["mt"]^2, mmb -> args["mb"]^2} // Association;
	MyPointTop = MyPoint // Map[#/MyPoint[mmt]&] // KeyTake[{s, t, pp4}];
	
	If[args["nf"] === 4,
		MyPointBottom = MyPoint // Map[#/MyPoint[mmb]&] // KeyTake[{s, t, pp4}];
	];
	
	Compute2L = args["nloop"] > 1;
	ComputeHe = (args["nloop"] > 1) && (RunMode === "topbottom");
	
	Which[
		RunMode === "top", RunModes = {"top"};,
		RunMode === "topbottom", RunModes = {"top", "bottom"};
	];
	
	Print["Processing point: ", MyPoint];
	
	ComputeNext[ComputeType_, ComputePoint_] := Module[{MyHash, NearestPointFile, NearestPointData, FExport},
			Print["Computing " <> ComputeType <> " integrals.."];
			Get[FileNameJoin[{SessionsPath, ComputeType <> ".mx"}]];
			
			(* Override some options from the session files. *)
			Block[{Print}, 
				If[ComputeType === "1L", 
					UpdateConfiguration[
						ExpansionOrder -> 80
					],
					
					UpdateConfiguration[
						ExpansionOrder -> 55,
						If[ParallelMatrixExpansionCores > 1,
							"Parallel" -> ParallelMatrixExpansionCores,
							Sequence @@ {}
						]
					]
				]
			];
	
			Print["Nearest point: "];
			Print[NearestPointFile = Nearest[IndexingData[ComputeType][[All, 2]] -> IndexingData[ComputeType][[All, 1]], ComputePoint // Values] // Last];
			NearestPointData = Import @ NearestPointFile;
			
			If[DeleteDuplicates[Rationalize[({s, t, pp4, mmt, mmb, mm} /. ComputePoint) - ({s, t, pp4, mmt, mmb, mm} /. NearestPointData[[1]]), RationalizePointsPrecision]] === {0},
				Print["Nearest available point is within delta of: ", RationalizePointsPrecision];
				NewPointComputed = NearestPointData;
				
				,
				
				NewPointComputed = TransportTo[
					NearestPointData,
					ComputePoint // Map[Rationalize[#, RationalizePointsPrecision]&]
				];
			
				(*  
				   We save the point in a notation suitable for DiffExp, so we can always run cross-checks.
				   We lower the precision, to reduce the storage size. In addition we use the mx file format, which is more compact.
				*)
				NewPointComputed[[2]] = NewPointComputed[[2]] // N[#, ExportPrecision] &; 
				
				MyHash = (GetPointHash @ ComputePoint);
				ThreadSafeExport[FExport = FileNameJoin[{DynamicIntegralsTopDirectory, ComputeType, MyHash <> ".m"}], NewPointComputed];
			
				(* This is not fully thread-safe but at worst a point is lost in the indexing. *)
				IndexingData = Import[IndexingFile];
				IndexingData[ComputeType] = Append[IndexingData[ComputeType], {FExport, PointCanonical[ComputeType, NewPointComputed[[1]]]}];
				ThreadSafeExport[IndexingFile, IndexingData];
			];
		];
	
	ExportFileName = FileNameJoin[{DataDirectory, "ExactMode", "Processed", (StringJoin @ RunModes) <> "-" <> ToString[args["nloop"]] <> "L", (GetPointHash @ MyPoint) <> ".mx"}];
	
	If[!(FileExistsQ[ExportFileName] && ReuseProcessedIntegrals),
		If[Compute1L, 
			If[MemberQ[RunModes, "top"], 
				ComputeNext["1L", MyPointTop];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults1L // Last // ConvertNotationFinal[#, {Fam1L -> "O"}] & // ReplaceAll[MS["O", a__] :> MS[{"O", "top"}, a]]];
			];
			If[MemberQ[RunModes, "bottom"], 
				ComputeNext["1L", MyPointBottom];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults1L // Last // ConvertNotationFinal[#, {Fam1L -> "O"}] & // ReplaceAll[MS["O", a__] :> MS[{"O", "bottom"}, a]]];
			];
		];
	
		If[Compute2L, 
			If[MemberQ[RunModes, "top"], 
				ComputeNext["2L", MyPointTop];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults2L // Last // ConvertNotationFinal[#, TLNamingReps] & // ReplaceAll[MS[lab_, a__] :> MS[{lab, "top"}, a]]];
			];
			If[MemberQ[RunModes, "bottom"], 
				ComputeNext["2L", MyPointBottom];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResults2L // Last // ConvertNotationFinal[#, TLNamingReps] & // ReplaceAll[MS[lab_, a__] :> MS[{lab, "bottom"}, a]]];
			];
		];
	
		If[ComputeHe, 
			If[And @@ (MemberQ[RunModes, #] & /@ {"top", "bottom"}),
				ComputeNext["He", MyPoint];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResultsHe // Last  // ConvertNotationFinal[#, {FamHe -> "He"}] & // ReplaceAll[MS["He", a__] :> MS[{"He", "top", "bottom"}, a]]];
				
				ComputeNext["He", {s, t, pp4, mmt, mmb} -> ((* Flipped! *){s, t, pp4, mmb, mmt} /. Normal[MyPoint]) // Thread];
				AppendTo[AllDataComputed, NewPointComputed // ConvertDiffExpResultsHe // Last  // ConvertNotationFinal[#, {FamHe -> "He"}] & // ReplaceAll[MS["He", a__] :> MS[{"He", "bottom", "top"}, a]]];
			]; 
		];
		
		AllDataComputed = AllDataComputed // Flatten;
	
		Print["Exporting processed results.."];
		ThreadSafeExport[ExportFileName, 
			{
				MyPoint,
				AllDataComputed
			}
		];
		
		,
		
		Print["Integrals are already computed.. Skipping."];
	];
	
	(* {1-loop ffs, 2-loop ffs} *)
	NumericalPointData = Import[ExportFileName];
	
	(* Since the script can be called multiple times for the same point with different options for eps order and mu, we save the FormFactors in the data directory as well. *)
	FFExportFileName = FileNameJoin[{DataDirectory, "ExactMode", "FormFactors", 
		RunMode <> "-" <> ToString[args["nloop"]] <> "L" <> "-" <> CurrAmplitudeType, (GetPointHash @ MyPoint) <> ".mx"}];
		
	If[! (FileExistsQ[FFExportFileName] && ReuseFFs), 
		Print["Plugging point into form factors"];
		
		If[args["nloop"] === 1,
			FormFactors = FFs1Loop[CurrAmplitudeType, RunMode] // PlugNumericsIntoExpression[#, NumericalPointData, 2] &;
		];
		If[args["nloop"] === 2,
			FormFactors = FFs2Loop[CurrAmplitudeType, RunMode] // PlugNumericsIntoExpression[#, NumericalPointData, 0] &;
		];
		
		ThreadSafeExport[FFExportFileName, FormFactors];
		,
		
		Print["Form factors already computed. Loading result."];
		FormFactors = Import[FFExportFileName];
	];
	
	CouplingReplacements = {
		yt -> args["yt"],
		yb -> args["yb"],
		mu -> args["mu"],
		incytqcd -> If[args["inc_ytqcd"], 1, 0],
		incytmt -> If[args["inc_ytmt"], 1, 0],
		incybqcd -> If[args["inc_ybqcd"], 1, 0],
		incybmb -> If[args["inc_ybmb"], 1, 0],
		incytmb -> If[args["inc_ytmb"], 1, 0],
		incybmt -> If[args["inc_ybmt"], 1, 0]
	};

	FormFactors = SeriesCoefficient[FormFactors /. CouplingReplacements, {eps, 0, args["eps_order"]}];
	
	FormFactors
];
