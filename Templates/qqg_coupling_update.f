

      !   We expect that all vertices are implemented in the form FI,FO,V,S
      ! For couplings we need only the gloun momenta
      IF (DBLE(F1(1)).lt.0.0d0) THEN
        pin(0,1) = F1(1)
        pin(1,1) = F1(2)
        pin(2,1) = F1(3)
        pin(3,1) = F1(4)
      ELSE
        pin(0,1) = -F1(1)
        pin(1,1) = -F1(2)
        pin(2,1) = -F1(3)
        pin(3,1) = -F1(4)
      ENDIF
      IF (DBLE(F2(1)).lt.0.0d0) THEN
        pin(0,2) = -F2(1)
        pin(1,2) = -F2(2)
        pin(2,2) = -F2(3)
        pin(3,2) = -F2(4)
      ELSE
        pin(0,2) = F2(1)
        pin(1,2) = F2(2)
        pin(2,2) = F2(3)
        pin(3,2) = F2(4)
      ENDIF
      IF (DBLE(V3(1)).lt.0.0d0) THEN
        pin(0,3) =-V3(1)
        pin(1,3) =-V3(2)
        pin(2,3) =-V3(3)
        pin(3,3) =-V3(4)
      ELSE
        pin(0,3) =V3(1)
        pin(1,3) =V3(2)
        pin(2,3) =V3(3)
        pin(3,3) =V3(4)
      ENDIF


      
