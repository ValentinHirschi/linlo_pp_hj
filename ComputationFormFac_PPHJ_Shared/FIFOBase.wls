#!/usr/bin/env wolframscript
(* ::Package:: *)

If[Length[$ScriptCommandLine] > 2,
    If[ Not[$ScriptCommandLine[[3]]=="default"], ExactModeDirectory = $ScriptCommandLine[[3]]; ];
];
If[Length[$ScriptCommandLine] > 3,
    If[ Not[$ScriptCommandLine[[4]]=="default"], IndexingFile = $ScriptCommandLine[[4]]; ];
];

SetOptions[$Output, FormatType -> OutputForm];

ShortLogFN = "";
If[Length[$ScriptCommandLine] > 5,
    If[ Not[$ScriptCommandLine[[6]]=="default"], ShortLogFN = $ScriptCommandLine[[6]]; ];
];

Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];
Get[FileNameJoin[{BaseDirectory, "Server", "FIFOServer.wl"}]];

FIFOFileDirectoryFinal = If[ValueQ[FIFOFileDirectory], FIFOFileDirectory, ScriptDirectory];

If[Length[$ScriptCommandLine] > 4,
    If[ Not[$ScriptCommandLine[[5]]=="default"], FIFOFileDirectoryFinal = $ScriptCommandLine[[5]]; ];
];

(* We admit an internal scheduler which listens to one FIFO file, and which always distributes jobs associated with the same point to the same parallel kernel *)
SchedulerMapper = Association[];
KernelWrapper = 0;

(* Todo: load this from Dependencies instead. However, then we need to make sure eps is initialized in the right order. *)
SchedulerSwapRelations = <|1->{s->s,t->t},2->{s->t,t->s},3->{s->pp4-s-t,t->t},4->{s->s,t->pp4-s-t},5->{s->t,t->pp4-s-t},6->{s->pp4-s-t,t->s}|>;

