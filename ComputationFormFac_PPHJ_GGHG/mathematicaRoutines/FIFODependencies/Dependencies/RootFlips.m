(* ::Package:: *)

(* Created with the Wolfram Language : www.wolfram.com *)
(a$_)^(b$_) /; Denominator[b$] == 2 :> 
 a$^(b$ - 1/2)*(Sqrt[Expand[a$] /. mt -> 1 /. m -> 1 /. mm -> 1] /. 
   {Sqrt[-s] -> (-I)*Sqrt[s], Sqrt[-t] -> (-I)*Sqrt[t], 
    Sqrt[-pp4] -> (-I)*Sqrt[pp4], Sqrt[-pp4 + s + t] -> 
     (-I)*Sqrt[pp4 - s - t], Sqrt[4 - s] -> (-I)*Sqrt[-4 + s], 
    Sqrt[4 - pp4] -> (-I)*Sqrt[-4 + pp4], Sqrt[4 - pp4 + s] -> 
     (-I)*Sqrt[-4 + pp4 - s], Sqrt[-pp4 + s] -> (-I)*Sqrt[pp4 - s], 
    Sqrt[4 - pp4 + t] -> (-I)*Sqrt[-4 + pp4 - t], 
    Sqrt[-pp4 + t] -> (-I)*Sqrt[pp4 - t], Sqrt[4 - pp4 + s + t] -> 
     (-I)*Sqrt[-4 + pp4 - s - t], Sqrt[4 - t] -> (-I)*Sqrt[-4 + t], 
    Sqrt[4 - s - t] -> (-I)*Sqrt[-4 + s + t], Sqrt[-s - t] -> 
     (-I)*Sqrt[s + t], Sqrt[-pp4^2 - 16*s + 2*pp4*s - s^2] -> 
     (-I)*Sqrt[pp4^2 + 16*s - 2*pp4*s + s^2], 
    Sqrt[pp4^3 - pp4^2*s - pp4^2*t + 4*s*t] -> 
     (-I)*Sqrt[-pp4^3 + pp4^2*s + pp4^2*t - 4*s*t], 
    Sqrt[(-pp4)*s + s^2 - 4*t + s*t] -> (-I)*Sqrt[pp4*s - s^2 + 4*t - s*t], 
    Sqrt[-4*pp4 + 4*s + 4*t - s*t] -> (-I)*Sqrt[4*pp4 - 4*s - 4*t + s*t], 
    Sqrt[4*pp4*s - 4*s^2 + pp4^2*t - 4*s*t] -> 
     (-I)*Sqrt[-4*pp4*s + 4*s^2 - pp4^2*t + 4*s*t], 
    Sqrt[4*pp4*s - 4*s^2 + t - 2*s*t + s^2*t] -> 
     (-I)*Sqrt[-4*pp4*s + 4*s^2 - t + 2*s*t - s^2*t], 
    Sqrt[pp4 - s + 2*pp4*s - 2*s^2 + pp4*s^2 - s^3 - t + 2*s*t - s^2*t] -> 
     (-I)*Sqrt[-pp4 + s - 2*pp4*s + 2*s^2 - pp4*s^2 + s^3 + t - 2*s*t + 
        s^2*t], Sqrt[-4*s - pp4*t + s*t + t^2] -> 
     (-I)*Sqrt[4*s + pp4*t - s*t - t^2], 
    Sqrt[-pp4^2 - 16*t + 2*pp4*t - t^2] -> 
     (-I)*Sqrt[pp4^2 + 16*t - 2*pp4*t + t^2], 
    Sqrt[-16*pp4 + 16*s - s^2 + 16*t - 2*s*t - t^2] -> 
     (-I)*Sqrt[16*pp4 - 16*s + s^2 - 16*t + 2*s*t + t^2], 
    Sqrt[pp4^2*s + 4*pp4*t - 4*s*t - 4*t^2] -> 
     (-I)*Sqrt[(-pp4^2)*s - 4*pp4*t + 4*s*t + 4*t^2], 
    Sqrt[s + 4*pp4*t - 2*s*t - 4*t^2 + s*t^2] -> 
     (-I)*Sqrt[-s - 4*pp4*t + 2*s*t + 4*t^2 - s*t^2], 
    Sqrt[s + 2*pp4*s + pp4^2*s - 2*s^2 - 2*pp4*s^2 + s^3 + 4*pp4*t - 6*s*t - 
       2*pp4*s*t + 2*s^2*t - 4*t^2 + s*t^2] -> 
     (-I)*Sqrt[-s - 2*pp4*s - pp4^2*s + 2*s^2 + 2*pp4*s^2 - s^3 - 4*pp4*t + 
        6*s*t + 2*pp4*s*t - 2*s^2*t + 4*t^2 - s*t^2], 
    Sqrt[-pp4^2 + 2*pp4*s - s^2 - 2*pp4*s*t + 2*s^2*t + 4*s*t^2 - s^2*t^2] -> 
     (-I)*Sqrt[pp4^2 - 2*pp4*s + s^2 + 2*pp4*s*t - 2*s^2*t - 4*s*t^2 + 
        s^2*t^2], Sqrt[-pp4^2 + 2*pp4*s + 2*pp4^2*s - s^2 - 4*pp4*s^2 - 
       pp4^2*s^2 + 2*s^3 + 2*pp4*s^3 - s^4 - 6*pp4*s*t + 6*s^2*t + 
       2*pp4*s^2*t - 2*s^3*t + 4*s*t^2 - s^2*t^2] -> 
     (-I)*Sqrt[pp4^2 - 2*pp4*s - 2*pp4^2*s + s^2 + 4*pp4*s^2 + pp4^2*s^2 - 
        2*s^3 - 2*pp4*s^3 + s^4 + 6*pp4*s*t - 6*s^2*t - 2*pp4*s^2*t + 
        2*s^3*t - 4*s*t^2 + s^2*t^2], 
    Sqrt[-pp4^2 + 2*pp4*t - 2*pp4*s*t + 4*s^2*t - t^2 + 2*s*t^2 - s^2*t^2] -> 
     (-I)*Sqrt[pp4^2 - 2*pp4*t + 2*pp4*s*t - 4*s^2*t + t^2 - 2*s*t^2 + 
        s^2*t^2], Sqrt[-s^2 + 2*pp4*s^2 - pp4^2*s^2 - 2*s^3 + 2*pp4*s^3 - 
       s^4 - 2*s*t - 2*pp4*s*t + 2*pp4*s^2*t - 2*s^3*t - t^2 + 2*s*t^2 - 
       s^2*t^2] -> (-I)*Sqrt[s^2 - 2*pp4*s^2 + pp4^2*s^2 + 2*s^3 - 
        2*pp4*s^3 + s^4 + 2*s*t + 2*pp4*s*t - 2*pp4*s^2*t + 2*s^3*t + t^2 - 
        2*s*t^2 + s^2*t^2], Sqrt[4*pp4*s - 4*s^2 + t + 2*pp4*t + pp4^2*t - 
       6*s*t - 2*pp4*s*t + s^2*t - 2*t^2 - 2*pp4*t^2 + 2*s*t^2 + t^3] -> 
     (-I)*Sqrt[-4*pp4*s + 4*s^2 - t - 2*pp4*t - pp4^2*t + 6*s*t + 2*pp4*s*t - 
        s^2*t + 2*t^2 + 2*pp4*t^2 - 2*s*t^2 - t^3], 
    Sqrt[pp4 - s - t + 2*pp4*t + 2*s*t - 2*t^2 + pp4*t^2 - s*t^2 - t^3] -> 
     (-I)*Sqrt[-pp4 + s + t - 2*pp4*t - 2*s*t + 2*t^2 - pp4*t^2 + s*t^2 + 
        t^3], Sqrt[-pp4^2 + 2*pp4*t + 2*pp4^2*t - 6*pp4*s*t + 4*s^2*t - t^2 - 
       4*pp4*t^2 - pp4^2*t^2 + 6*s*t^2 + 2*pp4*s*t^2 - s^2*t^2 + 2*t^3 + 
       2*pp4*t^3 - 2*s*t^3 - t^4] -> 
     (-I)*Sqrt[pp4^2 - 2*pp4*t - 2*pp4^2*t + 6*pp4*s*t - 4*s^2*t + t^2 + 
        4*pp4*t^2 + pp4^2*t^2 - 6*s*t^2 - 2*pp4*s*t^2 + s^2*t^2 - 2*t^3 - 
        2*pp4*t^3 + 2*s*t^3 + t^4], 
    Sqrt[-s^2 - 2*s*t - 2*pp4*s*t + 2*s^2*t - t^2 + 2*pp4*t^2 - pp4^2*t^2 + 
       2*pp4*s*t^2 - s^2*t^2 - 2*t^3 + 2*pp4*t^3 - 2*s*t^3 - t^4] -> 
     (-I)*Sqrt[s^2 + 2*s*t + 2*pp4*s*t - 2*s^2*t + t^2 - 2*pp4*t^2 + 
        pp4^2*t^2 - 2*pp4*s*t^2 + s^2*t^2 + 2*t^3 - 2*pp4*t^3 + 2*s*t^3 + 
        t^4], Sqrt[4*mmb - s] -> (-I)*Sqrt[-4*mmb + s], 
    Sqrt[4*mmt - s] -> (-I)*Sqrt[-4*mmt + s], Sqrt[4*mmt - pp4] -> 
     (-I)*Sqrt[-4*mmt + pp4], Sqrt[4*mmb - t] -> (-I)*Sqrt[-4*mmb + t], 
    Sqrt[4*mmt - t] -> (-I)*Sqrt[-4*mmt + t], Sqrt[4*mmb - pp4 + s + t] -> 
     (-I)*Sqrt[-4*mmb + pp4 - s - t], Sqrt[4*mmt - pp4 + s + t] -> 
     (-I)*Sqrt[-4*mmt + pp4 - s - t], Sqrt[-4*s + s^2] -> 
     (-Sqrt[-4 + s])*Sqrt[s], Sqrt[1 - 4/pp4] -> Sqrt[-4 + pp4]/Sqrt[pp4], 
    Sqrt[-pp4 + s] -> (-I)*Sqrt[pp4 - s], Sqrt[4 - pp4 + s] -> 
     (-I)*Sqrt[-4 + pp4 - s], Sqrt[-4*s + s^2 + (4*pp4*s)/t - (4*s^2)/t] -> 
     (Sqrt[s]*Sqrt[4*pp4 - 4*s - 4*t + s*t])/Sqrt[t], 
    Sqrt[4*pp4*s*t - 4*s^2*t - 4*s*t^2 + s^2*t^2] -> 
     (-Sqrt[s])*Sqrt[t]*Sqrt[4*pp4 - 4*s - 4*t + s*t], 
    Sqrt[-4*t + t^2] -> (-Sqrt[-4 + t])*Sqrt[t], 
    Sqrt[-pp4 + t] -> (-I)*Sqrt[pp4 - t], Sqrt[4 - pp4 + t] -> 
     (-I)*Sqrt[-4 + pp4 - t], Sqrt[-4*t + (4*pp4*t)/s + t^2 - (4*t^2)/s] -> 
     (Sqrt[t]*Sqrt[4*pp4 - 4*s - 4*t + s*t])/Sqrt[s], 
    Sqrt[-4*pp4 + pp4^2 + 4*s - 2*pp4*s + s^2 + 4*t - 2*pp4*t + 2*s*t + 
       t^2] -> (-Sqrt[-4 + pp4 - s - t])*Sqrt[pp4 - s - t], 
    Sqrt[-s - t] -> (-I)*Sqrt[s + t], Sqrt[4 - s - t] -> 
     (-I)*Sqrt[-4 + s + t], Sqrt[pp4^2 - 4*s - 2*pp4*s + s^2 + (4*pp4*s)/t - 
       (4*s^2)/t - 2*pp4*t + 2*s*t + t^2] -> 
     (Sqrt[pp4 - s - t]*Sqrt[4*s + pp4*t - s*t - t^2])/Sqrt[t], 
    Sqrt[4*pp4*s*t - 4*s^2*t + pp4^2*t^2 - 4*s*t^2 - 2*pp4*s*t^2 + s^2*t^2 - 
       2*pp4*t^3 + 2*s*t^3 + t^4] -> (-Sqrt[pp4 - s - t])*Sqrt[t]*
      Sqrt[4*s + pp4*t - s*t - t^2], 
    Sqrt[-((pp4*s^2)/(-pp4 + s + t)) + s^3/(-pp4 + s + t) - 
       (4*s*t)/(-pp4 + s + t) + (s^2*t)/(-pp4 + s + t)] -> 
     -((Sqrt[s]*Sqrt[pp4 - s - t]*Sqrt[pp4*s - s^2 + 4*t - s*t])/
       (-pp4 + s + t)), Sqrt[pp4^2*s^2 - 2*pp4*s^3 + s^4 + 4*pp4*s*t - 
       4*s^2*t - 2*pp4*s^2*t + 2*s^3*t - 4*s*t^2 + s^2*t^2] -> 
     (-Sqrt[s])*Sqrt[pp4 - s - t]*Sqrt[pp4*s - s^2 + 4*t - s*t], 
    Sqrt[-((4*s*t)/(-pp4 + s + t)) - (pp4*t^2)/(-pp4 + s + t) + 
       (s*t^2)/(-pp4 + s + t) + t^3/(-pp4 + s + t)] -> 
     -((Sqrt[pp4 - s - t]*Sqrt[t]*Sqrt[4*s + pp4*t - s*t - t^2])/
       (-pp4 + s + t)), Sqrt[pp4^2 - 2*pp4*s + s^2 - 4*t - 2*pp4*t + 
       (4*pp4*t)/s + 2*s*t + t^2 - (4*t^2)/s] -> 
     (Sqrt[pp4 - s - t]*Sqrt[pp4*s - s^2 + 4*t - s*t])/Sqrt[s]})
