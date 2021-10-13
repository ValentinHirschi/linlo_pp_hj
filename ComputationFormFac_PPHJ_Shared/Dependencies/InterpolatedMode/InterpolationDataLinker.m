(* ::Package:: *)

(* ::Input::Initialization:: *)
{
   Association[ {(* s,t, pp4, mb^2, mt^2, nloop, nf, is_HEFT, inc_ytqcd, inc_ytmb, inc_ytmt, inc_ybqcd, inc_ybmb, inc_ybmt *)
		"mh" -> 125,
		"mb" -> 0,
		"mt" -> 125*Sqrt[23/12],
		"nloop" ->1|2,
		"nf" ->5,
		"is_HEFT" -> False,
		"inc_ytqcd" ->True,
		"inc_ytmb" ->False,
		"inc_ytmt" ->True,
		"inc_ybqcd" -> False,
		"inc_ybmb" ->False,
		"inc_ybmt" ->  False,
		"amplitude" -> "gghg",
(* Conditions on s and t (such that n, m > 0) *)
	"stRange" -> s>15876&&t>1/200 (3109375-199 s)
}]->{
(* Replacement for n,m in the interpolation functions *)
	{n->-42+Sqrt[s]/3,m->(-349643-1053108 n-12537 n^2-1400 t)/(-16566-49896 n-594 n^2)},
(* Data for the interpolations *)
	"AmplitudeInterpolationGGHG.mx"
    }
}//Association
