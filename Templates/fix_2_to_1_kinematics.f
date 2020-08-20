      IF ((NINCOMING.EQ.2).AND.((NEXTERNAL - NINCOMING .EQ.1)))
     $  THEN
        IF (PMASS(3).EQ.0.0D0) THEN
            STOP 'Cannot generate 2>1 kin. config. with m3=0.0d0'
        ELSE
C        deal with the case of only one particle in the final
C        state
            P(0,1) = PMASS(3)/2D0
            P(1,1) = 0D0
            P(2,1) = 0D0
            P(3,1) = PMASS(3)/2D0
            IF (PMASS(1).GT.0D0) THEN
                P(3,1) = DSQRT(PMASS(3)**2/4D0 - PMASS(1)**2)
            ENDIF
            P(0,2) = PMASS(3)/2D0
            P(1,2) = 0D0
            P(2,2) = 0D0
            P(3,2) = -PMASS(3)/2D0
            IF (PMASS(2) > 0D0) THEN
                P(3,2) = -DSQRT(PMASS(3)**2/4D0 - PMASS(1)**2)
            ENDIF
            P(0,3) = PMASS(3)
            P(1,3) = 0D0
            P(2,3) = 0D0
            P(3,3) = 0D0
        ENDIF
      ELSE
        CALL GET_MOMENTA(SQRTS,PMASS,P)
      ENDIF