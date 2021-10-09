#!/usr/bin/env wolframscript
(* ::Package:: *)

ExportPrecision = 50;
SkipIfFileExists = True;
RunMode = "top";

OneLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);
TwoLoopFudgeFactor = 1./((Pi^4)*(2.^5)*Sqrt[2.]);

fifoFilename = ToString[$ScriptCommandLine[[-1]]];
ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

BaseDirectory = FileNameJoin[{ScriptDirectory, "FIFODependencies"}];
DependenciesPath = FileNameJoin[{BaseDirectory, "Dependencies"}];
SessionsPath = FileNameJoin[{BaseDirectory, "Server", "Sessions"}];
DiffExpPath = FileNameJoin[{BaseDirectory, "DiffExp", "DiffExp.m"}];

Data1LDirectoryStatic = FileNameJoin[{BaseDirectory, "Server", "Data", "Precomputed", "1LCombined_Luisoni", "DataPoints/"}];
Data2LDirectoryStatic = FileNameJoin[{BaseDirectory, "Server", "Data", "Precomputed", "2LCombined_Luisoni", "DataPoints/"}];
DataHeDirectoryStatic = FileNameJoin[{BaseDirectory, "Server", "Data", "Precomputed", "HeCombined_Luisoni", "DataPoints/"}];

AmplitudeDataDirectory = FileNameJoin[{BaseDirectory, "Amplitude", "Data"}];

Print["Loading dependencies.."];
Get[DiffExpPath];
Get[FileNameJoin[{BaseDirectory, "Server", "FIFOServer.wl"}]];
Get[FileNameJoin[{BaseDirectory,"Dependencies", "StandardDefinitions.m"}]];
Get[FileNameJoin[{DependenciesPath, "2LoopProcessing.m"}]];
Get[FileNameJoin[{DependenciesPath, "1LoopProcessing.m"}]];
Get[FileNameJoin[{DependenciesPath, "FamilyHeProcessing.m"}]];
{FFs1Loopgghg, FFs2Loopgghg} = Import[FileNameJoin[{AmplitudeDataDirectory, "gghg-" <> RunMode <> ".mx"}]];

(* Linker for points on the grid and their associated file. *)
IndexingData = Association[
	{"2L" -> {},	"1L" -> {},	"He" -> {}}
];

GetPointHash = Hash[Normal[KeySort[#]], "SHA256", "HexString"] &;

DoIndexing[IndDir_, IndType_] := Module[{HaveRead, CurrFileStream, Counter = 0, CurrPoint},
	Print["Indexing data from ", IndDir];
	
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
			
			(* I remove the Association structure, as this way it is easier to use with the Nearest function.. A replacement is used so the keys are ordered in a consistent way. *)
			Which[
				IndType === "1L", CurrPoint = {s, t, pp4} /. CurrPoint,
				IndType === "2L", CurrPoint = {s, t, pp4} /. CurrPoint,
				IndType === "He", CurrPoint = {s, t, pp4, mmt, mmb} /. CurrPoint
			];
			
			CurrPoint
		}};
	
		Close[CurrFileStream];
	
	, {CurrFile, FileNames[FileNameJoin[{IndDir, "*"}]]}];
	
	IndexingData[IndType] = Flatten[IndexingData[IndType]] /. A -> Identity;
];

