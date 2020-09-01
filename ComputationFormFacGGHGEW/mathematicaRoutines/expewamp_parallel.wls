#!/usr/bin/env /opt/mathematica-12.0/Executables/wolframscript

(*#!/usr/bin/env /Applications/Mathematica.app/Contents/MacOS/wolframscript*)


Get["ExpCan4_Reg.wl"];



$Verbose=False;

basedir=Directory[];


nvar=4;
nindvar=3;



print["loading ps list"];
pointlist=Get["ps_list_W.txt"];

numpoint=ToExpression[$ScriptCommandLine[[2]]];
precinput=16;


print["ps point ",$ScriptCommandLine[[2]]];


p1in=pointlist[[numpoint]];


print["loading ps list, done."];


ratHW=13074/5399;
ratHZ=14631/7775;



print[pointlist[[numpoint]]];
print[p1in];


ratMli={ratHW,ratHZ};
posdiffWZ=Position[p1in[[$PosMass]]-ratMli//Abs,a_/;a<10^-4]//Flatten;
If[Length[posdiffWZ]=!=1||Length,Print["no mass ratio"];PutAppend[{" no mass ratio ",p1in},"err_log.txt"];Quit[]];

If[posdiffWZ==={1},$Mass="W";Print[Boson->$Mass]];
If[posdiffWZ==={2},$Mass="Z";Print[Boson->$Mass]];

p1in[[$PosMass]]=ratMli[[posdiffWZ//First]];
pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];





pin=Table[vv[ii]->p1in[[ii]],{ii,nindvar}];



gram3 = -2 vv[1]^2 vv[2] - 2 vv[1] vv[2]^2 + 2 vv[1] vv[2] vv[3]/.pin;
print["gram ", gram3];
If[gram3<0,PrintAndSaveErrorAbort["non-phys point ",pin]];

print["ps point ", pin, pin//N]


p1li={{vv[1],-vv[1]-vv[2]+vv[3],vv[3]},{vv[1],vv[2],vv[3]},{-vv[1]-vv[2]+vv[3],vv[2],vv[3]},{vv[2],vv[1],vv[3]}}/.pin;


print[p1li];


FileTagP="Planar_EW1";
FileTagNP="NP_EW1";


timeamp=(

Table[

FileTag=famName;
Print[" *** ",famName, " *** "];
Get["expewmi.m"];

,{famName,{"Planar_EW1","NP_EW1"}}];



SetDirectory[basedir];


print["loading FF ",Date[]];

Get["FFlist.mx"];

print["loading FF : Done ",Date[]];

Do[INTP[p1li[[ii]]]=Transpose[Get["./"<>FileTagP<>"/BClist/BClist_"<>FileTagP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];
Do[INTNP[p1li[[ii]]]=Transpose[Get["./"<>FileTagNP<>"/BClist/BClist_"<>FileTagNP<>"_p"<>ToString[Hash[p1li[[ii]]]]<>".txt"][[2]]],{ii,Length@p1li}];




print["n ff"];

pinN=#[[1]]->N[#[[2]],acc]&/@pin;

(*print[pinN];*)

fflistn=fflist/.{canMINP[a_,b_,c_]:>INTNP[c/.pin][[a,b+1]],canMIPlanar[a_,b_,c_]:>INTP[c/.pin][[a,b+1]]}/.pinN//Rationalize[#,10^(-32)]&;


print["n ff done"];



print["Points evaluated ",p1li//N];

Print["START_OUTPUT_STREAM"];

Do[
Print[Re[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Do[ 
Print[Im[fflistn[[ii]]]//CForm//ToString]
,{ii,Length@fflistn}];

Print["END_OUTPUT_STREAM"];



)//AbsoluteTiming//First;

PutAppend[timeamp,"time.txt"]
