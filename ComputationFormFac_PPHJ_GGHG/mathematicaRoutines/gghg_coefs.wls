#!/usr/bin/env wolframscript
(* ::Package:: *)

fifoFilename = ToString[$ScriptCommandLine[[-1]]];
ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

PPHJSharedDirectory = FileNameJoin[{ScriptDirectory, "..", "..", "ComputationFormFac_PPHJ_Shared/"}];

AmplitudeType = "gghg";
Get[FileNameJoin[{PPHJSharedDirectory, "DirectBase.wls"}]];
