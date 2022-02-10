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

(* Number of fifo listeners per instance. *)
FIFOListeners = 4;

(* --------------- Internal precision handling. --------------- *)

(* Processing of command line parameters: *)
	
	(* Apply SetPrecision to command line argument *)
	FloatInputSetPrecisionDigits = 17;
	
	(* Subsequently rationalize to specified precision: *)
	FloatInputRationalizeDigits = 17;

(* Whether to enable the permutation hack. This does the following:

	KeepIntegralsInRAM is overwritten to True.
	MaxPointsInRAM in overwritten to 1.
	The precision at which "Processed/" points are stored in RAM is lowered to PermutationHackRationalizeDigits.
	
	This way, if the same point is called in a configuration where t and u are permuted,
		the scan over already processed data (stored in terms of 6 permutations) is done at low precision. 
		The low precision scan is necessary because MG feeds arguments at single float precision.
	
	This hack would not be needed if the MG wrapper would add an additional argument flagging the point that is being computed, 
		would call the appropriate channel in the unpermuted configuration, or would add u to the argument list,
		but since this is not possible, we employ this hack. *)
		
EnablePermutationHack = True;
PermutationHackRationalizeDigits = 6;

(* Precision of points for the scheduler. This does not affect the results,
	but points are considered to be the same for scheduling purposes to the parallel kernels. *)
SchedulerRationalizeDigits = 6;	

(* --------------- Specific to the exact mode. --------------- *)

(* Search in the ExactMode data directory for computed points, and add new points dynamically to the index. *)
DynamicIndexing = True;

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
ExpansionOrder1L = 100;
ExpansionOrder2L = 75;

(* Turn on/off exporting of the integrals *)
WriteIntegralsToCacheBoundaryData = True;
WriteIntegralsToCacheProcessed = True;

(* When this option is on, integrals are stored in memory within the script and not written to the physical cache.
	This overwrites WriteIntegralsToCacheBoundaryData, WriteIntegralsToCacheProcessed, and sets them to False.
  *)
KeepIntegralsInRAM = False;

(* Maximum number of points kept in RAM: *)
MaxPointsInRAM = 2;
