(* ::Package:: *)

(* A basic template for dealing with FIFO files. Made by Martijn Hidding. *)
BeginPackage["FIFOServer`"];

ConfigureFIFOServer::usage = "Set configuration options for the FIFO server.";
WaitForInput::usage = "Waits for input from the FIFO file.";
WriteOutputLine::usage = "Write line to the output file."

Begin["`Private`"];

TailProcess = Null;
MyConfig = Association[{
	"RefreshTime" -> 1,
	"InputProcessor" -> (Null&)
}];

(* No sanity checking done here. *)
ConfigureFIFOServer[ConfOptions_] := (
		MyConfig = Merge[{MyConfig, ConfOptions}, Last];
		
		If[!(TailProcess === Null), KillProcess[TailProcess]];
		TailProcess = StartProcess[{"tail", "-f", MyConfig["InputFile"]}];
	);
	
WaitForInput[] := Module[{NewLine},
	While[True,
		Pause[MyConfig["RefreshTime"]];

		NewLine = ReadString[TailProcess, EndOfBuffer];
		
		If[NewLine === EndOfFile,
			Print["Warning: EndOfFile returned. Does the FIFO file exist?"];
			,
			If[!NewLine === "",
				MyConfig["InputProcessor"][NewLine // StringSplit[#, " "]& // DeleteCases[#, ""]& // Map[StringTrim]]
			];
		];
	];
];

End[];
EndPackage[];
