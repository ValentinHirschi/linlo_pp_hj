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
	"InputProcessor" -> (Null&)
}];

(* No sanity checking done here. *)
ConfigureFIFOServer[ConfOptions_] := (
		MyConfig = Merge[{MyConfig, ConfOptions}, Last];
		
(*		If[!(TailProcess === Null), KillProcess[TailProcess]];
		TailProcess = StartProcess[{"cat", MyConfig["InputFile"]}];*)
	);
	
WaitForInput[] := Module[{NewLine},
	While[True,
		Pause[MyConfig["RefreshTime"]];

		(*NewLine = RunProcess[TailProcess, EndOfBuffer];*)
		NewLines = RunProcess["cat " <> MyConfig["InputFile"]//StringSplit[#," "]&]["StandardOutput"] // StringTrim // StringSplit[#, "\n"]&;
		Print["Received ", Length[NewLines], " lines."];
		
		If[!NewLine === {},
			MyConfig["InputProcessor"][# // StringSplit[#, RegularExpression @ " (?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"]& // DeleteCases[#, ""]& // Map[StringTrim]]& /@ NewLines
		];
	];
];

End[];
EndPackage[];