DoIndexing[Data1LDirectoryStatic, "1L"];
DoIndexing[Data2LDirectoryStatic, "2L"];
If[RunMode === "topbottom",
	DoIndexing[DataHeDirectoryStatic, "He"];
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
PlugNumericsIntoExpression[ex_, point_] := Module[{Tmp},
	Tmp = ex /.{mt->Sqrt[mmt],mb->Sqrt[mmb],mch->Sqrt[mmc]}/.{(* Doing the replacement for the MS in this way is a lot faster for some reason.. *)MS[a__]:>(MS[a]/.point[[2]]),
	Sequence@@Normal@Map[Rationalize[#, 10^-50]&]@point[[1]]};
	Series[Tmp,{eps,0,0}]//Normal//ReplaceAll[Log[a_]:>PowerExpand[Log[a]]]//Expand//Chop//N
];

ProcessingFunction[fifoin__] := Module[{MyPoint, MyPointTop, MyPointBottom, NewPointComputedProcessed, AllDataComputed = {},
		ComputeNext, DataFilesExported, RunModes, NumericalPointData, FFs1LoopNum, FFs2LoopNum, NewPointComputed, ExportFileName, FFExportFileName,
		(* Variable definitions copied over from the original script. *)
		outString, outFilename, floatArgs, intArgs, boolArgs, precinput = 16, args, FormFactors,
		Compute1L = True (* Note that the 1L integrals also appear in the 2-loop form factors, due to the UV subtraction. *), Compute2L, ComputeHe},
		
	outString = "";
	outString = StringJoin[outString, ToString[$ProcessID]<>"\\n"];
	outString = StringJoin[outString, ToString[Join[{$ScriptCommandLine[[1]]},fifoin]]<>"\\n"];

	outFilename = fifoin[[-1]];	
	
	Print["Arguments received: " <> ToString[fifoin]];
	
	(*If[(Length@fifoin) < 19, Print["Not enough arguments received. Aborting.. "]; Abort[];];*)
	
	floatArgs = Table[ SetPrecision[ImportString[fifoin[[i]],"CSV"][[1]][[1]], precinput], {i, 8} ];
	intArgs = Table[ ImportString[fifoin[[i+8]],"CSV"][[1]][[1]], {i, 3} ];
	boolArgs = Table[ (ImportString[fifoin[[i+11]],"CSV"][[1]][[1]]>0) , {i, 7} ];
	
	args = <|
		"s" -> floatArgs[[1]],
		"t" -> floatArgs[[2]],
		"mu" -> floatArgs[[3]],
		"mh" -> floatArgs[[4]],
		"mb" -> floatArgs[[5]],
		"mt" -> floatArgs[[6]],
		"yb" -> floatArgs[[7]],
		"yt" -> floatArgs[[8]],
		"nloop" -> intArgs[[1]],
		"eps_order" -> intArgs[[2]],
		"nf" -> intArgs[[3]],
		"is_HEFT" -> boolArgs[[1]],
		"inc_ytqcd" -> boolArgs[[2]],
		"inc_ytmb" -> boolArgs[[3]],
		"inc_ytmt" -> boolArgs[[4]],
		"inc_ybqcd" -> boolArgs[[5]],
		"inc_ybmb" -> boolArgs[[6]],
		"inc_ybmt" -> boolArgs[[7]]
	|>;
		
	MyPoint = {s -> args["s"], t -> args["t"], pp4 -> args["mh"]^2, mmt -> args["mt"]^2, mmb -> args["mb"]^2} // Association;
	MyPointTop = MyPoint // Map[#/MyPoint[mmt]&] // KeyTake[{s, t, pp4}];
	(*MyPointBottom = MyPoint // Map[#/MyPoint[mmb]&] // KeyTake[{s, t, pp4}];*)
	
	Compute2L = args["nloop"] > 1;
	ComputeHe = (args["nloop"] > 1) && (RunMode === "topbottom");
	
	Print["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	Print["Warning: y's, nf, and inc_*'s are currently ignored! Only the full top quark gghg channel works currently!."];
	Print["!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"];
	
	Which[
		RunMode === "top", RunModes = {"top"};,
		RunMode === "topbottom", RunModes = {"top", "bottom"};
	];
	
	Print["Processing point: ", MyPoint];
	
	ComputeNext[ComputeType_, ComputePoint_] := Module[{MyHash, NearestPointFile, NearestPointData},
			Print["Computing " <> ComputeType <> " integrals.."];
			Get[FileNameJoin[{SessionsPath, ComputeType <> ".mx"}]];
	
			Print["Nearest point: "];
			NearestPointFile = Nearest[IndexingData[ComputeType][[All, 2]] -> IndexingData[ComputeType][[All, 1]], ComputePoint // Values, 2] // Last;
			NearestPointData = Import @ NearestPointFile;
	
			NewPointComputed = TransportTo[
				NearestPointData,
				ComputePoint // Map[Rationalize[#, 10^-25]&]
			];
			
			(*  
			   We save the point in a notation suitable for DiffExp, so we can always run cross-checks.
			   We lower the precision, to reduce the storage size. In addition we use the mx file format, which is more compact.
			*)
			NewPointComputed[[2]] = NewPointComputed[[2]] // N[#, ExportPrecision] &; 
			
			MyHash = (GetPointHash @ ComputePoint);
			Export[FileNameJoin[{BaseDirectory, "Server", "Data", "Dynamic", "Integrals", ComputeType, MyHash <> ".mx"}], NewPointComputed];
		];
	
	ExportFileName = FileNameJoin[{BaseDirectory, "Server", "Data", "Dynamic", "Processed", (StringJoin @ RunModes) <> "-" <> ToString[args["nloop"]] <> "L", (GetPointHash @ MyPoint) <> ".mx"}];
	
	If[!(FileExistsQ[ExportFileName] && SkipIfFileExists),
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
			]; 
		];
		
		AllDataComputed = AllDataComputed // Flatten;
	
		Print["Exporting processed results.."];
		Export[ExportFileName, 
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
	FFExportFileName = FileNameJoin[{BaseDirectory, "Server", "Data", "Dynamic", "FormFactors", 
		(StringJoin @ RunModes) <> "-" <> ToString[args["nloop"]] <> "L" <> "-gghg", (GetPointHash @ MyPoint) <> ".mx"}] // Echo;
	
	If[! FileExistsQ[FFExportFileName], 
		Print["Plugging point into form factors"];
		
		If[args["nloop"] === 1,
			FormFactors = OneLoopFudgeFactor FFs1Loopgghg // PlugNumericsIntoExpression[#, NumericalPointData] &;
		];
		If[args["nloop"] === 2,
			FormFactors = TwoLoopFudgeFactor FFs2Loopgghg // PlugNumericsIntoExpression[#, NumericalPointData] &;
		];
		Export[FFExportFileName, FormFactors];
		,
		Print["Form factors already computed. Loading result."];
		FormFactors = Import[FFExportFileName];
	];

	FormFactors = SeriesCoefficient[FormFactors, {eps, 0, args["eps_order"]}] * args["yt"] /. mu -> args["mu"];

	(*-----------------------------*)
	outString=StringJoin[outString,"START_OUTPUT_STREAM"<>"\\n"];

	Do[
		outString=StringJoin[outString,(Re[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
	,{ii,Length@FormFactors}];

	Do[ 
		outString=StringJoin[outString,(Im[FormFactors[[ii]]]//CForm//ToString)<>"\\n"]
	,{ii,Length@FormFactors}];

	outString=StringJoin[outString,"END_OUTPUT_STREAM\\n"];

	Print[outString // StringReplace[#, "\\n" -> "\n"]&];

	(*Run["echo '"<>outString<>"' > "<>outFilename];*)
	Run["python3 -c \"open('"<>outFilename<>"','w').write('"<>outString<>"');\""];
	
];

ConfigureFIFOServer[{
	"InputFile" -> FileNameJoin[{ScriptDirectory, fifoFilename}],
	"InputProcessor" -> ProcessingFunction,
	"RefreshTime" -> 0.25
	}];

Print["Tailing FIFO pipe."];
WaitForInput[];
