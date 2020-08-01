(* Created with the Wolfram Language : www.wolfram.com *)
{(2*((-4*s12*(-mmH + s12 + t)*canMI[1, 0, {s12, mmH - s12 - t, mmH}])/
     (-mmH + s12) + (4*s12*(mmH^2 + s12^2 + s12*t + t^2 - mmH*(2*s12 + t))*
      canMI[1, 0, {s12, t, mmH}])/((-mmH + s12)*t) + 
    (4*s12*(s12^2 + t^2)*canMI[1, 0, {mmH - s12 - t, t, mmH}])/
     (t*(s12 + t)) + (4*s12*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 
       2*mmH*(s12 + t))*canMI[1, 0, {t, s12, mmH}])/((mmH - t)*t) + 
    (s12*(-8 + mmH - t)*canMI[5, 2, {s12, mmH - s12 - t, mmH}])/t + 
    (s12*(-8 + s12 + t)*canMI[5, 2, {s12, t, mmH}])/t - 
    ((s12^2 + 4*t*(-mmH + t) + s12*(-8 + 5*t))*
      canMI[5, 2, {mmH - s12 - t, t, mmH}])/t - 
    ((4*t*(-mmH + t) + s12*(-8 + mmH + 3*t))*canMI[6, 2, 
       {mmH - s12 - t, t, mmH}])/t + 
    (s12*(-8 + s12 + t)*canMI[7, 2, {s12, mmH - s12 - t, mmH}])/(s12 + t) - 
    (s12*(-8 + mmH - t)*(-mmH + s12 + t)*canMI[7, 2, {s12, t, mmH}])/
     ((mmH - t)*t) + ((-(mmH*s12^2) + mmH^2*(s12 - 4*t) + 
       2*mmH*s12*(-4 + t) + s12*(8 - 3*t)*t + 8*mmH*t^2 - 4*t^3 + 
       s12^2*(8 + t))*canMI[7, 2, {mmH - s12 - t, t, mmH}])/((mmH - t)*t) - 
    (s12*(mmH^3 - 2*mmH^2*(4 + s12 + t) + mmH*(s12^2 + 4*s12*(4 + t) + 
         2*t*(4 + t)) - 2*(4*t^2 + s12^2*(4 + t) + s12*t*(4 + t)))*
      canMI[8, 2, {s12, mmH - s12 - t, mmH}])/((mmH - s12)^2*t) + 
    (s12*(mmH^3 - 2*mmH^2*(2*s12 + t) + mmH*(5*s12^2 + 4*s12*t + 
         2*t*(4 + t)) - 2*(s12^3 + s12^2*t + 4*t^2 + s12*t*(4 + t)))*
      canMI[8, 2, {s12, t, mmH}])/((mmH - s12)^2*t) - 
    ((2*s12^4 + 4*s12^2*(2 + mmH - 3*t)*t + s12*(8*mmH - 11*t)*t^2 + 
       4*(mmH - t)*t^3 - s12^3*(8 + 3*t))*canMI[8, 2, 
       {mmH - s12 - t, t, mmH}])/(t*(s12 + t)^2) - 
    (2*s12*(-4 + mmH - t)*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[8, 2, {t, s12, mmH}])/((mmH - t)^2*t) - 
    (2*s12*(mmH^3 - mmH^2*(4*s12 + t) + mmH*s12*(5*s12 + 4*t) - 
       s12*(2*s12^2 + 3*s12*t + 2*t^2))*canMI[4, 1, {s12, mmH - s12 - t, 
        mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/(mmH*(mmH - s12)^2*t) - 
    (2*s12*(mmH^2*(s12 + t) - 2*mmH*s12*(s12 + 2*t) + 
       s12*(s12^2 + 3*s12*t + 2*t^2))*canMI[4, 1, {s12, t, mmH}]*
      myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/(mmH*(mmH - s12)^2*t) + 
    (2*s12*(mmH^2*(s12^2 - 6*s12*t - 3*t^2) + 
       mmH*(-s12^3 - s12^2*t + 5*s12*t^2 + t^3) + 
       t*(5*s12^3 + 8*s12^2*t + 5*s12*t^2 + 2*t^3))*
      canMI[4, 1, {mmH - s12 - t, t, mmH}]*myRoot[4 - mmH, 1/2]*
      myRoot[-mmH, 1/2])/(mmH*(mmH - t)*t*(s12 + t)^2) + 
    (4*s12*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[4, 1, {t, s12, mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/
     (mmH*(mmH - t)^2) - (2*s12*(mmH^2 + s12^2 + 2*s12*t + 2*t^2 - 
       2*mmH*(s12 + t))*canMI[2, 1, {s12, mmH - s12 - t, mmH}]*
      myRoot[4 - s12, 1/2]*myRoot[-s12, 1/2])/((mmH - s12)^2*t) + 
    (2*s12*(mmH^2 + s12^2 + 2*s12*t + 2*t^2 - 2*mmH*(s12 + t))*
      canMI[2, 1, {s12, t, mmH}]*myRoot[4 - s12, 1/2]*myRoot[-s12, 1/2])/
     ((mmH - s12)^2*t) + ((-4 + s12)*s12*canMI[9, 2, {s12, t, mmH}]*
      myRoot[-s12, 1/2]*myRoot[4*mmH + s12*(-4 + t) - 4*t, 1/2]*
      myRoot[-t, 1/2])/((4*mmH + s12*(-4 + t) - 4*t)*t) - 
    (4*s12*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[2, 1, {t, s12, mmH}]*myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/
     ((mmH - t)^2*t) + (2*s12*canMI[3, 1, {s12, t, mmH}]*myRoot[4 - t, 1/2]*
      myRoot[-t, 1/2])/t + (2*s12*(-5*mmH + 4*s12 + 5*t)*
      canMI[3, 1, {mmH - s12 - t, t, mmH}]*myRoot[4 - t, 1/2]*
      myRoot[-t, 1/2])/(t*(-mmH + t)) - 
    (2*s12*(s12^2 - 6*s12*t - 3*t^2)*canMI[2, 1, {mmH - s12 - t, t, mmH}]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
     (t*(s12 + t)^2) + (2*s12*canMI[3, 1, {s12, mmH - s12 - t, mmH}]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/t - 
    ((-4 + s12)*s12*canMI[9, 2, {s12, mmH - s12 - t, mmH}]*myRoot[-s12, 1/2]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[mmH*s12 - s12^2 + 4*t - s12*t, 1/2])/
     (t*(-(mmH*s12) + s12^2 - 4*t + s12*t)) + 
    ((s12^2 + 4*s12*(-3 + t) + 4*t*(-mmH + t))*
      canMI[9, 2, {mmH - s12 - t, t, mmH}]*myRoot[-t, 1/2]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[-(s12*(-4 + t)) + (mmH - t)*t, 1/2])/
     (t*(s12*(-4 + t) + t*(-mmH + t)))))/s12^3, 
 (8*t*canMI[1, 0, {s12, mmH - s12 - t, mmH}])/
   ((s12 + t)*(-mmH + s12 + t)^2) - 
  (8*(mmH^2 + s12^2 + 2*s12*t + 2*t^2 - 2*mmH*(s12 + t))*
    canMI[1, 0, {s12, t, mmH}])/((mmH - s12)*s12*(-mmH + s12 + t)^2) + 
  (8*(s12^2 + s12*t + t^2)*canMI[1, 0, {mmH - s12 - t, t, mmH}])/
   (s12*(s12 + t)*(-mmH + s12 + t)^2) - 
  (8*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
    canMI[1, 0, {t, s12, mmH}])/(s12*(mmH - t)*(-mmH + s12 + t)^2) - 
  (2*(mmH^2 + s12^2 + s12*(8 - 3*t) + 8*t - mmH*(8 + 2*s12 + t))*
    canMI[5, 2, {s12, t, mmH}])/(s12*(-mmH + s12 + t)^3) + 
  (2*(8 - mmH + s12)*canMI[5, 2, {mmH - s12 - t, t, mmH}])/
   (s12*(-mmH + s12 + t)^2) + 
  (2*(8 - mmH + t)*canMI[6, 2, {s12, mmH - s12 - t, mmH}])/
   (s12*(-mmH + s12 + t)^2) - 
  (2*(mmH^2 + s12*(8 - 3*t) + t*(8 + t) - mmH*(8 + s12 + 2*t))*
    canMI[6, 2, {s12, t, mmH}])/(s12*(-mmH + s12 + t)^3) + 
  (2*((-8 + mmH)*t^2 - 2*s12*t*(4 - mmH + t) + s12^2*(mmH - 2*(4 + t)))*
    canMI[7, 2, {s12, mmH - s12 - t, mmH}])/(s12*(s12 + t)^2*
    (-mmH + s12 + t)^2) - (2*(mmH^2 + s12*(8 + t) + t*(8 + 5*t) - 
     mmH*(8 + s12 + 6*t))*canMI[7, 2, {s12, t, mmH}])/
   ((mmH - t)*(mmH - s12 - t)^3) + 
  (2*(8 - mmH + t)*canMI[7, 2, {mmH - s12 - t, t, mmH}])/
   ((mmH - t)*(-mmH + s12 + t)^2) - 
  (2*(8 - mmH + s12)*t*canMI[8, 2, {s12, mmH - s12 - t, mmH}])/
   (s12*(-mmH + s12)*(-mmH + s12 + t)^2) + 
  (2*(2*mmH^4 + 2*s12^4 + 16*t^3 + 4*s12*t^2*(10 + t) - 
     mmH^3*(8 + 8*s12 + 7*t) + s12^2*t*(32 + 9*t) + s12^3*(8 + 11*t) + 
     mmH^2*(12*s12^2 + t*(32 + 9*t) + s12*(24 + 25*t)) - 
     mmH*(8*s12^3 + 4*t^2*(10 + t) + 2*s12*t*(32 + 9*t) + s12^2*(24 + 29*t)))*
    canMI[8, 2, {s12, t, mmH}])/((mmH - s12)^2*s12*(mmH - s12 - t)^3) + 
  ((2*mmH*(s12 + t)^2 - 4*(s12^3 + 2*s12^2*t + t^3 + 2*s12*t*(2 + t)))*
    canMI[8, 2, {mmH - s12 - t, t, mmH}])/(s12*(s12 + t)^2*
    (-mmH + s12 + t)^2) + (4*(-4 + mmH - t)*(mmH^2 + 2*s12^2 + 2*s12*t + 
     t^2 - 2*mmH*(s12 + t))*canMI[8, 2, {t, s12, mmH}])/
   (s12*(mmH - t)^2*(-mmH + s12 + t)^2) + 
  (4*(2*s12^3 + 3*s12^2*t + 2*s12*t^2 + t^3 - mmH*(s12^2 + t^2))*
    canMI[4, 1, {s12, mmH - s12 - t, mmH}]*myRoot[4 - mmH, 1/2]*
    myRoot[-mmH, 1/2])/(mmH*s12*(s12 + t)^2*(-mmH + s12 + t)^2) - 
  (4*(mmH^3*(s12 - t) + mmH^2*(-2*s12^2 - 11*s12*t + t^2) - 
     s12*t*(5*s12^2 + 7*s12*t + 4*t^2) + mmH*s12*(s12^2 + 17*s12*t + 10*t^2))*
    canMI[4, 1, {s12, t, mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/
   (mmH*(mmH - s12)^2*s12*(mmH - t)*(-mmH + s12 + t)^2) + 
  (4*(-s12^3 + s12*t^2 + mmH*(s12^2 + t^2))*
    canMI[4, 1, {mmH - s12 - t, t, mmH}]*myRoot[4 - mmH, 1/2]*
    myRoot[-mmH, 1/2])/(mmH*s12*(s12 + t)^2*(-mmH + s12 + t)^2) - 
  (8*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
    canMI[4, 1, {t, s12, mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/
   (mmH*s12*(mmH - t)^2*(-mmH + s12 + t)^2) - 
  (4*canMI[2, 1, {s12, mmH - s12 - t, mmH}]*myRoot[4 - s12, 1/2]*
    myRoot[-s12, 1/2])/(s12*(-mmH + s12 + t)^2) + 
  (4*(mmH^2 + s12^2 + 8*s12*t + 4*t^2 - 2*mmH*(s12 + 4*t))*
    canMI[2, 1, {s12, t, mmH}]*myRoot[4 - s12, 1/2]*myRoot[-s12, 1/2])/
   ((mmH - s12)^2*s12*(-mmH + s12 + t)^2) + 
  (2*(-4*s12*t + 12*(-mmH + s12 + t) + (-mmH + s12 + t)^2)*
    canMI[9, 2, {s12, t, mmH}]*myRoot[-s12, 1/2]*
    myRoot[4*mmH + s12*(-4 + t) - 4*t, 1/2]*myRoot[-t, 1/2])/
   (s12*(-mmH + s12 + t)^3*(-(s12*t) + 4*(-mmH + s12 + t))) + 
  (8*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
    canMI[2, 1, {t, s12, mmH}]*myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/
   (s12*(mmH - t)^2*(-mmH + s12 + t)^2) - 
  (4*(mmH + 4*s12 - t)*canMI[3, 1, {s12, t, mmH}]*myRoot[4 - t, 1/2]*
    myRoot[-t, 1/2])/(s12*(mmH - t)*(-mmH + s12 + t)^2) - 
  (4*canMI[3, 1, {mmH - s12 - t, t, mmH}]*myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/
   (s12*(-mmH + s12 + t)^2) - 
  (4*(s12^2 + t^2)*canMI[2, 1, {mmH - s12 - t, t, mmH}]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
   (s12*(s12 + t)^2*(-mmH + s12 + t)^2) + 
  (4*(s12^2 + t^2)*canMI[3, 1, {s12, mmH - s12 - t, mmH}]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
   (s12*(s12 + t)^2*(-mmH + s12 + t)^2) - 
  (2*(4 - mmH + s12 + t)*canMI[9, 2, {s12, mmH - s12 - t, mmH}]*
    myRoot[-s12, 1/2]*myRoot[-mmH + s12 + t, 1/2]*
    myRoot[mmH*s12 - s12^2 + 4*t - s12*t, 1/2])/(s12*(-mmH + s12 + t)^2*
    (-(mmH*s12) + s12^2 - 4*t + s12*t)) - 
  (2*(4 - mmH + s12 + t)*canMI[9, 2, {mmH - s12 - t, t, mmH}]*myRoot[-t, 1/2]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[-(s12*(-4 + t)) + (mmH - t)*t, 1/2])/
   (s12*(-mmH + s12 + t)^2*(s12*(-4 + t) + t*(-mmH + t))), 
 (2*((-4*t*(-mmH^3 + s12^3 + 2*s12^2*t + 2*s12*t^2 + 2*t^3 + 
       3*mmH^2*(s12 + t) - mmH*(3*s12^2 + 5*s12*t + 4*t^2))*
      canMI[1, 0, {s12, t, mmH}])/((mmH - s12)*s12*(mmH - t)) + 
    (4*t*(s12^3 + s12^2*t + (mmH - t)*t^2 + s12*t*(-mmH + t))*
      canMI[1, 0, {mmH - s12 - t, t, mmH}])/(s12*(mmH - t)*(s12 + t)) - 
    (4*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[1, 0, {t, s12, mmH}])/(s12*(mmH - t)) - 
    ((4*s12^2 - 8*t + 3*s12*t + mmH*(-4*s12 + t))*
      canMI[5, 2, {s12, mmH - s12 - t, mmH}])/s12 - 
    ((-4*mmH*s12 + 4*s12^2 + 5*s12*t + (-8 + t)*t)*
      canMI[6, 2, {s12, mmH - s12 - t, mmH}])/s12 + 
    (t*(-8 + s12 + t)*canMI[6, 2, {s12, t, mmH}])/s12 + 
    ((-8 + mmH - s12)*t*canMI[6, 2, {mmH - s12 - t, t, mmH}])/s12 + 
    ((4*s12^2 + 9*s12*t - 4*mmH*(s12 + t) + t*(-8 + 5*t))*
      canMI[7, 2, {s12, mmH - s12 - t, mmH}])/(s12 + t) - 
    (t*(mmH^3 - 2*mmH^2*(4 + s12 + t) - 2*(4*t^2 + s12^2*(4 + t) + 
         s12*t*(4 + t)) + mmH*(2*s12^2 + 4*s12*(2 + t) + t*(16 + t)))*
      canMI[7, 2, {s12, t, mmH}])/(s12*(mmH - t)^2) - 
    (t*(mmH^3 - 2*mmH^2*(4 + s12 + t) - 2*(4*t^2 + s12^2*(4 + t) + 
         s12*t*(4 + t)) + mmH*(2*s12^2 + 4*s12*(2 + t) + t*(16 + t)))*
      canMI[7, 2, {mmH - s12 - t, t, mmH}])/(s12*(mmH - t)^2) - 
    ((4*s12^3 + mmH^2*(4*s12 - t) + 3*s12^2*t - 8*t^2 - s12*t*(8 + t) + 
       mmH*(-8*s12^2 - 2*s12*t + t*(8 + t)))*canMI[8, 2, 
       {s12, mmH - s12 - t, mmH}])/((mmH - s12)*s12) + 
    (t*(-mmH^3 + s12^3 + 3*s12^2*t + 16*t^2 + 4*s12*t*(2 + t) + 
       3*mmH^2*(s12 + t) - mmH*(3*s12^2 + 6*s12*t + 4*t*(2 + t)))*
      canMI[8, 2, {s12, t, mmH}])/((mmH - s12)^2*s12) - 
    (t*(s12^3 + 2*(-4 + t)*t^2 + s12*t*(8 + t))*
      canMI[8, 2, {mmH - s12 - t, t, mmH}])/(s12*(s12 + t)^2) + 
    (2*(-4 + mmH - t)*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[8, 2, {t, s12, mmH}])/(s12*(mmH - t)^2) + 
    (2*t*(3*s12*t*(s12 + t) - mmH^2*(5*s12 + t) + 
       mmH*(5*s12^2 + 2*s12*t + t^2))*canMI[4, 1, {s12, mmH - s12 - t, mmH}]*
      myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/(mmH*(mmH - s12)*s12*
      (s12 + t)) + (2*t*(mmH^4*(s12 + t) - 2*mmH^3*(s12^2 + 5*s12*t + t^2) - 
       2*mmH*s12*t*(4*s12^2 + 8*s12*t + 7*t^2) + 
       mmH^2*(s12^3 + 15*s12^2*t + 19*s12*t^2 + t^3) + 
       s12*t*(2*s12^3 + 3*s12^2*t + 5*s12*t^2 + 4*t^3))*
      canMI[4, 1, {s12, t, mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/
     (mmH*(mmH - s12)^2*s12*(mmH - t)^2) + 
    (2*t*(mmH^3*(s12 - t)^2 + mmH*t^2*(-7*s12^2 - 10*s12*t + t^2) - 
       mmH^2*(s12^3 - 7*s12*t^2 + 2*t^3) + s12*t*(2*s12^3 + 5*s12^2*t + 
         8*s12*t^2 + 5*t^3))*canMI[4, 1, {mmH - s12 - t, t, mmH}]*
      myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/(mmH*s12*(mmH - t)^2*
      (s12 + t)^2) - (4*t^2*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 
       2*mmH*(s12 + t))*canMI[4, 1, {t, s12, mmH}]*myRoot[4 - mmH, 1/2]*
      myRoot[-mmH, 1/2])/(mmH*s12*(mmH - t)^2) + 
    (2*t*(-5*mmH + 5*s12 + 4*t)*canMI[2, 1, {s12, mmH - s12 - t, mmH}]*
      myRoot[4 - s12, 1/2]*myRoot[-s12, 1/2])/(s12*(-mmH + s12)) - 
    (2*t*(-mmH + s12 + 2*t)^2*canMI[2, 1, {s12, t, mmH}]*myRoot[4 - s12, 1/2]*
      myRoot[-s12, 1/2])/((mmH - s12)^2*s12) + 
    ((-4 + t)*t*canMI[9, 2, {s12, t, mmH}]*myRoot[-s12, 1/2]*
      myRoot[4*mmH + s12*(-4 + t) - 4*t, 1/2]*myRoot[-t, 1/2])/
     (s12*(4*mmH + s12*(-4 + t) - 4*t)) + 
    (4*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[2, 1, {t, s12, mmH}]*myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/
     (s12*(mmH - t)^2) - (2*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 
       2*mmH*(s12 + t))*canMI[3, 1, {s12, t, mmH}]*myRoot[4 - t, 1/2]*
      myRoot[-t, 1/2])/(s12*(mmH - t)^2) - 
    (2*t*(mmH^2 + 2*s12^2 + 2*s12*t + t^2 - 2*mmH*(s12 + t))*
      canMI[3, 1, {mmH - s12 - t, t, mmH}]*myRoot[4 - t, 1/2]*
      myRoot[-t, 1/2])/(s12*(mmH - t)^2) - 
    (2*(s12 - t)^2*t*canMI[2, 1, {mmH - s12 - t, t, mmH}]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
     (s12*(s12 + t)^2) + (2*t*(5*s12 + t)*canMI[3, 1, 
       {s12, mmH - s12 - t, mmH}]*myRoot[-mmH + s12 + t, 1/2]*
      myRoot[4 - mmH + s12 + t, 1/2])/(s12*(s12 + t)) + 
    ((-4*mmH*s12 + 4*s12^2 + 4*s12*t + (-12 + t)*t)*
      canMI[9, 2, {s12, mmH - s12 - t, mmH}]*myRoot[-s12, 1/2]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[mmH*s12 - s12^2 + 4*t - s12*t, 1/2])/
     (s12*(-(mmH*s12) + s12^2 - 4*t + s12*t)) - 
    ((-4 + t)*t*canMI[9, 2, {mmH - s12 - t, t, mmH}]*myRoot[-t, 1/2]*
      myRoot[-mmH + s12 + t, 1/2]*myRoot[-(s12*(-4 + t)) + (mmH - t)*t, 1/2])/
     (s12*(s12*(-4 + t) + t*(-mmH + t)))))/t^3, 
 (-4*(2*s12^2 + 2*s12*t + t^2 - mmH*(2*s12 + t))*
    canMI[1, 0, {s12, mmH - s12 - t, mmH}])/(s12*(-mmH + s12)*(s12 + t)*
    (-mmH + s12 + t)) - (4*(s12^2 + 3*t^2 - mmH*(s12 + 3*t))*
    canMI[1, 0, {s12, t, mmH}])/((mmH - s12)*s12*(mmH - t)*t) - 
  (4*(s12^2 + 2*s12*t + 4*t^2 - mmH*(s12 + 4*t))*
    canMI[1, 0, {mmH - s12 - t, t, mmH}])/(t*(-mmH + t)*(s12 + t)*
    (-mmH + s12 + t)) + (8*canMI[1, 0, {t, s12, mmH}])/(mmH*t - t^2) - 
  (4*canMI[5, 2, {s12, mmH - s12 - t, mmH}])/t^2 - 
  (4*canMI[5, 2, {s12, t, mmH}])/(-mmH + s12 + t)^2 - 
  (4*canMI[5, 2, {mmH - s12 - t, t, mmH}])/s12^2 - 
  (4*canMI[6, 2, {s12, mmH - s12 - t, mmH}])/t^2 - 
  (4*canMI[6, 2, {s12, t, mmH}])/(-mmH + s12 + t)^2 - 
  (4*canMI[6, 2, {mmH - s12 - t, t, mmH}])/s12^2 + 
  (2*(-2*s12^3 - 6*s12^2*t - 7*s12*t^2 + (4 - 3*t)*t^2 + 2*mmH*(s12 + t)^2)*
    canMI[7, 2, {s12, mmH - s12 - t, mmH}])/((mmH - s12 - t)*t^2*
    (s12 + t)^2) + (2*(-mmH^3 + s12^2*(4 + t) + 2*s12*t*(4 + t) + 
     t^2*(4 + 3*t) + mmH^2*(4 + 2*s12 + 5*t) - 
     mmH*(s12^2 + 4*s12*(2 + t) + t*(8 + 7*t)))*canMI[7, 2, {s12, t, mmH}])/
   ((mmH - t)^2*t*(-mmH + s12 + t)^2) + 
  (4/s12^2 + (2*(4 - mmH + t))/((mmH - t)^2*t))*
   canMI[7, 2, {mmH - s12 - t, t, mmH}] + 
  ((4*mmH^2*s12 + 4*s12^3 + 8*t^2 + 2*s12*t^2 - 2*mmH*(4*s12^2 + t^2))*
    canMI[8, 2, {s12, mmH - s12 - t, mmH}])/((mmH - s12)^2*s12*t^2) + 
  (2*(-3*mmH^3 + 5*s12^3 + 12*t^2 + 6*s12^2*(2 + t) + 3*s12*t*(8 + t) + 
     mmH^2*(11*s12 + 6*(2 + t)) - mmH*(13*s12^2 + 12*s12*(2 + t) + 
       3*t*(8 + t)))*canMI[8, 2, {s12, t, mmH}])/
   ((mmH - s12)^2*s12*(-mmH + s12 + t)^2) + 
  (2*(5*s12^3 + 2*t^2*(-mmH + t) + s12^2*(-12 - 2*mmH + 9*t) + 
     s12*(-4*mmH*t + 6*t^2))*canMI[8, 2, {mmH - s12 - t, t, mmH}])/
   (s12^2*(s12 + t)^2*(-mmH + s12 + t)) + 
  (4*(4 - mmH + t)*canMI[8, 2, {t, s12, mmH}])/((mmH - t)^2*t) + 
  (4*(t^3 + mmH^2*(2*s12 + 3*t) - 2*mmH*(s12^2 + s12*t - t^2))*
    canMI[4, 1, {s12, mmH - s12 - t, mmH}]*myRoot[4 - mmH, 1/2]*
    myRoot[-mmH, 1/2])/(mmH*(mmH - s12)^2*t*(s12 + t)^2) + 
  (4*(8*mmH^3 - s12^3 - 3*s12^2*t - 5*s12*t^2 - 3*t^3 - 
     4*mmH^2*(3*s12 + 4*t) + mmH*(5*s12^2 + 16*s12*t + 11*t^2))*
    canMI[4, 1, {s12, t, mmH}]*myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/
   (mmH*(mmH - s12)^2*(mmH - t)^2*(mmH - s12 - t)) + 
  (4*(s12^3 + 2*s12*t^2 + mmH^2*(5*s12 + 2*t) + 
     2*mmH*(s12^2 - 3*s12*t - t^2))*canMI[4, 1, {mmH - s12 - t, t, mmH}]*
    myRoot[4 - mmH, 1/2]*myRoot[-mmH, 1/2])/(mmH*s12*(mmH - t)^2*
    (s12 + t)^2) + (8*canMI[4, 1, {t, s12, mmH}]*myRoot[4 - mmH, 1/2]*
    myRoot[-mmH, 1/2])/(mmH*(mmH - t)^2) - 
  (4*(2*mmH - 2*s12 + t)*canMI[2, 1, {s12, mmH - s12 - t, mmH}]*
    myRoot[4 - s12, 1/2]*myRoot[-s12, 1/2])/((mmH - s12)^2*s12*t) - 
  (4*(-5*mmH + 5*s12 + 3*t)*canMI[2, 1, {s12, t, mmH}]*myRoot[4 - s12, 1/2]*
    myRoot[-s12, 1/2])/((mmH - s12)^2*s12*(-mmH + s12 + t)) + 
  (2*(mmH^2 + 4*s12 + s12^2 + t*(4 + t) - 2*mmH*(2 + s12 + t))*
    canMI[9, 2, {s12, t, mmH}]*myRoot[-s12, 1/2]*
    myRoot[4*mmH + s12*(-4 + t) - 4*t, 1/2]*myRoot[-t, 1/2])/
   (s12*(4*mmH + s12*(-4 + t) - 4*t)*t*(-mmH + s12 + t)^2) - 
  (8*canMI[2, 1, {t, s12, mmH}]*myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/
   ((mmH - t)^2*t) + (4*(-3*mmH + s12 + 3*t)*canMI[3, 1, {s12, t, mmH}]*
    myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/((mmH - t)^2*(mmH - s12 - t)*t) - 
  (4*(2*mmH + s12 - 2*t)*canMI[3, 1, {mmH - s12 - t, t, mmH}]*
    myRoot[4 - t, 1/2]*myRoot[-t, 1/2])/(s12*(mmH - t)^2*t) + 
  (4*(5*s12 + 2*t)*canMI[2, 1, {mmH - s12 - t, t, mmH}]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
   (s12*(s12 + t)^2*(-mmH + s12 + t)) - 
  (4*(2*s12 + 3*t)*canMI[3, 1, {s12, mmH - s12 - t, mmH}]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[4 - mmH + s12 + t, 1/2])/
   ((mmH - s12 - t)*t*(s12 + t)^2) + 
  (2*(-2*mmH*s12 + 2*s12^2 + 2*s12*t + (-4 + t)*t)*
    canMI[9, 2, {s12, mmH - s12 - t, mmH}]*myRoot[-s12, 1/2]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[mmH*s12 - s12^2 + 4*t - s12*t, 1/2])/
   (s12*t^2*(-mmH + s12 + t)*(-(mmH*s12) + s12^2 - 4*t + s12*t)) + 
  (2*(s12^2 + 2*s12*(-2 + t) + 2*t*(-mmH + t))*
    canMI[9, 2, {mmH - s12 - t, t, mmH}]*myRoot[-t, 1/2]*
    myRoot[-mmH + s12 + t, 1/2]*myRoot[-(s12*(-4 + t)) + (mmH - t)*t, 1/2])/
   (s12^2*t*(-mmH + s12 + t)*(s12*(-4 + t) + t*(-mmH + t)))}
