#!/usr/bin/env wolframscript
(* ::Package:: *)

fifoFilename = ToString[$ScriptCommandLine[[2]]];
ScriptPath = ExpandFileName[First[$ScriptCommandLine]];
ScriptName = Last[FileNameSplit[ScriptPath]];
ScriptDirectory = FileNameJoin @ FileNameSplit[ScriptPath][[1 ;; -2]];

PPHJSharedDirectory = FileNameJoin[{ScriptDirectory, "..", "..", "ComputationFormFac_PPHJ_Shared/"}];

Get[FileNameJoin[{PPHJSharedDirectory, "FIFOBase.wls"}]];
