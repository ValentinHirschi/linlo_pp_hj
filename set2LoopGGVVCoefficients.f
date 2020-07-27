      subroutine resetGGVVCache()
          implicit none

C Cache
          include 'ggvv_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
          curr_cache_size = 0

      end subroutine

      subroutine ACCESS_CACHE(p, pmassA, pmassB, 
     &    oneLoopTensorRe, oneLoopTensorIm,
     &    twoLoopTensorRe, twoLoopTensorIm,
     &    FOUNDIT)
          implicit none
C Arguments
          double precision P(0:3,4)
          double precision pmassA, pmassB
          logical FOUNDIT
          double precision oneLoopTensorRe(20)
          double precision oneLoopTensorIm(20)
          double precision twoLoopTensorRe(20)
          double precision twoLoopTensorIm(20)
C Local
          integer i,j, cache_index
C Cache
          include 'ggvv_cache.inc'
            
          FOUNDIT = .False.

          SEARCHLOOP : do cache_index=1,curr_cache_size
            if (.NOT.( ( ( abs(pmassA+key_MA(cache_index)).eq.0.0d0 ).and.
     &           ( ( abs(pmassA-key_MA(cache_index))/
     &               abs(pmassA+key_MA(cache_index)) )
     &               .lt.cache_tolerance ) ) .or.
     &           ( abs(pmassA-key_MA(cache_index)) .lt. cache_tolerance ) ) 
     &         ) then
              cycle SEARCHLOOP
            endif
            if (.NOT.( ( ( abs(pmassB+key_MB(cache_index)).gt.0.0d0 ).and.
     &           ( ( abs(pmassB-key_MB(cache_index))/
     &               abs(pmassB+key_MB(cache_index)) )
     &               .lt.cache_tolerance ) ) .or.
     &           ( abs(pmassB-key_MB(cache_index)) .lt. cache_tolerance ) )
     &         ) then
             cycle SEARCHLOOP
            endif
            do i=0,3
              do j=1,4
                if (.NOT.( ( ( abs(P(i,j)+key_P(cache_index,i,j)).gt.0.0d0 ).and.
     &           ( ( abs(P(i,j)-key_P(cache_index,i,j))/
     &               abs(P(i,j)+key_P(cache_index,i,j)) )
     &               .lt.cache_tolerance ) ) .or.
     &           ( abs(P(i,j)-key_P(cache_index,i,j)) .lt. cache_tolerance ) )
     &         ) then
                  cycle SEARCHLOOP
                endif
              enddo
            enddo
            FOUNDIT = .True.
