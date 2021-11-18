#!/usr/bin/env wolframscript
(* ::Package:: *)

ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

DataDirectory = FileNameJoin[{ScriptDirectory, "Dependencies", "Data"}];
CacheDirectory = FileNameJoin[{DataDirectory, "ExactMode"}];
CacheIntegralsDirectory = FileNameJoin[{DataDirectory, "ExactMode", "Integrals"}];
CacheIntegralsProcessedDirectory = FileNameJoin[{DataDirectory, "ExactMode", "Processed"}];
CacheIntegralsFormFactorsDirectory = FileNameJoin[{DataDirectory, "ExactMode", "FormFactors"}];
CacheIndexingFile = FileNameJoin[{DataDirectory, "ExactMode", "Indexing.mx"}];

If[Input["Delete indexing file? (y/n): " <> CacheIndexingFile <> "\n"] === y,
	DeleteFile[CacheIndexingFile];
	Print["Indexing cleared.."];
];

If[Input["Delete cached integral directories? (y/n): " <> CacheIntegralsDirectory <> ", " <> CacheIntegralsProcessedDirectory <> "\n"] === y,
	DeleteDirectory[CacheIntegralsDirectory, DeleteContents -> True];
	DeleteDirectory[CacheIntegralsProcessedDirectory, DeleteContents -> True];
	Print["Integrals cleared.."];
];

If[Input["Delete cached form factor directory? (y/n): " <> CacheIntegralsFormFactorsDirectory <> "\n"] === y,
	DeleteDirectory[CacheIntegralsFormFactorsDirectory, DeleteContents -> True];
	Print["Integrals cleared.."];
];
