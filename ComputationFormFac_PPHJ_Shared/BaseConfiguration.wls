#!/usr/bin/env wolframscript
(* ::Package:: *)

(* --------------- General --------------- *)

(* Constants related to the renormalization scheme. *)
KyOSReplace = 0;
KmOSReplace = 0;

(* Fudge factors (ideally we'd like these to be 1.) *)
OneLoopFudgeFactor["gghg"] = 1/(2 Sqrt[2]);
TwoLoopFudgeFactor["gghg"] = 1/(2 Sqrt[2]);
OneLoopFudgeFactor["qqhg"] = 1/(Sqrt[2]);
TwoLoopFudgeFactor["qqhg"] = 1/(Sqrt[2]);

(* Number of digits to consider in the input*)
FloatInputSetPrecisionDigits = 9;

(* Consequent rationalization precision *)
FloatInputRationalizePrecision = 10^-16;

(* --------------- Specific to the exact mode. --------------- *)

(* Search in the ExactMode data directory for computed points, and add new points dynamically to the index. *)
DynamicIndexing = False;

(* Check if integrals have already been computed and processed. *)
ReuseProcessedIntegrals = True;

(* Reuse form factors. *)
ReuseFFs = True;

(* Number of digits at which the integrals are exported. *)
ExportPrecision = 100;

(* Radius within which boundary conditions are accepted. *)
BoundaryPointDelta = 10^-25;

(* Rationalizes the point given within the boundary conditions, before plugging it into the amplitude. *)
NumericsPlugInFFPrecision = 10^-50;

(* Default exact mode directory *)
DefaultExactModeDirectory = "ExactMode";

(* Values greater than 1 turn on a rudimentary parallelization feature for the matrix expansions. *)
ParallelMatrixExpansionCores = 1;

(* Default expansion order for the one- and two-loop integrals *)
ExpansionOrder1L = 80;
ExpansionOrder2L = 65;

(* Turn on/off exporting of the integrals *)
WriteIntegralsToCacheBoundaryData = True;
WriteIntegralsToCacheProcessed = True;

(* When this option is on, integrals are stored in memory within the script and not written to the physical cache.
	This overwrites WriteIntegralsToCacheBoundaryData, WriteIntegralsToCacheProcessed, and sets them to False.
  *)
KeepIntegralsInRAM = True;

(* Maximum number of points kept in RAM: *)
MaxPointsInRAM = 2;
