

      ! We expect that all vertices are implemented in the form FI,FO,V,S
      ! So we can deduce the corresponding channel using this information, 
      ! Then, the wavefunction with positive energy sign is the outoing one
      integer selected_channel

      IF (DBLE(V3(1)).gt.0.0d0) THEN
        ! q(p1) qbar(p2) -> h(p3) g(p4)
        selected_channel = 0
        pin(0,1) = -F1(1)
        pin(1,1) = -F1(2)
        pin(2,1) = -F1(3)
        pin(3,1) = -F1(4)
        pin(0,2) = -F2(1)
        pin(1,2) = -F2(2)
        pin(2,2) = -F2(3)
        pin(3,2) = -F2(4)
        pin(0,3) = -V3(1)
        pin(1,3) = -V3(2)
        pin(2,3) = -V3(3)
        pin(3,3) = -V3(4)
      ELSEIF (DBLE(F2(1)).gt.0.0d0) THEN
        ! q(p1) g(p2) -> h(p3) q(p4)
        selected_channel = 1
        pin(0,1) = -F1(1)
        pin(1,1) = -F1(2)
        pin(2,1) = -F1(3)
        pin(3,1) = -F1(4)
        pin(0,2) = -V3(1)
        pin(1,2) = -V3(2)
        pin(2,2) = -V3(3)
        pin(3,2) = -V3(4)
        pin(0,3) = -F2(1)
        pin(1,3) = -F2(2)
        pin(2,3) = -F2(3)
        pin(3,3) = -F2(4)
      ELSEIF (DBLE(F1(1)).gt.0.0d0) THEN
        ! qbar(p1) g(p2) -> h(p3) qbar(p4)
        selected_channel = 2
        pin(0,1) = -F2(1)
        pin(1,1) = -F2(2)
        pin(2,1) = -F2(3)
        pin(3,1) = -F2(4)
        pin(0,2) = -V3(1)
        pin(1,2) = -V3(2)
        pin(2,2) = -V3(3)
        pin(3,2) = -V3(4)
        pin(0,3) = -F1(1)
        pin(1,3) = -F1(2)
        pin(2,3) = -F1(3)
        pin(3,3) = -F1(4)
      ENDIF