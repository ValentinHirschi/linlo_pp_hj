            integer i
            double precision P(16)
            double precision oneLoopTensorRe(4), oneLoopTensorIm(4)
            double precision mH, mT
            mT=172
            mH=125
            P= (/ 0.500000000000000E+03,    0.000000000000000E+00,
     &      0.000000000000000E+00,    0.500000000000000E+03,
     &      0.500000000000000E+03,    0.000000000000000E+00,
     &      0.000000000000000E+00,   -0.500000000000000E+03,
     &      0.492187500000000E+03,   -0.109191092499398E+03,
     &      -0.437880308402370E+03,    0.196434915400709E+03,
     &      0.507812500000000E+03,    0.109191092499398E+03,
     &      0.437880308402370E+03,   -0.196434915400709E+03 /)

            call get_gggh_tensor_coefs_fortran(P,mT,mH,
     &     oneLoopTensorRe,oneLoopTensorIm)
          do i=1, size(oneLoopTensorIm) 
            write (*,*) "Re:", i, "Val:", oneLoopTensorRe(i)
          end do
          do i=1, size(oneLoopTensorIm) 
            write (*,*) "Im:", i, "Val:", oneLoopTensorIm(i)
          end do
      
        end