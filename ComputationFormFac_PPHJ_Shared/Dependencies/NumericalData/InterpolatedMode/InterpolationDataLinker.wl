(* ::Package:: *)

(* ::Input::Initialization:: *)
LinkerChopPrec=10^-10;

EchoLabelAlt[lab_] :=(Print[lab,": ",#]; #)&;

SharedConditions = And[
Chop[#["mh"]-125.,LinkerChopPrec]===0 //EchoLabelAlt["mh"],
	Chop[#["mb"]-0.,LinkerChopPrec]===0 //EchoLabelAlt["mb"],
	Chop[#["mt"]-N[ 125*Sqrt[23/12]],LinkerChopPrec]===0 //EchoLabelAlt["mt"],
	#["nf"]==5 //EchoLabelAlt["nf"],
	!#["is_HEFT"] //EchoLabelAlt["heft"],
	#["inc_ytqcd" ]==#["inc_ytmt" ] //EchoLabelAlt["inc_yt"],
	#["inc_ytmb" ]==#["inc_ybmb" ]==#["inc_ybqcd" ]==#["inc_ybmt" ]==False//EchoLabelAlt["inc_yb"],
MatchQ[#["nloop"],1|2|"2/1"] //EchoLabelAlt["nloop"]
]&;

(*SharedConditions2 = And[
Chop[#["mh"]-125.,LinkerChopPrec]===0 //EchoLabelAlt["mh"],
	Chop[#["mb"]-4.2,LinkerChopPrec]===0 //EchoLabelAlt["mb"],
	Chop[#["mt"]-N[ 125*Sqrt[23/12]],LinkerChopPrec]===0 //EchoLabelAlt["mt"],
	#["nf"]==4 //EchoLabelAlt["nf"],
	!#["is_HEFT"] //EchoLabelAlt["heft"],
	#["inc_ytqcd" ]==#["inc_ytmt" ] //EchoLabelAlt["inc_yt"],
	#["inc_ytmb" ]==#["inc_ybmb" ]==#["inc_ybqcd" ]==#["inc_ybmt" ]==False//EchoLabelAlt["inc_yb"],
MatchQ[#["nloop"],1|2|"2/1"] //EchoLabelAlt["nloop"]
]&;
*)
{
	(* Conditionals *)
	(       And[
			SharedConditions[#],
			AmplitudeType=="gghg"//EchoLabelAlt["amptype"]
		]&)->{
	(* Replacement for n,m in the interpolation functions *)
		{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
	(* Data for the interpolations *)
		"gghg-top.mx"
    }(*,

	(       And[
			SharedConditions2[#],
			AmplitudeType=="gghg"//EchoLabelAlt["amptype"]
		]&)->{
	(* Replacement for n,m in the interpolation functions *)
		{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
	(* Data for the interpolations *)
		"gghg-topbottom.mx"
    }*),

	(       And[
			SharedConditions[#],
			AmplitudeType=="qqhg"//EchoLabelAlt["amptype"],
	   #["selected_channel"] == 1
		]&)->{
	(* Replacement for n,m in the interpolation functions *)
		{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
	(* Data for the interpolations *)
		"qqhg1-top.mx"
    },

(       And[
			SharedConditions[#],
			AmplitudeType=="qqhg"//EchoLabelAlt["amptype"],
	   #["selected_channel"] == 2
		]&)->{
	(* Replacement for n,m in the interpolation functions *)
		{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
	(* Data for the interpolations *)
		"qqhg2-top.mx"
    },

(       And[
			SharedConditions[#],
			AmplitudeType=="qqhg"//EchoLabelAlt["amptype"],
	   #["selected_channel"] == 3
		]&)->{
	(* Replacement for n,m in the interpolation functions *)
		{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
	(* Data for the interpolations *)
		"qqhg3-top.mx"
    }
}//Association