(* Low precision point preprocessor for purposes of identifying identical points to be sent to the parallel kernels. *)
SchedulerPointPreprocessor := If[InexactNumberQ[#], RationalizeDigits[SetPrecision[#, FloatInputSetPrecisionDigits], SchedulerRationalizeDigits], #] &;

SchedulerProcessingFunction[commands__] := Module[{args, MyPointOrig, MyPointPermuted, SchedulerPreprocessor, CallKernel, ScheduleForKernel = "?", jobs,
	numParallelKernels = Length @ Parallel`Protected`$sortedkernels},
	(* Looks at the incoming point, and schedules it to the appropriate kernels. *)
	
	Block[{(* Suppress printing *)Print}, args = ReadArguments[commands]];
	
	If[args["calltag"] >= 0,
		MyPointOrig = {s -> args["s_orig"], t -> args["t_orig"], pp4 -> args["mh_orig"]^2} // Association;
		MyPointPermuted = Table[Perm -> Thread[{s, t, pp4} -> ({s, t, pp4} /. SchedulerSwapRelations[Perm] /. MyPointOrig // Map[SchedulerPointPreprocessor])], {Perm, 6}] // Association;
	
		Do[
			If[Or @@ (Table[MemberQ[SchedulerMapper[proc], MyPointPermuted[[perm]]], {perm, 6}]),
				ScheduleForKernel = proc;
			];
		, {proc, numParallelKernels}];
	
		(* Update kernelwrapper in case that some subkernel(s) dropped out. (Not fully clear if this works, and ideally all subkernels should stay alive.) *)
		KernelWrapper = Mod[KernelWrapper - 1, numParallelKernels] + 1;
	
		If[ScheduleForKernel == "?",
			Print["Point not encountered before: " <> ToString[MyPointOrig // Map[N], InputForm] <> ". Scheduling on next kernel."];
			(* Add one to KernelWrapper *)
			ScheduleForKernel = (KernelWrapper = Mod[KernelWrapper, Length @ Parallel`Protected`$sortedkernels] + 1);
			,
			Print["Point (or permutations thereof) encountered before: " <> ToString[MyPointOrig // Map[N], InputForm] <> ". Scheduling on: ", ScheduleForKernel];
		];
	
		SchedulerMapper[ScheduleForKernel] = Join[SchedulerMapper[ScheduleForKernel], {MyPointPermuted[1]}] // DeleteDuplicates // Part[#, - Min[Length @ #, FIFOListeners * 100] ;; -1]&;
		
		,
		
		ScheduleForKernel = Abs[args["calltag"]];
		Print["Negative calltag. Scheduling to fixed kernel: ", ScheduleForKernel];
		
		If[Length[Parallel`Protected`$sortedkernels] < ScheduleForKernel,
			Print["Kernel does not exist. Scheduling instead to kernel 1."];
			ScheduleForKernel = 1;
		];
	];
	
	(* Send to kernel: *)		
	With[{pcommands = commands, pScheduleForKernel = ScheduleForKernel},
		Parallel`Developer`Send[Reverse[Parallel`Protected`$sortedkernels][[ScheduleForKernel]], ProcessingFunctionParallel[pcommands, pScheduleForKernel]];
		Parallel`Developer`ReceiveIfReady[Reverse[Parallel`Protected`$sortedkernels][[ScheduleForKernel]]];
	];
];

With[{RunCommands = HoldForm[
		Get[FileNameJoin[{PPHJSharedDirectory, "BaseShared.wls"}]];
		Get[FileNameJoin[{PPHJSharedDirectory, "ExactMode.wls"}]];
		(*Get[FileNameJoin[{PPHJSharedDirectory, "InterpolatedMode.wls"}]];*)
	]},

	If[FIFOListeners === 1,
		ReleaseHold[RunCommands];
		
		(* Load FIFO server and process from main fifo file. *)
		FIFOServer`ConfigureFIFOServer[{
			"InputFile" -> ExpandFileName[FileNameJoin[{FIFOFileDirectoryFinal, fifoFilename}]],
			"InputProcessor" -> ProcessingFunction,
			"RefreshTime" -> 1
			}];

		Print["Tailing file/pipe."];
		FIFOServer`WaitForInput[];
		,
		
		Which[
			ParallelMode === "Single",
			(* Configure parallel kernels *)
			Print["Launching ", FIFOListeners," instances with one listening thread."];
		
			SetSystemOptions["ParallelOptions" -> "RelaunchFailedKernels" -> False];
			SetSystemOptions["ParallelOptions" -> "RecoveryMode" -> "Abandon"];
		
			LaunchKernels[FIFOListeners];
			ParallelEvaluate[Print["Started kernel: ", $KernelID];];
		
			SchedulerMapper = Association @ Table[proc -> {}, {proc, FIFOListeners}];
		
			$DistributedContexts = None;
			DistributeDefinitions[fifoFilename, ScriptPath, ScriptName, ScriptDirectory, PPHJSharedDirectory, ExactModeDirectory, IndexingFile, FIFOFileDirectoryFinal, ShortLogFN];
		
			ParallelEvaluate[ReleaseHold[RunCommands]];

			(* Load FIFO server and process from main fifo file. *)
			FIFOServer`ConfigureFIFOServer[{
				"InputFile" -> ExpandFileName[FileNameJoin[{FIFOFileDirectoryFinal, fifoFilename}]],
				"InputProcessor" -> SchedulerProcessingFunction,
				"RefreshTime" -> 0.25,
				"QueueRun" -> True
				}];

			Print["Tailing FIFO pipe: ", FileNameJoin[{ScriptDirectory, fifoFilename}]];
			FIFOServer`WaitForInput[];
			
			, ParallelMode === "Multi",
			Print["Launching ", FIFOListeners," instances with multiple listening threads."];
			
			LaunchKernels[FIFOListeners];
			$DistributedContexts = None;
			DistributeDefinitions[fifoFilename, ScriptPath, ScriptName, ScriptDirectory, PPHJSharedDirectory, ExactModeDirectory, IndexingFile, FIFOFileDirectoryFinal, ShortLogFN];
			
			ParallelEvaluate[
				ReleaseHold[RunCommands];
				Get[FileNameJoin[{BaseDirectory, "Server", "FIFOServer.wl"}]];
			
				Module[{MyFIFOFile = AppendKernelIDToFileName[FileNameJoin[{FIFOFileDirectoryFinal, fifoFilename}]]},
					(* Load FIFO server and process from main fifo file. *)
					FIFOServer`ConfigureFIFOServer[{
						"InputFile" -> MyFIFOFile,
						"InputProcessor" -> ProcessingFunction,
						"RefreshTime" -> 1
						}];

					Print["Tailing file/pipe: ", MyFIFOFile];
					
					FIFOServer`WaitForInput[];
				];
			];
			
			, True,
			Print["Parallel mode not recognized. Put ParallelMode = \"Multi\" or \"Single\" in BaseConfiguration.wls"];
		];
	];
];
