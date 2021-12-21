#!/usr/bin/env wolframscript
(* ::Package:: *)

Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];

Print["Running with mode: ", $ScriptCommandLine[[11]]];

(* This is to avoid the buffering that comes with the exact mode. *)
If[$ScriptCommandLine[[11]] === "0" || $ScriptCommandLine[[11]] === "2",
	Get[FileNameJoin[{PPHJSharedDirectory, "ExactMode.wls"}]];	
];

If[$ScriptCommandLine[[11]] === "1" || $ScriptCommandLine[[11]] === "2",
	Get[FileNameJoin[{PPHJSharedDirectory, "InterpolatedMode.wls"}]];
];

(* Run script.. *)
ProcessingFunction[Delete[$ScriptCommandLine, 1]];
