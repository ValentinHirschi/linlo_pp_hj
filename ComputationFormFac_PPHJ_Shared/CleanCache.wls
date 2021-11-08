#!/usr/bin/env wolframscript
(* ::Package:: *)

ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

DataDirectory = FileNameJoin[{ScriptDirectory, "Dependencies", "Data"}];
CacheDirectory = FileNameJoin[{DataDirectory, "ExactMode"}];

If[Input["Confirm deletion of directory (y/n): " <> CacheDirectory <> "\n"] === y,
	DeleteDirectory[CacheDirectory, DeleteContents -> True];
	Print["Cache cleared.."];
	,
	Print["Aborted."];
];
