(* Created with the Wolfram Language : www.wolfram.com *)
{eps^2*mm^(2*eps)*G[0, 0, 0, 0, 2, 0, 2, 0, 0], 
 eps^2*mm^(2*eps)*t*G[0, 2, 0, 1, 0, 0, 2, 0, 0], 
 eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*G[0, 0, 2, 0, 1, 0, 2, 0, 0], 
 eps^2*mm^(2*eps)*s*G[1, 0, 2, 0, 0, 2, 0, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*G[1, 0, 2, 0, 0, 2, 0, 0, 0])/2 + 
  eps^2*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*G[2, 0, 2, 0, 0, 1, 0, 0, 0], 
 eps^2*mm^(2*eps)*t*G[0, 0, 2, 1, 0, 0, 2, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[4*mm - t]*Sqrt[-t]*G[0, 0, 2, 1, 0, 0, 2, 0, 0])/2 + 
  eps^2*mm^(2*eps)*Sqrt[4*mm - t]*Sqrt[-t]*G[0, 0, 2, 2, 0, 0, 1, 0, 0], 
 eps^2*mm^(2*eps)*(pp4 - s - t)*G[1, 0, 0, 0, 2, 0, 2, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[-pp4 + s + t]*Sqrt[4*mm - pp4 + s + t]*
    G[1, 0, 0, 0, 2, 0, 2, 0, 0])/2 + eps^2*mm^(2*eps)*Sqrt[-pp4 + s + t]*
   Sqrt[4*mm - pp4 + s + t]*G[2, 0, 0, 0, 1, 0, 2, 0, 0], 
 eps^2*mm^(2*eps)*pp4*G[0, 0, 2, 1, 0, 2, 0, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*G[0, 0, 2, 1, 0, 2, 0, 0, 0])/
   2 + eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*
   G[0, 0, 2, 2, 0, 1, 0, 0, 0], eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*
  t*G[0, 1, 1, 2, 2, 0, 0, 0, 0], eps^3*mm^(2*eps)*s*
  G[1, 0, 2, 0, 0, 1, 1, 0, 0], eps^3*mm^(2*eps)*(pp4 - s - t)*
  G[1, 0, 0, 0, 2, 1, 1, 0, 0], eps^3*mm^(2*eps)*(pp4 - t)*
  G[0, 1, 0, 1, 2, 0, 1, 0, 0], 
 (eps^2*mm^(2*eps)*Sqrt[-pp4 + t]*Sqrt[4*mm - pp4 + t]*
    G[0, 0, 2, 1, 0, 2, 0, 0, 0])/2 + eps^2*mm^(2*eps)*Sqrt[-pp4 + t]*
   Sqrt[4*mm - pp4 + t]*G[0, 0, 2, 2, 0, 1, 0, 0, 0] + 
  eps^2*mm^(2*eps)*t*Sqrt[-pp4 + t]*Sqrt[4*mm - pp4 + t]*
   G[0, 2, 0, 1, 2, 0, 1, 0, 0], eps^3*mm^(2*eps)*(pp4 - t)*
  G[0, 0, 2, 1, 0, 1, 1, 0, 0], eps^3*mm^(2*eps)*(pp4 - s)*
  G[1, 0, 1, 0, 1, 2, 0, 0, 0], eps^2*mm^(1 + 2*eps)*(pp4 - s)*
  G[1, 0, 1, 0, 1, 3, 0, 0, 0], 
 (-3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*
    G[1, 0, 1, 0, 1, 2, 0, 0, 0])/(2*(pp4 - 2*s)) + 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s)*
    G[1, 0, 1, 0, 1, 3, 0, 0, 0])/(pp4 - 2*s) - 
  (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*
    G[1, 0, 2, 0, 0, 2, 0, 0, 0])/(4*(pp4 - 2*s)) + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(mm*pp4 - pp4*s + s^2)*
    G[1, 0, 2, 0, 1, 2, 0, 0, 0])/(pp4 - 2*s), 
 eps^3*mm^(2*eps)*(pp4 - t)*G[0, 0, 1, 1, 1, 0, 2, 0, 0], 
 eps^2*mm^(1 + 2*eps)*(pp4 - t)*G[0, 0, 1, 1, 1, 0, 3, 0, 0], 
 (-3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    G[0, 0, 1, 1, 1, 0, 2, 0, 0])/(2*(pp4 - 2*t)) + 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    G[0, 0, 1, 1, 1, 0, 3, 0, 0])/(pp4 - 2*t) - 
  (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*
    G[0, 0, 2, 1, 0, 0, 2, 0, 0])/(4*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(mm*pp4 - pp4*t + t^2)*
    G[0, 0, 2, 1, 1, 0, 2, 0, 0])/(pp4 - 2*t), 
 eps^3*mm^(2*eps)*(s + t)*G[1, 0, 1, 0, 1, 0, 2, 0, 0], 
 eps^2*mm^(1 + 2*eps)*(s + t)*G[1, 0, 1, 0, 1, 0, 3, 0, 0], 
 (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s - t)*
    G[1, 0, 0, 0, 2, 0, 2, 0, 0])/(4*(pp4 - 2*s - 2*t)) + 
  (3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(s + t)*
    G[1, 0, 1, 0, 1, 0, 2, 0, 0])/(2*(pp4 - 2*s - 2*t)) - 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(s + t)*
    G[1, 0, 1, 0, 1, 0, 3, 0, 0])/(pp4 - 2*s - 2*t) - 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(mm*pp4 - pp4*s + s^2 - 
     pp4*t + 2*s*t + t^2)*G[1, 0, 1, 0, 2, 0, 2, 0, 0])/(pp4 - 2*s - 2*t), 
 eps^4*mm^(2*eps)*(pp4 - t)*G[0, 1, 0, 1, 1, 1, 1, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - t)*G[0, 1, 1, 1, 1, 0, 1, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
  G[0, 1, 1, 1, 2, 0, 1, 0, 0], 
 (eps^3*mm^(2*eps)*(-12*mm*pp4 + 5*pp4^2 + 12*mm*t - 7*pp4*t)*
    G[0, 0, 1, 1, 1, 0, 2, 0, 0])/(2*(pp4 - 2*t)) - 
  (eps^2*mm^(1 + 2*eps)*(-4*mm + pp4)*(pp4 - t)*G[0, 0, 1, 1, 1, 0, 3, 0, 0])/
   (pp4 - 2*t) + (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 0, 2, 0, 1, 0, 2, 0, 
     0])/2 + (eps^2*mm^(2*eps)*(-4*mm + pp4 - t)*G[0, 0, 2, 1, 0, 2, 0, 0, 
     0])/2 + (eps^2*mm^(2*eps)*(-4*mm + pp4)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 0, 2, 1, 1, 0, 2, 0, 0])/(pp4 - 2*t) - 
  (eps^2*mm^(2*eps)*(-4*mm + pp4 - t)*t*G[0, 0, 2, 2, 0, 1, 0, 0, 0])/
   (pp4 - t) - (eps^2*mm^(2*eps)*(-4*mm + pp4)*G[0, 1, 0, 0, 2, 0, 2, 0, 0])/
   4 + (3*eps^2*mm^(2*eps)*(-4*mm + pp4)*t*G[0, 1, 0, 0, 2, 2, 0, 0, 0])/
   (4*(pp4 - 2*t)) - eps^3*mm^(2*eps)*(-4*mm + 3*pp4 - t)*
   G[0, 1, 0, 1, 1, 0, 2, 0, 0] + eps^3*mm^(2*eps)*(-4*mm + pp4 - t)*
   G[0, 1, 1, 1, 0, 2, 0, 0, 0] - 2*eps^4*mm^(2*eps)*pp4*
   G[0, 1, 1, 1, 1, 0, 1, 0, 0] + eps^2*mm^(1 + 2*eps)*t*
   G[0, 1, 1, 1, 1, 0, 2, 0, 0] - (eps^3*mm^(2*eps)*(-4*mm + pp4)*(pp4 + t)*
    G[0, 1, 1, 1, 2, 0, 1, 0, 0])/2 + eps^2*mm^(2*eps)*(-4*mm + pp4 - t)*t*
   G[0, 1, 1, 2, 0, 2, 0, 0, 0] + 
  (eps^2*mm^(2*eps)*(-4*mm*pp4 + pp4^2 - 4*mm*t - pp4*t)*
    G[0, 2, 0, 0, 1, 0, 2, 0, 0])/(2*(pp4 - t)) - 
  eps^2*mm^(2*eps)*(-4*mm + pp4)*t*G[0, 2, 2, 1, 1, 0, 0, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - t)*G[0, 0, 1, 1, 1, 1, 1, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
  G[0, 0, 2, 1, 1, 1, 1, 0, 0], eps^3*mm^(2*eps)*Sqrt[4*mm - s]*Sqrt[-s]*t*
  G[1, 1, 1, 1, 0, 2, 0, 0, 0], 
 -(eps^2*mm^(2*eps)*t*G[0, 1, 2, 2, 0, 0, 0, 0, 0]) + 
  eps^3*(-1 + 2*eps)*mm^(2*eps)*t*G[1, 1, 1, 1, 0, 1, 0, 0, 0] - 
  eps^3*mm^(2*eps)*(4*mm - s)*t*G[1, 1, 1, 1, 0, 2, 0, 0, 0], 
 eps^3*mm^(2*eps)*t*Sqrt[-pp4 + s + t]*Sqrt[4*mm - pp4 + s + t]*
  G[1, 1, 0, 1, 2, 0, 1, 0, 0], 
 -(eps^2*mm^(2*eps)*t*G[0, 2, 0, 1, 0, 0, 2, 0, 0]) + 
  eps^3*(-1 + 2*eps)*mm^(2*eps)*t*G[1, 1, 0, 1, 1, 0, 1, 0, 0] - 
  eps^3*mm^(2*eps)*t*(4*mm - pp4 + s + t)*G[1, 1, 0, 1, 2, 0, 1, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - s - t)*G[1, 0, 1, 1, 0, 1, 1, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[-s]*Sqrt[-t]*Sqrt[4*mm*pp4 - 4*mm*s - 4*mm*t + s*t]*
  G[1, 0, 2, 1, 0, 1, 1, 0, 0], eps^4*mm^(2*eps)*s*
  G[1, 1, 0, 0, 1, 1, 1, 0, 0], eps^3*mm^(2*eps)*Sqrt[-t]*Sqrt[-pp4 + s + t]*
  Sqrt[4*mm*s + pp4*t - s*t - t^2]*G[1, 1, 0, 0, 2, 1, 1, 0, 0], 
 eps^4*mm^(2*eps)*(s + t)*G[1, 1, 1, 0, 1, 1, 0, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[-s]*Sqrt[-t]*Sqrt[4*mm*pp4 - 4*mm*s - 4*mm*t + s*t]*
  G[1, 1, 1, 0, 1, 2, 0, 0, 0], 
 (-3*eps^2*mm^(2*eps)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 0, 0, 2, 2, 0, 0, 0])/(4*s*(pp4 - 2*t)) - 
  (3*eps^3*mm^(2*eps)*(pp4 - t)*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 1, 0, 1, 2, 0, 0, 0])/(2*s*(pp4 - 2*t)) + 
  (eps^2*mm^(1 + 2*eps)*(pp4 - t)*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 1, 0, 1, 3, 0, 0, 0])/(s*(pp4 - 2*t)) - 
  (eps^2*mm^(2*eps)*(-2*mm*s + pp4*s - 2*mm*t)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 1, 1, 0, 2, 2, 0, 0, 0])/(s*(pp4 - 2*t)) + 
  (3*eps^3*mm^(2*eps)*(pp4 - s)*(-2*mm*s + pp4*s - 2*mm*t)*
    G[1, 0, 1, 0, 1, 2, 0, 0, 0])/(2*(pp4 - 2*s)*s) - 
  (eps^2*mm^(1 + 2*eps)*(pp4 - s)*(-2*mm*s + pp4*s - 2*mm*t)*
    G[1, 0, 1, 0, 1, 3, 0, 0, 0])/((pp4 - 2*s)*s) + 
  (3*eps^2*mm^(2*eps)*(-2*mm*s + pp4*s - 2*mm*t)*G[1, 0, 2, 0, 0, 2, 0, 0, 
     0])/(4*(pp4 - 2*s)) + (eps^2*mm^(2*eps)*(-(mm*pp4) + pp4*s - s^2)*
    (-2*mm*s + pp4*s - 2*mm*t)*G[1, 0, 2, 0, 1, 2, 0, 0, 0])/
   ((pp4 - 2*s)*s) - (eps^3*mm^(2*eps)*(-2*mm*s - 2*mm*t + s*t)*
    G[1, 1, 1, 0, 1, 2, 0, 0, 0])/2 - 
  (eps^3*mm^(2*eps)*(-(mm*s^2) - 2*mm*s*t + pp4*s*t - mm*t^2)*
    G[1, 1, 1, 0, 2, 1, 0, 0, 0])/s, eps^4*mm^(2*eps)*(pp4 - s)*
  G[1, 0, 1, 1, 1, 0, 1, 0, 0], eps^3*mm^(2*eps)*Sqrt[-t]*Sqrt[-pp4 + s + t]*
  Sqrt[4*mm*s + pp4*t - s*t - t^2]*G[1, 0, 1, 1, 1, 0, 2, 0, 0], 
 (3*eps^3*mm^(2*eps)*(pp4 - t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[0, 0, 1, 1, 1, 0, 2, 0, 0])/(2*(pp4 - 2*t)*t) - 
  (eps^2*mm^(1 + 2*eps)*(pp4 - t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[0, 0, 1, 1, 1, 0, 3, 0, 0])/((pp4 - 2*t)*t) + 
  (3*eps^2*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[0, 0, 2, 1, 0, 0, 2, 0, 0])/(4*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 0, 2, 1, 1, 0, 2, 0, 0])/((pp4 - 2*t)*t) + 
  (3*eps^2*mm^(2*eps)*(pp4 - s - t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[1, 0, 0, 0, 2, 0, 2, 0, 0])/(4*(pp4 - 2*s - 2*t)*t) + 
  (3*eps^3*mm^(2*eps)*(s + t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[1, 0, 1, 0, 1, 0, 2, 0, 0])/(2*(pp4 - 2*s - 2*t)*t) - 
  (eps^2*mm^(1 + 2*eps)*(s + t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[1, 0, 1, 0, 1, 0, 3, 0, 0])/((pp4 - 2*s - 2*t)*t) + 
  (eps^2*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t)*(-(mm*pp4) + pp4*s - s^2 + 
     pp4*t - 2*s*t - t^2)*G[1, 0, 1, 0, 2, 0, 2, 0, 0])/
   ((pp4 - 2*s - 2*t)*t) - (eps^3*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t - 
     s*t - t^2)*G[1, 0, 1, 1, 1, 0, 2, 0, 0])/2 - 
  (eps^3*mm^(2*eps)*(-(mm*pp4^2) + 2*mm*pp4*s - mm*s^2 + pp4^2*t - pp4*s*t - 
     pp4*t^2)*G[1, 0, 1, 1, 2, 0, 1, 0, 0])/t, 
 eps^4*mm^(2*eps)*(pp4 - t)*G[1, 0, 1, 0, 1, 1, 1, 0, 0], 
 -(eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s - t)*
    G[1, 0, 1, 0, 2, 1, 1, 0, 0]) + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*s*G[1, 0, 2, 0, 1, 1, 1, 0, 0], 
 eps^3*mm^(2*eps)*Sqrt[-s]*Sqrt[-pp4 + s + t]*
  Sqrt[pp4*s - s^2 + 4*mm*t - s*t]*G[2, 0, 1, 0, 1, 1, 1, 0, 0], 
 (eps^3*mm^(2*eps)*(2*mm*pp4 - pp4^2 + pp4*s - 2*mm*t + pp4*t)*
    G[1, 0, 1, 0, 2, 1, 1, 0, 0])/2 + 
  (eps^3*mm^(2*eps)*(2*mm*pp4 - pp4*s - 2*mm*t)*G[1, 0, 2, 0, 1, 1, 1, 0, 0])/
   2, -2*eps^3*mm^(2*eps)*(pp4 + s)*G[1, 0, 1, 0, 1, 0, 2, 0, 0] + 
  2*eps^2*mm^(1 + 2*eps)*(pp4 + s)*G[1, 0, 1, 0, 1, 0, 3, 0, 0] + 
  eps^3*mm^(2*eps)*(pp4 - t)*G[2, 0, 1, 0, 1, 1, 1, -1, 0], 
 eps^4*mm^(2*eps)*s*t*G[1, 1, 1, 1, 0, 1, 1, 0, 0], 
 -(eps^4*mm^(2*eps)*t*(-pp4 + s + t)*G[1, 1, 0, 1, 1, 1, 1, 0, 0]), 
 eps^4*mm^(2*eps)*(pp4 - s)*t*G[1, 1, 1, 1, 1, 1, 0, 0, 0], 
 -(eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*G[1, 1, 1, 0, 1, 2, 0, 0, 
     0]) + 2*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*
   G[1, 1, 1, 1, 0, 2, 0, 0, 0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*(pp4 - s)*t*G[1, 1, 2, 1, 1, 1, 0, 0, 0], 
 eps^4*mm^(2*eps)*t*(s + t)*G[1, 1, 1, 1, 1, 0, 1, 0, 0], 
 -(eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*G[1, 0, 1, 1, 1, 0, 2, 0, 
     0]) + 2*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*t*
   G[1, 1, 0, 1, 1, 0, 2, 0, 0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*t*(s + t)*G[1, 1, 1, 1, 2, 0, 1, 0, 0], 
 eps^4*mm^(2*eps)*Sqrt[-pp4 + s + t]*
  Sqrt[-pp4^3 + pp4^2*s + pp4^2*t - 4*mm*s*t]*G[1, 0, 1, 1, 1, 1, 1, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - t)*G[1, 0, 1, 1, 0, 1, 1, 0, 0] - 
  eps^4*mm^(2*eps)*(pp4 - t)*G[1, 0, 1, 1, 1, 1, 1, -1, 0], 
 (eps^3*mm^(2*eps)*(pp4 - t)*(-3*mm*pp4 + 3*mm*s + 2*pp4*t - t^2)*
    G[0, 0, 1, 1, 1, 0, 2, 0, 0])/((pp4 - s)*(pp4 - 2*t)) - 
  (2*eps^2*mm^(1 + 2*eps)*(pp4 - t)*(-(mm*pp4) + mm*s + pp4*t - t^2)*
    G[0, 0, 1, 1, 1, 0, 3, 0, 0])/((pp4 - s)*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*t*(-3*mm*pp4 + 3*mm*s + 2*pp4*t - t^2)*
    G[0, 0, 2, 1, 0, 0, 2, 0, 0])/(2*(pp4 - s)*(pp4 - 2*t)) + 
  (eps^2*mm^(2*eps)*pp4*t*G[0, 0, 2, 1, 0, 2, 0, 0, 0])/(4*(pp4 - s)) + 
  (eps^2*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 0, 2, 1, 1, 0, 2, 0, 0])/((pp4 - s)*(pp4 - 2*t)) - 
  eps^4*mm^(2*eps)*(pp4 - s - t)*G[1, -1, 1, 1, 1, 1, 1, 0, 0] + 
  (eps^2*mm^(2*eps)*(pp4 - s - t)*(-6*mm*pp4 + 6*mm*s + 5*pp4*t - 4*s*t - 
     4*t^2)*G[1, 0, 0, 0, 2, 0, 2, 0, 0])/(4*(pp4 - s)*(pp4 - 2*s - 2*t)) - 
  (eps^3*mm^(2*eps)*(pp4 - s - t)*t*G[1, 0, 0, 0, 2, 1, 1, 0, 0])/
   (2*(pp4 - s)) + (3*eps^3*mm^(2*eps)*(s + t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[1, 0, 1, 0, 1, 0, 2, 0, 0])/(2*(pp4 - s)*(pp4 - 2*s - 2*t)) - 
  (eps^2*mm^(1 + 2*eps)*(s + t)*(-2*mm*pp4 + 2*mm*s + pp4*t)*
    G[1, 0, 1, 0, 1, 0, 3, 0, 0])/((pp4 - s)*(pp4 - 2*s - 2*t)) - 
  (eps^4*mm^(2*eps)*(pp4*s - s^2 + pp4*t - t^2)*G[1, 0, 1, 0, 1, 1, 1, 0, 0])/
   (pp4 - s) + (eps^3*mm^(2*eps)*t*G[1, 0, 1, 0, 1, 2, 0, 0, 0])/2 + 
  (eps^2*mm^(2*eps)*(-2*mm*pp4 + 2*mm*s + pp4*t)*(-(mm*pp4) + pp4*s - s^2 + 
     pp4*t - 2*s*t - t^2)*G[1, 0, 1, 0, 2, 0, 2, 0, 0])/
   ((pp4 - s)*(pp4 - 2*s - 2*t)) - 
  (eps^3*mm^(2*eps)*t*(-2*mm*pp4 + pp4^2 - pp4*s + 2*mm*t - pp4*t)*
    G[1, 0, 1, 0, 2, 1, 1, 0, 0])/(2*(pp4 - s)) - 
  (eps^4*mm^(2*eps)*(pp4 - t)*t*G[1, 0, 1, 1, 0, 1, 1, 0, 0])/(pp4 - s) - 
  eps^4*mm^(2*eps)*t*G[1, 0, 1, 1, 1, 0, 1, 0, 0] - 
  (eps^3*mm^(2*eps)*t*(-2*mm*pp4 + 2*mm*s + pp4*t - s*t - t^2)*
    G[1, 0, 1, 1, 1, 0, 2, 0, 0])/(2*(pp4 - s)) + 
  (eps^4*mm^(2*eps)*(pp4 - t)*t*G[1, 0, 1, 1, 1, 1, 1, -1, 0])/(pp4 - s) - 
  eps^4*mm^(2*eps)*(pp4 - s - t)*t*G[1, 0, 1, 1, 1, 1, 1, 0, 0] - 
  (eps^3*mm^(2*eps)*(-(mm*pp4^2) + 2*mm*pp4*s - mm*s^2 + pp4^2*t - pp4*s*t - 
     pp4*t^2)*G[1, 0, 1, 1, 2, 0, 1, 0, 0])/(pp4 - s) - 
  (eps^3*mm^(2*eps)*s*t*G[1, 0, 2, 0, 0, 1, 1, 0, 0])/(2*(pp4 - s)) - 
  (eps^3*mm^(2*eps)*t*(-2*mm*pp4 + pp4*s + 2*mm*t)*
    G[1, 0, 2, 0, 1, 1, 1, 0, 0])/(2*(pp4 - s)), 
 -(eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - s - t)*
    G[1, 0, 1, 1, 1, 0, 2, 0, 0]) - 2*eps^4*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*(pp4 - s - t)*G[1, 0, 1, 1, 1, 1, 1, 0, 0] + 
  eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*G[1, 0, 2, 1, 0, 1, 1, 0, 
    0] - eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
   G[1, 0, 2, 1, 1, 1, 1, -1, 0], eps^4*mm^(2*eps)*Sqrt[-s]*
  Sqrt[-(pp4^2*s) - 4*mm*pp4*t + 4*mm*s*t + 4*mm*t^2]*
  G[1, 1, 1, 0, 1, 1, 1, 0, 0], 
 eps^4*mm^(2*eps)*(pp4 - t)*G[1, 1, 1, 0, 1, 1, 0, 0, 0] - 
  eps^4*mm^(2*eps)*(pp4 - t)*G[1, 1, 1, 0, 1, 1, 1, 0, -1], 
 -1/2*(eps^3*mm^(2*eps)*(pp4 - t)*t*G[0, 0, 1, 1, 1, 0, 2, 0, 0])/(s + t) + 
  (eps^2*mm^(1 + 2*eps)*(pp4 - t)*t*G[0, 0, 1, 1, 1, 0, 3, 0, 0])/(s + t) - 
  (eps^4*mm^(2*eps)*(pp4 - t)*t*G[0, 0, 1, 1, 1, 1, 1, 0, 0])/(s + t) - 
  (eps^2*mm^(2*eps)*t^2*G[0, 0, 2, 1, 0, 0, 2, 0, 0])/(4*(s + t)) - 
  (eps^2*mm^(2*eps)*pp4*t*G[0, 0, 2, 1, 0, 2, 0, 0, 0])/(4*(s + t)) + 
  (3*eps^2*mm^(2*eps)*t^2*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 0, 0, 2, 2, 0, 0, 0])/(4*s*(pp4 - 2*t)*(s + t)) + 
  (3*eps^3*mm^(2*eps)*(pp4 - t)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 1, 0, 1, 2, 0, 0, 0])/(2*s*(pp4 - 2*t)*(s + t)) - 
  (eps^2*mm^(1 + 2*eps)*(pp4 - t)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[0, 1, 1, 0, 1, 3, 0, 0, 0])/(s*(pp4 - 2*t)*(s + t)) + 
  (eps^2*mm^(2*eps)*t*(-2*mm*s + pp4*s - 2*mm*t)*(-(mm*pp4) + pp4*t - t^2)*
    G[0, 1, 1, 0, 2, 2, 0, 0, 0])/(s*(pp4 - 2*t)*(s + t)) + 
  (eps^3*mm^(2*eps)*(pp4 - s - t)*t*G[1, 0, 0, 0, 2, 1, 1, 0, 0])/
   (2*(s + t)) - (eps^3*mm^(2*eps)*t*G[1, 0, 1, 0, 1, 0, 2, 0, 0])/2 + 
  (eps^4*mm^(2*eps)*(-s^2 + 2*pp4*t - s*t - 2*t^2)*
    G[1, 0, 1, 0, 1, 1, 1, 0, 0])/(s + t) - 
  (3*eps^3*mm^(2*eps)*(pp4 - s)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[1, 0, 1, 0, 1, 2, 0, 0, 0])/(2*(pp4 - 2*s)*s*(s + t)) + 
  (eps^2*mm^(1 + 2*eps)*(pp4 - s)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[1, 0, 1, 0, 1, 3, 0, 0, 0])/((pp4 - 2*s)*s*(s + t)) + 
  (eps^3*mm^(2*eps)*t*(-2*mm*pp4 + pp4^2 - pp4*s + 2*mm*t - pp4*t)*
    G[1, 0, 1, 0, 2, 1, 1, 0, 0])/(2*(s + t)) + 
  (eps^3*mm^(2*eps)*s*t*G[1, 0, 2, 0, 0, 1, 1, 0, 0])/(2*(s + t)) - 
  (eps^2*mm^(2*eps)*t*(-6*mm*s + 5*pp4*s - 4*s^2 - 6*mm*t)*
    G[1, 0, 2, 0, 0, 2, 0, 0, 0])/(4*(pp4 - 2*s)*(s + t)) + 
  (eps^3*mm^(2*eps)*t*(-2*mm*pp4 + pp4*s + 2*mm*t)*
    G[1, 0, 2, 0, 1, 1, 1, 0, 0])/(2*(s + t)) - 
  (eps^2*mm^(2*eps)*(-(mm*pp4) + pp4*s - s^2)*t*(-2*mm*s + pp4*s - 2*mm*t)*
    G[1, 0, 2, 0, 1, 2, 0, 0, 0])/((pp4 - 2*s)*s*(s + t)) + 
  eps^4*mm^(2*eps)*s*G[1, 1, 1, -1, 1, 1, 1, 0, 0] + 
  (eps^4*mm^(2*eps)*(pp4*s + t^2)*G[1, 1, 1, 0, 1, 1, 0, 0, 0])/(s + t) - 
  (eps^4*mm^(2*eps)*s*(pp4 - t)*G[1, 1, 1, 0, 1, 1, 1, 0, -1])/(s + t) + 
  eps^4*mm^(2*eps)*s*t*G[1, 1, 1, 0, 1, 1, 1, 0, 0] + 
  (eps^3*mm^(2*eps)*t*(-2*mm*s - 2*mm*t + s*t)*G[1, 1, 1, 0, 1, 2, 0, 0, 0])/
   (2*(s + t)) + (eps^3*mm^(2*eps)*t*(-(mm*s^2) - 2*mm*s*t + pp4*s*t - 
     mm*t^2)*G[1, 1, 1, 0, 2, 1, 0, 0, 0])/(s*(s + t)), 
 (-3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)^2*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 0, 1, 1, 1, 0, 2, 0, 0])/
   (2*(pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) + 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)^2*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 0, 1, 1, 1, 0, 3, 0, 0])/
   ((pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) - 
  (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*t*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 0, 2, 1, 0, 0, 2, 0, 0])/
   (4*(pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) + 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    (2*mm*s - pp4*s + 2*mm*t)*(mm*pp4 - pp4*t + t^2)*
    G[0, 0, 2, 1, 1, 0, 2, 0, 0])/((pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + 
     mm*t^2)) + (3*eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*t*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 1, 0, 0, 2, 2, 0, 0, 0])/
   (4*(pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) + 
  (3*eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)^2*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 1, 1, 0, 1, 2, 0, 0, 0])/
   (2*(pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) - 
  (eps^2*mm^(1 + 2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)^2*
    (2*mm*s - pp4*s + 2*mm*t)*G[0, 1, 1, 0, 1, 3, 0, 0, 0])/
   ((pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + mm*t^2)) - 
  (eps^2*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
    (2*mm*s - pp4*s + 2*mm*t)*(mm*pp4 - pp4*t + t^2)*
    G[0, 1, 1, 0, 2, 2, 0, 0, 0])/((pp4 - 2*t)*(mm*s^2 + 2*mm*s*t - pp4*s*t + 
     mm*t^2)) - eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
   G[1, 0, 1, 0, 2, 1, 1, 0, 0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*s*G[1, 1, 0, 0, 2, 1, 1, 0, 0] + 
  2*eps^4*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*s*
   G[1, 1, 1, 0, 1, 1, 1, 0, 0] + eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*s*G[1, 1, 1, 0, 1, 2, 0, 0, 0] + 
  eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*Sqrt[-pp4]*(pp4 - t)*
   G[1, 1, 1, 0, 2, 1, 0, 0, 0] - eps^3*mm^(2*eps)*Sqrt[4*mm - pp4]*
   Sqrt[-pp4]*(pp4 - t)*G[1, 1, 1, 0, 2, 1, 1, 0, -1], 
 eps^4*mm^(1/2 + 2*eps)*Sqrt[-s]*s*G[0, 1, 1, 1, 1, 1, 1, 0, 0], 
 eps^4*mm^(-1/2 + 2*eps)*Sqrt[-s]*G[-2, 1, 1, 1, 1, 1, 1, 0, 0], 
 -(eps^4*mm^(2*eps)*t*(-pp4 + t)*G[1, 1, 1, 1, 1, 1, 1, -1, 0]) + 
  eps^4*mm^(2*eps)*t*(-pp4 + t)*G[1, 1, 1, 1, 1, 1, 1, 0, -1], 
 eps^4*mm^(2*eps)*t*G[1, 1, 1, 1, 1, 1, 1, -2, 0] + 
  eps^4*mm^(2*eps)*s*t*G[1, 1, 1, 1, 1, 1, 1, -1, 0] - 
  eps^4*mm^(2*eps)*t*G[1, 1, 1, 1, 1, 1, 1, 0, -2] - 
  eps^4*mm^(2*eps)*s*t*G[1, 1, 1, 1, 1, 1, 1, 0, -1], 
 eps^4*mm^(2*eps)*t*Sqrt[pp4^2 + 16*mm*t - 2*pp4*t + t^2]*
   G[1, 1, 1, 1, 1, 1, 1, -1, 0] + eps^4*mm^(2*eps)*t*
   Sqrt[pp4^2 + 16*mm*t - 2*pp4*t + t^2]*G[1, 1, 1, 1, 1, 1, 1, 0, -1], 
 -((eps^4*mm^(2*eps)*(pp4 - t)^2*t*G[1, 1, 1, 1, 1, 1, 1, -1, -1])/
   ((pp4 - 2*s - t)*Sqrt[pp4^2 + 16*mm*t - 2*pp4*t + t^2])), 
 eps^4*mm^(2*eps)*Sqrt[s]*Sqrt[pp4 - s - t]*t*
  Sqrt[pp4*s - s^2 + 4*mm*t - s*t]*G[1, 1, 1, 1, 1, 1, 1, 0, 0], 
 eps^4*mm^(2*eps)*t*G[1, 1, 1, 1, 1, 1, 1, -2, 0] - 
  (4*eps^4*mm^(2*eps)*s*t*G[1, 1, 1, 1, 1, 1, 1, -1, -1])/(pp4 - 2*s - t) - 
  (eps^4*mm^(2*eps)*(pp4 - 4*s - t)*t*G[1, 1, 1, 1, 1, 1, 1, -1, 0])/4 + 
  eps^4*mm^(2*eps)*t*G[1, 1, 1, 1, 1, 1, 1, 0, -2] - 
  (eps^4*mm^(2*eps)*(pp4 - 4*s - t)*t*G[1, 1, 1, 1, 1, 1, 1, 0, -1])/4}
