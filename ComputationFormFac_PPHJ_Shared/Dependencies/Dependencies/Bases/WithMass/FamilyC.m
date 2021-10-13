(* Created with the Wolfram Language : www.wolfram.com *)
{eps^2*mm^(2*eps)*G[0, 0, 0, 0, 2, 2, 0, 0, 0], 
 eps^2*mm^(2*eps)*t*G[0, 0, 0, 1, 0, 2, 2, 0, 0], 
 eps^2*mm^(2*eps)*t*G[0, 0, 0, 1, 2, 2, 0, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[4*mm - t]*Sqrt[-t]*G[0, 0, 0, 1, 2, 2, 0, 0, 0])/2 + 
  eps^2*mm^(2*eps)*Sqrt[4*mm - t]*Sqrt[-t]*G[0, 0, 0, 2, 1, 2, 0, 0, 0], 
 eps^2*mm^(2*eps)*pp4*G[0, 0, 2, 0, 2, 0, 1, 0, 0], 
 eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*G[0, 0, 1, 0, 2, 0, 2, 0, 0] + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*G[0, 0, 2, 0, 2, 0, 1, 0, 0])/
   2, eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*
  G[0, 0, 1, 0, 2, 2, 0, 0, 0], eps^2*mm^(2*eps)*pp4*
  G[0, 1, 0, 0, 0, 2, 2, 0, 0], eps^2*mm^(2*eps)*s*
  G[1, 0, 2, 0, 2, 0, 0, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*G[1, 0, 2, 0, 2, 0, 0, 0, 0])/2 + 
  eps^2*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*G[2, 0, 1, 0, 2, 0, 0, 0, 0], 
 eps^2*mm^(2*eps)*s*G[1, 2, 0, 0, 0, 2, 0, 0, 0], 
 eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*G[0, 0, 1, 1, 0, 2, 2, 0, 0], 
 eps^3*mm^(2*eps)*(pp4 - t)*G[0, 0, 1, 1, 2, 0, 1, 0, 0], 
 (eps^2*mm^(2*eps)*t*Sqrt[4*mm - pp4 + t]*G[0, -1, 1, 1, 2, 0, 2, 0, 0])/
   Sqrt[-pp4 + t] - (eps^2*mm^(2*eps)*pp4*Sqrt[4*mm - pp4 + t]*
    G[0, 0, 1, 0, 2, 0, 2, 0, 0])/Sqrt[-pp4 + t] + 
  (eps^3*mm^(2*eps)*(pp4 - t)*Sqrt[4*mm - pp4 + t]*
    G[0, 0, 1, 1, 2, 0, 1, 0, 0])/Sqrt[-pp4 + t], 
 eps^3*mm^(2*eps)*(pp4 - t)*G[0, 0, 1, 1, 2, 1, 0, 0, 0], 
 eps^2*mm^(1 + 2*eps)*(pp4 - t)*G[0, 0, 1, 1, 3, 1, 0, 0, 0], 
 (-3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*
    G[0, 0, 0, 1, 2, 2, 0, 0, 0])/(4*(pp4 - 2*t)) - 
  (3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    G[0, 0, 1, 1, 2, 1, 0, 0, 0])/(2*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(mm*pp4 - pp4*t + t^2)*
    G[0, 0, 1, 1, 2, 2, 0, 0, 0])/(pp4 - 2*t) + 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    G[0, 0, 1, 1, 3, 1, 0, 0, 0])/(pp4 - 2*t), 
 eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*pp4*
  G[0, 1, 1, 0, 0, 2, 2, 0, 0], eps^3*mm^(2*eps)*(pp4 - s)*
  G[1, 0, 1, 0, 2, 1, 0, 0, 0], eps^2*mm^(1 + 2*eps)*(pp4 - s)*
  G[1, 0, 1, 0, 3, 1, 0, 0, 0], 
 (-3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*
    G[1, 0, 1, 0, 2, 1, 0, 0, 0])/(2*(pp4 - 2*s)) + 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*
    G[1, 0, 1, 0, 3, 1, 0, 0, 0])/(pp4 - 2*s) - 
  (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*
    G[1, 0, 2, 0, 2, 0, 0, 0, 0])/(4*(pp4 - 2*s)) + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(mm*pp4 - pp4*s + s^2)*
    G[1, 0, 2, 0, 2, 1, 0, 0, 0])/(pp4 - 2*s), 
 eps^3*mm^(2*eps)*(pp4 - s)*G[1, 1, 0, 0, 2, 1, 0, 0, 0], 
 -((eps^2*mm^(2*eps)*pp4*Sqrt[4*mm - pp4 + s]*G[0, 2, 0, 0, 2, 1, 0, 0, 0])/
    Sqrt[-pp4 + s]) + (eps^3*mm^(2*eps)*(pp4 - s)*Sqrt[4*mm - pp4 + s]*
    G[1, 1, 0, 0, 2, 1, 0, 0, 0])/Sqrt[-pp4 + s] + 
  (eps^2*mm^(2*eps)*s*Sqrt[4*mm - pp4 + s]*G[1, 2, 0, 0, 2, 1, -1, 0, 0])/
   Sqrt[-pp4 + s], eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*
  G[1, 2, 1, 0, 0, 2, 0, 0, 0], eps^4*mm^(2*eps)*(pp4 - t)*
  G[0, 0, 1, 1, 1, 1, 1, 0, 0], 
 -((eps^2*mm^(2*eps)*(-4*mm + pp4 - t)*t*G[0, -1, 1, 1, 2, 0, 2, 0, 0])/
    (pp4 - t)) + (3*eps^2*mm^(2*eps)*(-4*mm + pp4)*t*
    G[0, 0, 0, 1, 2, 2, 0, 0, 0])/(4*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*(-4*mm*pp4 + pp4^2 - 4*mm*t - pp4*t)*
    G[0, 0, 1, 0, 2, 0, 2, 0, 0])/(2*(pp4 - t)) + 
  (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 0, 1, 0, 2, 2, 0, 0, 0])/2 - 
  eps^2*mm^(2*eps)*(-4*mm + pp4)*t*G[0, 0, 1, 1, 0, 2, 2, 0, 0] - 
  2*eps^4*mm^(2*eps)*pp4*G[0, 0, 1, 1, 1, 1, 1, 0, 0] - 
  eps^3*mm^(2*eps)*(-4*mm + 3*pp4 - t)*G[0, 0, 1, 1, 2, 0, 1, 0, 0] + 
  (eps^3*mm^(2*eps)*(-12*mm*pp4 + 5*pp4^2 + 12*mm*t - 7*pp4*t)*
    G[0, 0, 1, 1, 2, 1, 0, 0, 0])/(2*(pp4 - 2*t)) + 
  eps^2*mm^(1 + 2*eps)*t*G[0, 0, 1, 1, 2, 1, 1, 0, 0] + 
  (eps^2*mm^(2*eps)*(-4*mm + pp4)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 0, 1, 1, 2, 2, 0, 0, 0])/(pp4 - 2*t) - 
  (eps^2*mm^(1 + 2*eps)*(-4*mm + pp4)*(pp4 - t)*G[0, 0, 1, 1, 3, 1, 0, 0, 0])/
   (pp4 - 2*t) - (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 0, 2, 0, 2, 0, 1, 0, 
     0])/4 - (eps^3*mm^(2*eps)*(-4*mm + pp4)*(pp4 + t)*
    G[0, 0, 2, 1, 1, 1, 1, 0, 0])/2, eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
  Sqrt[-pp4]*(pp4 - t)*G[0, 0, 2, 1, 1, 1, 1, 0, 0], 
 -(eps^3*(-1 + 2*eps)*mm^(2*eps)*pp4*G[0, 1, 1, 0, 1, 1, 1, 0, 0]), 
 eps^3*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*t*G[1, 0, 1, 1, 2, 0, 1, 0, 0], 
 eps^3*mm^(2*eps)*t*G[1, -1, 1, 1, 2, 0, 1, 0, 0] + 
  eps^3*mm^(2*eps)*s*t*G[1, 0, 1, 1, 2, 0, 1, 0, 0], 
 eps^4*mm^(2*eps)*(s + t)*G[1, 0, 1, 1, 1, 1, 0, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[-s]*Sqrt[-t]*Sqrt[4*mm*pp4 - 4*mm*s - 4*mm*t + s*t]*
  G[1, 0, 1, 1, 2, 1, 0, 0, 0], 
 (eps^2*mm^(2*eps)*(-2*mm*s - 2*mm*t + pp4*t)*(-4*mm*pp4 + 4*pp4*t - t^2)*
    G[0, 0, 0, 1, 2, 2, 0, 0, 0])/(4*pp4*(2*mm*pp4 + 2*mm*t - 2*pp4*t + 
     t^2)) - (eps^3*mm^(2*eps)*(-2*mm*s - 2*mm*t + pp4*t)*
    (-2*mm*pp4^2 - 2*mm*pp4*t + 2*pp4^2*t - 3*pp4*t^2 + t^3)*
    G[0, 0, 1, 1, 2, 1, 0, 0, 0])/(2*pp4*t*(2*mm*pp4 + 2*mm*t - 2*pp4*t + 
     t^2)) - (eps^2*mm^(1 + 2*eps)*(pp4 - t)*t*(-2*mm*s - 2*mm*t + pp4*t)*
    G[0, 0, 1, 1, 3, 1, 0, 0, 0])/(pp4*(2*mm*pp4 + 2*mm*t - 2*pp4*t + t^2)) + 
  (eps^2*mm^(2*eps)*(-2*mm*s - 2*mm*t + pp4*t)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 0, 2, 1, 2, 1, 0, 0, -1])/(t*(2*mm*pp4 + 2*mm*t - 2*pp4*t + t^2)) - 
  (3*eps^3*mm^(2*eps)*(pp4 - s)*(-2*mm*s - 2*mm*t + pp4*t)*
    G[1, 0, 1, 0, 2, 1, 0, 0, 0])/(2*(pp4 - 2*s)*t) + 
  (eps^2*mm^(1 + 2*eps)*(pp4 - s)*(-2*mm*s - 2*mm*t + pp4*t)*
    G[1, 0, 1, 0, 3, 1, 0, 0, 0])/((pp4 - 2*s)*t) - 
  (eps^3*mm^(2*eps)*(-2*mm*s - 2*mm*t + s*t)*G[1, 0, 1, 1, 2, 1, 0, 0, 0])/
   2 - (3*eps^2*mm^(2*eps)*s*(-2*mm*s - 2*mm*t + pp4*t)*
    G[1, 0, 2, 0, 2, 0, 0, 0, 0])/(4*(pp4 - 2*s)*t) - 
  (eps^2*mm^(2*eps)*(-(mm*pp4) + pp4*s - s^2)*(-2*mm*s - 2*mm*t + pp4*t)*
    G[1, 0, 2, 0, 2, 1, 0, 0, 0])/((pp4 - 2*s)*t) - 
  (eps^3*mm^(2*eps)*(-(mm*s^2) - 2*mm*s*t + pp4*s*t - mm*t^2)*
    G[1, 0, 2, 1, 1, 1, 0, 0, 0])/t, eps^3*mm^(2*eps)*s*t*
  G[1, 1, 0, 1, 0, 2, 1, 0, 0], eps^3*mm^(2*eps)*s*Sqrt[4*mm - t]*Sqrt[-t]*
  G[1, 1, 0, 1, 2, 1, 0, 0, 0], 
 eps^3*mm^(2*eps)*s*G[1, 1, 0, 1, 2, 1, -1, 0, 0] + 
  eps^3*mm^(2*eps)*s*t*G[1, 1, 0, 1, 2, 1, 0, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - s)*G[1, 1, 1, 0, 1, 1, 0, 0, 0], 
 (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 0, 2, 0, 2, 1, 0, 0, 0])/2 - 
  (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 1, 0, 0, 2, 2, 0, 0, 0])/4 + 
  (eps^2*mm^(2*eps)*(-4*mm*pp4 + pp4^2 - 4*mm*s - pp4*s)*
    G[0, 2, 0, 0, 2, 1, 0, 0, 0])/(2*(pp4 - s)) + 
  (eps^3*mm^(2*eps)*(-12*mm*pp4 + 5*pp4^2 + 12*mm*s - 7*pp4*s)*
    G[1, 0, 1, 0, 2, 1, 0, 0, 0])/(2*(pp4 - 2*s)) - 
  (eps^2*mm^(1 + 2*eps)*(-4*mm + pp4)*(pp4 - s)*G[1, 0, 1, 0, 3, 1, 0, 0, 0])/
   (pp4 - 2*s) + (3*eps^2*mm^(2*eps)*(-4*mm + pp4)*s*
    G[1, 0, 2, 0, 2, 0, 0, 0, 0])/(4*(pp4 - 2*s)) + 
  (eps^2*mm^(2*eps)*(-4*mm + pp4)*(-(mm*pp4) + pp4*s - s^2)*
    G[1, 0, 2, 0, 2, 1, 0, 0, 0])/(pp4 - 2*s) - 
  eps^3*mm^(2*eps)*(-4*mm + 3*pp4 - s)*G[1, 1, 0, 0, 2, 1, 0, 0, 0] - 
  2*eps^4*mm^(2*eps)*pp4*G[1, 1, 1, 0, 1, 1, 0, 0, 0] - 
  (eps^3*mm^(2*eps)*(-4*mm + pp4)*(pp4 + s)*G[1, 1, 1, 0, 1, 2, 0, 0, 0])/2 + 
  eps^2*mm^(1 + 2*eps)*s*G[1, 1, 1, 0, 2, 1, 0, 0, 0] - 
  (eps^2*mm^(2*eps)*(-4*mm + pp4 - s)*s*G[1, 2, 0, 0, 2, 1, -1, 0, 0])/
   (pp4 - s) - eps^2*mm^(2*eps)*(-4*mm + pp4)*s*G[1, 2, 2, 0, 0, 1, 0, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*
  G[1, 1, 1, 0, 1, 2, 0, 0, 0], eps^4*mm^(2*eps)*(pp4 - s)*t*
  G[1, 0, 1, 1, 1, 1, 1, 0, 0], 2*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*t*G[1, 0, 1, 1, 2, 0, 1, 0, 0] - 
  eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*G[1, 0, 1, 1, 2, 1, 0, 0, 
    0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*t*
   G[1, 0, 2, 1, 1, 1, 1, 0, 0], eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*
  s*t*G[1, 1, 1, 1, 0, 2, 1, 0, 0], eps^4*mm^(2*eps)*s*(pp4 - t)*
  G[1, 1, 1, 1, 1, 1, 0, 0, 0], 
 -(eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*G[1, 0, 1, 1, 2, 1, 0, 0, 
     0]) + 2*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*
   G[1, 1, 0, 1, 2, 1, 0, 0, 0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*s*(pp4 - t)*G[1, 1, 1, 1, 1, 2, 0, 0, 0], 
 eps^4*mm^(2*eps)*pp4*t*G[1, 0, 1, 1, 1, 1, 1, 0, 0] + 
  eps^4*mm^(2*eps)*pp4*s*G[1, 1, 1, 1, 1, 1, 0, 0, 0] + 
  eps^4*mm^(2*eps)*pp4*s*t*G[1, 1, 1, 1, 1, 1, 1, 0, 0]}
