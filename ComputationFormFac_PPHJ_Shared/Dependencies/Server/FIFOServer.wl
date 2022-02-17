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
		
(*		If[!(TailProcess === Null), KillProcess[TailProcess]];
		TailProcess = StartProcess[{"tail", "-f", MyConfig["InputFile"]}];*)
	);
	
WaitForInput[] := Module[{NewLine, TCResult, NewLines, fifoproc},
	While[True,
		fifoproc = StartProcess[{"cat", MyConfig["InputFile"]}];
		While[ProcessStatus[fifoproc] === "Running", 
			Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
			Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
		     Pause[MyConfig["RefreshTime"]];
		 ];
		NewLine=ReadString[fifoproc];
		KillProcess[fifoproc];
		
		If[NewLine === EndOfFile,
			Print["Warning: EndOfFile returned. Does the FIFO file exist?"];
			,
			If[!NewLine === "",
				NewLines = NewLine // StringTrim // StringSplit[#, "\n"]& // Map[EchoLabel["FIFOServer.wl: "][#]&];
				Print["Received ", Length[NewLines], " lines."];
				
				MyConfig["InputProcessor"][# // StringSplit[#, RegularExpression @ " (?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"]& // DeleteCases[#, ""]& // Map[StringTrim]]& /@ NewLines
			];
		];
		
		(*If[MyConfig["QueueRun"],
			Do[
				Quiet[Parallel`Developer`QueueRun[], Parallel`Developer`QueueRun::hmm];
			, {j, 20}];
		];*)

	];
];

End[];
EndPackage[];
