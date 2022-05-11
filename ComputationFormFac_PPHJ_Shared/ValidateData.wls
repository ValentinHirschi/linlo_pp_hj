#!/usr/bin/env wolframscript
(* ::Package:: *)

ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

DataDirectory = FileNameJoin[{ScriptDirectory, "Dependencies", "Data"}];
CacheDirectory = FileNameJoin[{DataDirectory, "ExactMode"}];
CacheIntegralsDirectory = FileNameJoin[{DataDirectory, "ExactMode", "Integrals"}];
CacheFormFactorsDirectory = FileNameJoin[{DataDirectory, "ExactMode", "FormFactors"}];
CacheIndexingFile = FileNameJoin[{DataDirectory, "ExactMode", "Indexing.mx"}];

CorruptedList = {};

ValidateFiles[flist_] := Module[{},
	(
		If[Check[Import[#], "fail"] === "fail",
			Print["Could not import: ", #];
			AppendTo[CorruptedList, #];
			,
			Print["Successfully imported: ", #];
		];
	)& /@ flist;
];

FileNames["*.mx", CacheIntegralsDirectory, 2] // Flatten // ValidateFiles;
FileNames["*.mx", CacheFormFactorsDirectory, 2] // Flatten // ValidateFiles;

Print["Corrupted files: "];
If[Length[CorruptedList] === 0,
	Print["None."];
	,
	Print /@ CorruptedList;
];
