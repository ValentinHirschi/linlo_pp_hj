#!/usr/bin/env wolframscript
(* ::Package:: *)

If[Length[$ScriptCommandLine] > 2,
	ExactModeDirectory = $ScriptCommandLine[[3]];
];
If[Length[$ScriptCommandLine] > 3,
	IndexingFile = $ScriptCommandLine[[4]];
];

Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];

With[{RunCommands = HoldForm[
		Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];
		Get[FileNameJoin[{PPHJSharedDirectory, "ExactMode.wls"}]];
		Get[FileNameJoin[{PPHJSharedDirectory, "InterpolatedMode.wls"}]];
		Get[FileNameJoin[{BaseDirectory, "Server", "FIFOServer.wl"}]];
		FIFOServer`ConfigureFIFOServer[{
			"InputFile" -> FileNameJoin[{ScriptDirectory, fifoFilename}],
			"InputProcessor" -> ProcessingFunction,
			"RefreshTime" -> 0.25
			}];

		Print["Tailing FIFO pipe."];
		FIFOServer`WaitForInput[];
	]},

	If[FIFOListeners === 1,
		ReleaseHold[RunCommands];
		,
		
		Print["Launching ", FIFOListeners," instances."];
		LaunchKernels[FIFOListeners];
		$DistributedContexts = None;
		DistributeDefinitions[fifoFilename, ScriptPath, ScriptName, ScriptDirectory, PPHJSharedDirectory, ExactModeDirectory, IndexingFile];

		ParallelEvaluate[ReleaseHold[RunCommands]];
	];
];
