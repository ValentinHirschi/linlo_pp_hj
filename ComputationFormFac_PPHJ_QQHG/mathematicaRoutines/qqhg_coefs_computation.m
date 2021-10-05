(* ::Package:: *)

(*#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript*)
ComputeFormFactors[args_,InterpolationDataLinker_]:=Block[{FormFactors,},
Print[];
Print["TODO implement qqhg FF computation from the following arguments received: " <> ToString[args, InputForm]];
Print[];

(* TODO This will need further refinement when adding the possibility of both incyt and incyb together *)
FormFactors = {
	Complex[1.0, 2.0],
	Complex[3.0, 4.0]
};

FormFactors
]
