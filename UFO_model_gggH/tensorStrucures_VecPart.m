(* Created with the Wolfram Language : www.wolfram.com *)
{tensStruct[1] -> -((s23*vector[p1, mu[-3]] - s13*vector[p2, mu[-3]])*
     (s12*g[mu[-2], mu[-1]] - 2*vector[p1, mu[-2]]*vector[p2, mu[-1]]))/
   (2*s23), tensStruct[2] -> 
  -((s23*g[mu[-3], mu[-2]] - 2*vector[p2, mu[-3]]*vector[p3, mu[-2]])*
     (s13*vector[p2, mu[-1]] - s12*vector[p3, mu[-1]]))/(2*s13), 
 tensStruct[3] -> -((s23*vector[p1, mu[-2]] - s12*vector[p3, mu[-2]])*
     (s13*g[mu[-3], mu[-1]] - 2*vector[p1, mu[-3]]*vector[p3, mu[-1]]))/
   (2*s23), tensStruct[4] -> 
  (g[mu[-2], mu[-1]]*(s23*vector[p1, mu[-3]] - s13*vector[p2, mu[-3]]) + 
    s13*g[mu[-3], mu[-2]]*vector[p2, mu[-1]] - 2*vector[p1, mu[-3]]*
     vector[p2, mu[-1]]*vector[p3, mu[-2]] + g[mu[-3], mu[-1]]*
     (-(s23*vector[p1, mu[-2]]) + s12*vector[p3, mu[-2]]) - 
    s12*g[mu[-3], mu[-2]]*vector[p3, mu[-1]] + 2*vector[p1, mu[-2]]*
     vector[p2, mu[-3]]*vector[p3, mu[-1]])/2}
