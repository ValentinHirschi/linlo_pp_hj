#!/usr/bin/env wolframscript
(* ::Package:: *)

ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

DataDirectory = FileNameJoin[{ScriptDirectory, "Dependencies", "Data"}];
CacheDirectory = FileNameJoin[{DataDirectory, $ScriptCommandLine[[2]]}];
CacheIntegralsDirectory = FileNameJoin[{DataDirectory, $ScriptCommandLine[[2]], "Integrals"}];
CacheFormFactorsDirectory = FileNameJoin[{DataDirectory, $ScriptCommandLine[[2]], "FormFactors"}];
CacheIndexingFile = FileNameJoin[{DataDirectory, $ScriptCommandLine[[2]], "Indexing.mx"}];

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