c            write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,20
              oneLoopTensorRe(i) = value_oneLoopTensorRe(cache_index,i)
              oneLoopTensorIm(i) = value_oneLoopTensorIm(cache_index,i)
              twoLoopTensorRe(i) = value_twoLoopTensorRe(cache_index,i)
              twoLoopTensorIm(i) = value_twoLoopTensorIm(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP

      end subroutine

      subroutine ADD_TO_CACHE(p, pmassA, pmassB, 
     &    oneLoopTensorRe, oneLoopTensorIm,
     &    twoLoopTensorRe, twoLoopTensorIm)
          implicit none
C Arguments
          double precision P(0:3,4)
          double precision pmassA, pmassB
          double precision oneLoopTensorRe(20)
          double precision oneLoopTensorIm(20)
          double precision twoLoopTensorRe(20)
          double precision twoLoopTensorIm(20)
C Local
          integer i,j,cache_index
C Cache
          include 'ggvv_cache.inc'
 
          cache_index = MOD(curr_cache_size,max_cache_size)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = curr_cache_size + 1          
          do i=0,3
            do j=1,4
              key_P(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MA(cache_index)=pmassA
          key_MB(cache_index)=pmassB
          do i=1,20
            value_oneLoopTensorRe(cache_index,i)=oneLoopTensorRe(i)
            value_oneLoopTensorIm(cache_index,i)=oneLoopTensorIm(i)
            value_twoLoopTensorRe(cache_index,i)=twoLoopTensorRe(i)
            value_twoLoopTensorIm(cache_index,i)=twoLoopTensorIm(i)
          enddo

      end subroutine


      subroutine set2LoopGGVVCoefficients(P, pmass)
          implicit none

          include 'input.inc'
          include 'coupl.inc'
          INCLUDE 'mp_input.inc'

C Parameters
          double precision rPi
          parameter( rPi = 3.14159265358979323846d0 )

C Arguments
          double precision P(0:3,4)
          double precision pmass(4)

C Local
          integer i,j,k, GGVVNf, GGVV_NLOOPS
          integer ResidueToReturn
          double precision GGVVmuR, GGVVGs   
          double precision Prefactor
          double complex RenormalizationPrefactor
          double complex correctionFactor(-2:0)          
          double precision logA
          double precision oneLoopTensorRe(20)
          double precision oneLoopTensorIm(20)
          double precision twoLoopTensorRe(20)
          double precision twoLoopTensorIm(20)
          double precision s
          double precision CA, TF, beta0, deltaqt
          double complex Isoft(-2:0), Icoll(-2:0), Itot(-2:0)
          save oneLoopTensorRe
          save oneLoopTensorIm
          save twoLoopTensorRe
          save twoLoopTensorIm

          logical FOUNDIT

C ----------
C Begin code
C ----------
          
          GGVVNf          = nint(MDL_NMasslessQuarks)
          GGVV_NLOOPS     = nint(MDL_N_LOOPS)
          ResidueToReturn = nint(MDL_ResidueToReturn)
          
          GGVVmuR = MU_R 
          GGVVGs  = G

          CALL ACCESS_CACHE(p, pmass(3), pmass(4), 
     &                      oneLoopTensorRe, oneLoopTensorIm,
     &                      twoLoopTensorRe, twoLoopTensorIm,
     &                      FOUNDIT)
          
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing it GGVVAMP'
             call get_ggvv_tensor_coefs_no_thread(p,pmass(3),pmass(4),
     &         MDL_requiredRelativeAccuracy,GGVVNf, oneLoopTensorRe,
     &         oneLoopTensorIm,twoLoopTensorRe,twoLoopTensorIm)
             CALL ADD_TO_CACHE(p, pmass(3), pmass(4), 
     &                         oneLoopTensorRe, oneLoopTensorIm,
     &                         twoLoopTensorRe, twoLoopTensorIm)
          endif

          if (GGVV_NLOOPS.eq.1) then

C           When computing one-loop squared with this implementation
C           MadLoop will compute 2*Re(L L*) and not L L*, so we must bring in
C           a factor one-half
            Prefactor      = 0.5d0
            if (ResidueToReturn.eq.0) then
              MDL_GGVV_A1_RE = Prefactor*oneLoopTensorRe(1)
              MDL_GGVV_A1_IM = Prefactor*oneLoopTensorIm(1)
              MDL_GGVV_A2_RE = Prefactor*oneLoopTensorRe(2)
              MDL_GGVV_A2_IM = Prefactor*oneLoopTensorIm(2)
              MDL_GGVV_A3_RE = Prefactor*oneLoopTensorRe(3)
              MDL_GGVV_A3_IM = Prefactor*oneLoopTensorIm(3)
              MDL_GGVV_A4_RE = Prefactor*oneLoopTensorRe(4)
              MDL_GGVV_A4_IM = Prefactor*oneLoopTensorIm(4)
              MDL_GGVV_A5_RE = Prefactor*oneLoopTensorRe(5)
              MDL_GGVV_A5_IM = Prefactor*oneLoopTensorIm(5)
              MDL_GGVV_A6_RE = Prefactor*oneLoopTensorRe(6)
              MDL_GGVV_A6_IM = Prefactor*oneLoopTensorIm(6)
              MDL_GGVV_A7_RE = Prefactor*oneLoopTensorRe(7)
              MDL_GGVV_A7_IM = Prefactor*oneLoopTensorIm(7)
              MDL_GGVV_A8_RE = Prefactor*oneLoopTensorRe(8)
              MDL_GGVV_A8_IM = Prefactor*oneLoopTensorIm(8)
              MDL_GGVV_A9_RE = Prefactor*oneLoopTensorRe(9)
              MDL_GGVV_A9_IM = Prefactor*oneLoopTensorIm(9)
              MDL_GGVV_A10_RE = Prefactor*oneLoopTensorRe(10)
              MDL_GGVV_A10_IM = Prefactor*oneLoopTensorIm(10)
              MDL_GGVV_A11_RE = Prefactor*oneLoopTensorRe(11)
              MDL_GGVV_A11_IM = Prefactor*oneLoopTensorIm(11)
              MDL_GGVV_A12_RE = Prefactor*oneLoopTensorRe(12)
              MDL_GGVV_A12_IM = Prefactor*oneLoopTensorIm(12)
              MDL_GGVV_A13_RE = Prefactor*oneLoopTensorRe(13)
              MDL_GGVV_A13_IM = Prefactor*oneLoopTensorIm(13)
              MDL_GGVV_A14_RE = Prefactor*oneLoopTensorRe(14)
              MDL_GGVV_A14_IM = Prefactor*oneLoopTensorIm(14)
              MDL_GGVV_A15_RE = Prefactor*oneLoopTensorRe(15)
              MDL_GGVV_A15_IM = Prefactor*oneLoopTensorIm(15)
              MDL_GGVV_A16_RE = Prefactor*oneLoopTensorRe(16)
              MDL_GGVV_A16_IM = Prefactor*oneLoopTensorIm(16)
              MDL_GGVV_A17_RE = Prefactor*oneLoopTensorRe(17)
              MDL_GGVV_A17_IM = Prefactor*oneLoopTensorIm(17)
              MDL_GGVV_A18_RE = Prefactor*oneLoopTensorRe(18)
              MDL_GGVV_A18_IM = Prefactor*oneLoopTensorIm(18)
              MDL_GGVV_A19_RE = Prefactor*oneLoopTensorRe(19)
              MDL_GGVV_A19_IM = Prefactor*oneLoopTensorIm(19)
              MDL_GGVV_A20_RE = Prefactor*oneLoopTensorRe(20)
              MDL_GGVV_A20_IM = Prefactor*oneLoopTensorIm(20)
            else
              MDL_GGVV_A1_RE = 0.0d0
              MDL_GGVV_A1_IM = 0.0d0
              MDL_GGVV_A2_RE = 0.0d0
              MDL_GGVV_A2_IM = 0.0d0
              MDL_GGVV_A3_RE = 0.0d0
              MDL_GGVV_A3_IM = 0.0d0
              MDL_GGVV_A4_RE = 0.0d0
              MDL_GGVV_A4_IM = 0.0d0
              MDL_GGVV_A5_RE = 0.0d0
              MDL_GGVV_A5_IM = 0.0d0
              MDL_GGVV_A6_RE = 0.0d0
              MDL_GGVV_A6_IM = 0.0d0
              MDL_GGVV_A7_RE = 0.0d0
              MDL_GGVV_A7_IM = 0.0d0
              MDL_GGVV_A8_RE = 0.0d0
              MDL_GGVV_A8_IM = 0.0d0
              MDL_GGVV_A9_RE = 0.0d0
              MDL_GGVV_A9_IM = 0.0d0
              MDL_GGVV_A10_RE = 0.0d0
              MDL_GGVV_A10_IM = 0.0d0
              MDL_GGVV_A11_RE = 0.0d0
              MDL_GGVV_A11_IM = 0.0d0
              MDL_GGVV_A12_RE = 0.0d0
              MDL_GGVV_A12_IM = 0.0d0
              MDL_GGVV_A13_RE = 0.0d0
              MDL_GGVV_A13_IM = 0.0d0
              MDL_GGVV_A14_RE = 0.0d0
              MDL_GGVV_A14_IM = 0.0d0
              MDL_GGVV_A15_RE = 0.0d0
              MDL_GGVV_A15_IM = 0.0d0
              MDL_GGVV_A16_RE = 0.0d0
              MDL_GGVV_A16_IM = 0.0d0
              MDL_GGVV_A17_RE = 0.0d0
              MDL_GGVV_A17_IM = 0.0d0
              MDL_GGVV_A18_RE = 0.0d0
              MDL_GGVV_A18_IM = 0.0d0
              MDL_GGVV_A19_RE = 0.0d0
              MDL_GGVV_A19_IM = 0.0d0
              MDL_GGVV_A20_RE = 0.0d0
              MDL_GGVV_A20_IM = 0.0d0
            endif

          elseif (GGVV_NLOOPS.eq.2) then

C           We must also account for the extra alpha_s/(2pi) prefactor here
            Prefactor = DABS(GGVVGs**2/(8.0d0*(rPI**2)))
C           The coefficients are renormalized at mu**2 = s
C           so we must correct here for whatever value is asked for
            s = (p(0,1)+p(0,2))**2-(p(1,1)+p(1,2))**2
     &              -(p(2,1)+p(2,2))**2-(p(3,1)+p(3,2))**2
            CA = 3.0d0
            TF = 1.0d0/2.0d0
            beta0 = (11.0d0*CA-4.0d0*TF*GGVVNf)/6.0d0
            logA = log((GGVVmuR**2)/s)

c           --------------------------------------------------------------
c            Sign determined so as to cancel the O(\alpha_s) running of
c            the Born contribution (but independent check needed)
c           --------------------------------------------------------------
C           We must multiply by 0.5 because MadLoop will multiply this
C           against the one-loop with 2.0*Re(L L*) and not L L*
c           For now, keep the result renormalized at mu^2=s, so this
c           will not be used.
C           The factor 2.0 in the parenthesis is because the Born
C           squared ME factorizes \alpha_s^2, not \alpha_s.
            RenormalizationPrefactor = 
     &               0.5d0*(2.0d0*Prefactor*DCMPLX(beta0*logA,0.0d0))

C           And finally we must also add back the I-operator (integrated
C           counterterms) since the integrator will already account for
C           it and they have already been subtracted in the form factors
C           provided.
            deltaqt = 0.0d0
            Isoft(-2) = DCMPLX(-CA,0.0d0)
            Isoft(-1) = DCMPLX(-CA*logA,-rPI*CA)
            Isoft(0)  = CA*DCMPLX(-0.5d0*logA,-rPI)*logA
            Icoll(-2) = DCMPLX(0.0d0, 0.0d0)
            Icoll(-1) = DCMPLX(-beta0, 0.0d0)
            Icoll(0)  = DCMPLX(-beta0*logA, 0.0d0)

c           Now compute the general correction factor to multiply the LO
C           1-loop amplitude with:
            correctionFactor(-2) = Prefactor*(Isoft(-2)+Icoll(-2))
            correctionFactor(-1) = Prefactor*(Isoft(-1)+Icoll(-1))
            correctionFactor(0) = Prefactor*(Isoft(0)+Icoll(0))+
     &                          + RenormalizationPrefactor

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(1),oneLoopTensorIm(1)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(1),twoLoopTensorIm(1)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A1_RE, MDL_GGVV_A1_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(2),oneLoopTensorIm(2)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(2),twoLoopTensorIm(2)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A2_RE, MDL_GGVV_A2_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(3),oneLoopTensorIm(3)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(3),twoLoopTensorIm(3)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A3_RE, MDL_GGVV_A3_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(4),oneLoopTensorIm(4)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(4),twoLoopTensorIm(4)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A4_RE, MDL_GGVV_A4_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(5),oneLoopTensorIm(5)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(5),twoLoopTensorIm(5)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A5_RE, MDL_GGVV_A5_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(6),oneLoopTensorIm(6)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(6),twoLoopTensorIm(6)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A6_RE, MDL_GGVV_A6_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(7),oneLoopTensorIm(7)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(7),twoLoopTensorIm(7)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A7_RE, MDL_GGVV_A7_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(8),oneLoopTensorIm(8)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(8),twoLoopTensorIm(8)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A8_RE, MDL_GGVV_A8_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(9),oneLoopTensorIm(9)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(9),twoLoopTensorIm(9)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A9_RE, MDL_GGVV_A9_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(10),oneLoopTensorIm(10)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(10),twoLoopTensorIm(10)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A10_RE, MDL_GGVV_A10_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(11),oneLoopTensorIm(11)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(11),twoLoopTensorIm(11)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A11_RE, MDL_GGVV_A11_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(12),oneLoopTensorIm(12)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(12),twoLoopTensorIm(12)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A12_RE, MDL_GGVV_A12_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(13),oneLoopTensorIm(13)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(13),twoLoopTensorIm(13)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A13_RE, MDL_GGVV_A13_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(14),oneLoopTensorIm(14)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(14),twoLoopTensorIm(14)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A14_RE, MDL_GGVV_A14_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(15),oneLoopTensorIm(15)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(15),twoLoopTensorIm(15)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A15_RE, MDL_GGVV_A15_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(16),oneLoopTensorIm(16)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(16),twoLoopTensorIm(16)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A16_RE, MDL_GGVV_A16_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(17),oneLoopTensorIm(17)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(17),twoLoopTensorIm(17)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A17_RE, MDL_GGVV_A17_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(18),oneLoopTensorIm(18)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(18),twoLoopTensorIm(18)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A18_RE, MDL_GGVV_A18_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(19),oneLoopTensorIm(19)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(19),twoLoopTensorIm(19)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A19_RE, MDL_GGVV_A19_IM)

            CALL ConvertToMadLoopConventions(
     &          DCMPLX(oneLoopTensorRe(20),oneLoopTensorIm(20)),
     &          Prefactor*DCMPLX(twoLoopTensorRe(20),twoLoopTensorIm(20)),
     &          correctionFactor, ResidueToReturn, 
     &          MDL_GGVV_A20_RE, MDL_GGVV_A20_IM)

          else
            write(*,*) 'Error, nloop can only be either 1 or 2.'
            stop
          endif

C         Update MP_couplings
          MP__MDL_GGVV_A1_RE  = real(MDL_GGVV_A1_RE ,16)
          MP__MDL_GGVV_A1_IM  = real(MDL_GGVV_A1_IM ,16)
          MP__MDL_GGVV_A2_RE  = real(MDL_GGVV_A2_RE ,16)
          MP__MDL_GGVV_A2_IM  = real(MDL_GGVV_A2_IM ,16)
          MP__MDL_GGVV_A3_RE  = real(MDL_GGVV_A3_RE ,16)
          MP__MDL_GGVV_A3_IM  = real(MDL_GGVV_A3_IM ,16)
          MP__MDL_GGVV_A4_RE  = real(MDL_GGVV_A4_RE ,16)
          MP__MDL_GGVV_A4_IM  = real(MDL_GGVV_A4_IM ,16)
          MP__MDL_GGVV_A5_RE  = real(MDL_GGVV_A5_RE ,16)
          MP__MDL_GGVV_A5_IM  = real(MDL_GGVV_A5_IM ,16)
          MP__MDL_GGVV_A6_RE  = real(MDL_GGVV_A6_RE ,16)
          MP__MDL_GGVV_A6_IM  = real(MDL_GGVV_A6_IM ,16)
          MP__MDL_GGVV_A7_RE  = real(MDL_GGVV_A7_RE ,16)
          MP__MDL_GGVV_A7_IM  = real(MDL_GGVV_A7_IM ,16)
          MP__MDL_GGVV_A8_RE  = real(MDL_GGVV_A8_RE ,16)
          MP__MDL_GGVV_A8_IM  = real(MDL_GGVV_A8_IM ,16)
          MP__MDL_GGVV_A9_RE  = real(MDL_GGVV_A9_RE ,16)
          MP__MDL_GGVV_A9_IM  = real(MDL_GGVV_A9_IM ,16)
          MP__MDL_GGVV_A10_RE = real(MDL_GGVV_A10_RE,16)
          MP__MDL_GGVV_A10_IM = real(MDL_GGVV_A10_IM,16)
          MP__MDL_GGVV_A11_RE = real(MDL_GGVV_A11_RE,16)
          MP__MDL_GGVV_A11_IM = real(MDL_GGVV_A11_IM,16)
          MP__MDL_GGVV_A12_RE = real(MDL_GGVV_A12_RE,16)
          MP__MDL_GGVV_A12_IM = real(MDL_GGVV_A12_IM,16)
          MP__MDL_GGVV_A13_RE = real(MDL_GGVV_A13_RE,16)
          MP__MDL_GGVV_A13_IM = real(MDL_GGVV_A13_IM,16)
          MP__MDL_GGVV_A14_RE = real(MDL_GGVV_A14_RE,16)
          MP__MDL_GGVV_A14_IM = real(MDL_GGVV_A14_IM,16)
          MP__MDL_GGVV_A15_RE = real(MDL_GGVV_A15_RE,16)
          MP__MDL_GGVV_A15_IM = real(MDL_GGVV_A15_IM,16)
          MP__MDL_GGVV_A16_RE = real(MDL_GGVV_A16_RE,16)
          MP__MDL_GGVV_A16_IM = real(MDL_GGVV_A16_IM,16)
          MP__MDL_GGVV_A17_RE = real(MDL_GGVV_A17_RE,16)
          MP__MDL_GGVV_A17_IM = real(MDL_GGVV_A17_IM,16)
          MP__MDL_GGVV_A18_RE = real(MDL_GGVV_A18_RE,16)
          MP__MDL_GGVV_A18_IM = real(MDL_GGVV_A18_IM,16)
          MP__MDL_GGVV_A19_RE = real(MDL_GGVV_A19_RE,16)
          MP__MDL_GGVV_A19_IM = real(MDL_GGVV_A19_IM,16)
          MP__MDL_GGVV_A20_RE = real(MDL_GGVV_A20_RE,16)
          MP__MDL_GGVV_A20_IM = real(MDL_GGVV_A20_IM,16)

C         Update couplings
          CALL COUP()

      end subroutine set2LoopGGVVCoefficients

      subroutine ConvertToMadLoopConventions(
     &       VVAmp1Loop, VVAmp2Loop,
     &       correctionFactor, ResidueToReturn,
     &       result_real, result_complex)
          implicit None

          double precision rPi
          parameter( rPi =    3.14159265358979323846d0 )

C        This subroutine takes the fully expanded result from
C        VVAMPm, and apply the correctionFactor to add back the I
C        operator subtracted and re-instate the mu_r dependence,
C        returning in result_real and result_complex, the residue for
C        the pole selected with ResidueToReturn.

          double complex VVAmp1Loop, VVAmp2Loop
          double complex correctionFactor(-2:0)
          integer ResidueToReturn
          double precision result_real, result_complex

C         First compute the full VVAmp result
          if (ResidueToReturn.eq.0) then
              result_real = DBLE(VVAmp2Loop+correctionFactor(0)*VVAmp1Loop)
              result_complex = DIMAG(VVAmp2Loop+correctionFactor(0)*VVAmp1Loop)
          elseif (ResidueToReturn.eq.-1) then
              result_real = DBLE(correctionFactor(-1)*VVAmp1Loop)
              result_complex = DIMAG(correctionFactor(-1)*VVAmp1Loop)
          elseif (ResidueToReturn.eq.-2) then
              result_real = DBLE(correctionFactor(-2)*VVAmp1Loop)
              result_complex = DIMAG(correctionFactor(-2)*VVAmp1Loop)
          else
              stop 'GGVV :: The chosen residue to return can only be 0,-1 or -2.'
          endif
      end subroutine ConvertToMadLoopConventions
