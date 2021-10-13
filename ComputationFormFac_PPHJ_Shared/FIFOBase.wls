#!/usr/bin/env wolframscript
(* ::Package:: *)

Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];
Get[FileNameJoin[{PPHJSharedDirectory, "ExactMode.wls"}]];
Get[FileNameJoin[{PPHJSharedDirectory, "InterpolatedMode.wls"}]];

Get[FileNameJoin[{BaseDirectory, "Server", "FIFOServer.wl"}]];
ConfigureFIFOServer[{
	"InputFile" -> FileNameJoin[{ScriptDirectory, fifoFilename}],
	"InputProcessor" -> ProcessingFunction,
	"RefreshTime" -> 0.25
	}];

Print["Tailing FIFO pipe."];
WaitForInput[];
