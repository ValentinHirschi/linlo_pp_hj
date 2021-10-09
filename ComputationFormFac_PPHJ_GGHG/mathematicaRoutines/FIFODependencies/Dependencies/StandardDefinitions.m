(* ::Package:: *)

If[!ValueQ[BaseDirectory], BaseDirectory = "/home/martijn/Dropbox/Projects/HiggsPlusJet/HiggsJetSuperFinal"];

(* Old x1, x2, x3 notation *)
x123Rules = {x1 -> s / mm, x2 -> pp4 / mm, x3 -> t / mm};

(* All delta prescriptions needed for DiffExp *)
DeltaPrescriptions2L1L = {
{s,1},
{t,1},
{pp4,1},
{pp4-s-t,1},
{-4+s,1},
{-4+pp4,1},
{-4+pp4-s,1},
{pp4-s,1},
{-4+pp4-t,1},
{pp4-t,1},
{-4+pp4-s-t,1},
{-4+t,1},
{-4+s+t,1},
{s+t,1},
{pp4^2+16 s-2 pp4 s+s^2,1},
{-pp4^3+pp4^2 s+pp4^2 t-4 s t,1},
{pp4 s-s^2+4 t-s t,1},
{4 pp4-4 s-4 t+s t,1},
{-4 pp4 s+4 s^2-pp4^2 t+4 s t,1},
{-4 pp4 s+4 s^2-t+2 s t-s^2 t,1},
{-pp4+s-2 pp4 s+2 s^2-pp4 s^2+s^3+t-2 s t+s^2 t,1},
{4 s+pp4 t-s t-t^2,1},
{pp4^2+16 t-2 pp4 t+t^2,1},
{16 pp4-16 s+s^2-16 t+2 s t+t^2,1},
{-pp4^2 s-4 pp4 t+4 s t+4 t^2,1},
{-s-4 pp4 t+2 s t+4 t^2-s t^2,1},
{-s-2 pp4 s-pp4^2 s+2 s^2+2 pp4 s^2-s^3-4 pp4 t+6 s t+2 pp4 s t-2 s^2 t+4 t^2-s t^2,1},
{pp4^2-2 pp4 s+s^2+2 pp4 s t-2 s^2 t-4 s t^2+s^2 t^2,1},
{pp4^2-2 pp4 s-2 pp4^2 s+s^2+4 pp4 s^2+pp4^2 s^2-2 s^3-2 pp4 s^3+s^4+6 pp4 s t-6 s^2 t-2 pp4 s^2 t+2 s^3 t-4 s t^2+s^2 t^2,1},
{pp4^2-2 pp4 t+2 pp4 s t-4 s^2 t+t^2-2 s t^2+s^2 t^2,1},
{s^2-2 pp4 s^2+pp4^2 s^2+2 s^3-2 pp4 s^3+s^4+2 s t+2 pp4 s t-2 pp4 s^2 t+2 s^3 t+t^2-2 s t^2+s^2 t^2,1},
{-4 pp4 s+4 s^2-t-2 pp4 t-pp4^2 t+6 s t+2 pp4 s t-s^2 t+2 t^2+2 pp4 t^2-2 s t^2-t^3,1},
{-pp4+s+t-2 pp4 t-2 s t+2 t^2-pp4 t^2+s t^2+t^3,1},
{pp4^2-2 pp4 t-2 pp4^2 t+6 pp4 s t-4 s^2 t+t^2+4 pp4 t^2+pp4^2 t^2-6 s t^2-2 pp4 s t^2+s^2 t^2-2 t^3-2 pp4 t^3+2 s t^3+t^4,1},
{s^2+2 s t+2 pp4 s t-2 s^2 t+t^2-2 pp4 t^2+pp4^2 t^2-2 pp4 s t^2+s^2 t^2+2 t^3-2 pp4 t^3+2 s t^3+t^4,1}
};

DeltaPrescriptionsH = {
{s,1},
{t,1},
{pp4,1},
{pp4-s-t,1},
{-4 mmt+pp4,1},
{-4 mmb+s,1},
{-4 mmt+s,1},
{-4 mmb+t,1},
{-4 mmt+t,1},
{-4 mmb+pp4-s-t,1},
{-4 mmt+pp4-s-t,1}
};

(* RootFlips consistent with the above Idelta-prescriptions *)
RootFlips = Import[FileNameJoin[{BaseDirectory, "Dependencies","RootFlips.m"}]];

(* Swaps *)
SwapRelations = {
(* Labeling of swaps *)
<|1->{s->s,t->t},2->{s->t,t->s},3->{s->pp4-s-t,t->t},4->{s->s,t->pp4-s-t},5->{s->t,t->pp4-s-t},6->{s->pp4-s-t,t->s}|>,
(* Hjalte swap conversion to Giulio swaps *)
<|{s,t}->{1},{t,s}->{2},{u,t}->{3},{s,u}->{4},{t,u}->{5},{u,s}->{6}|>,
(* Reversed *)
{1->{s,t},2->{t,s},3->{u,t},4->{s,u},5->{t,u},6->{u,s}}
};
