(* ::Package:: *)

(* A basic template for dealing with FIFO files. Made by Martijn Hidding. *)
BeginPackage["FIFOServer`"];

ConfigureFIFOServer::usage = "Set configuration options for the FIFO server.";
WaitForInput::usage = "Waits for input from the FIFO file.";
WriteOutputLine::usage = "Write line to the output file."

Begin["`Private`"];

(*TailProcess = Null;*)
MyConfig = Association[{
	"RefreshTime" -> 1,
	"InputProcessor" -> (Null&),
	"QueueRun" -> False
}];

(* No sanity checking done here. *)
ConfigureFIFOServer[ConfOptions_] := (
		MyConfig = Merge[{MyConfig, ConfOptions}, Last];
		
		FIFOMode = False;
		If[KeyExistsQ[MyConfig, "InputFile"],
			If[StringContainsQ[RunProcess[{"file", MyConfig["InputFile"]}]["StandardOutput"], "named pipe"],
				FIFOMode = True;
			];
		];
		Print["FIFOMode: ", FIFOMode];
		
		(*TailProcess = StartProcess[{"tail", "-f", MyConfig["InputFile"]}];*)
	);
	
WaitForInput[] := Module[{NewLine, TCResult, NewLines, fifoproc, CurrLineNumber = 1, FileImported, LastModified},
	While[True,
		If[FIFOMode,
			fifoproc = StartProcess[{"cat", MyConfig["InputFile"]}];
			While[ProcessStatus[fifoproc] === "Running", 
				If[ParallelMode === "Single" && FIFOListeners > 1,
					Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
					Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
				];
				Pause[MyConfig["RefreshTime"]];
			];
			
			NewLine=ReadString[fifoproc];
			KillProcess[fifoproc];
			
			,
			
			FileModifiedQ := If[!FileExistsQ[MyConfig["InputFile"]], False, 
				With[{ModificationLines = (*RunProcess[{"wc", "-l", MyConfig["InputFile"]}]["StandardOutput"]*)FileSize[MyConfig["InputFile"]]}, 
					If[LastModified === ModificationLines, False, LastModified = ModificationLines; True]
				]
			];
			
			While[!FileModifiedQ,
				If[ParallelMode === "Single" && FIFOListeners > 1,
					Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
					Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
				];
				
				Pause[MyConfig["RefreshTime"]];
			];
			
			Print["File change detected."];

			FileImported = Import[MyConfig["InputFile"], "Text"] // StringTrim // StringSplit[#, "\n"]&;
			NewLine = FileImported[[CurrLineNumber ;; -1]] // Map[StringTrim] // DeleteCases[#, ""]& // Riffle[#, "\n"]& // StringJoin;
			
			CurrLineNumber = (Length @ FileImported) + 1;
	
		];

		If[NewLine === EndOfFile,
			If[FIFOMode,
				Print["Warning: EndOfFile returned. Does the file still exist?"];
			];
			,
			If[!NewLine === "",
				NewLines = NewLine // StringTrim // StringSplit[#, "\n"]& // Map[EchoLabel["FIFOServer.wl: "][#]&];
				Print["Received ", Length[NewLines], " lines."];
				
				MyConfig["InputProcessor"][# // StringSplit[#, RegularExpression @ " (?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"]& // DeleteCases[#, ""]& // Map[StringTrim]]& /@ NewLines
			];
		];
		
		If[ParallelMode === "Single" && FIFOListeners > 1,
			Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
		];
	];
];

End[];
EndPackage[];
