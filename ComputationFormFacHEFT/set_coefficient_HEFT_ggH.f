      subroutine resetGGHHEFTCache()
            implicit none
C Cache
            include 'gghHEFT_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C
      subroutine ACCESS_CACHE_GGHHEFT(pmassA, pmassB, nloops, eps,
     &    HEFTLO, HEFTNLORe, HEFTNLOIm,
     &    FOUNDIT)

          implicit none
C Arguments
          double precision pmassA, pmassB, nloops, eps, HEFTLO
          double precision HEFTNLORe(3)
          double precision HEFTNLOIm(3)
          logical FOUNDIT
          
C Local
          integer i,j, cache_index
C Cache
          include 'gghHEFT_cache.inc'

          FOUNDIT = .False.

          SEARCHLOOP : do cache_index=1,curr_cache_size
            if ( .NOT.(
     &    abs(pmassA-key_MA_GGH(cache_index)) .lt. cache_tol_ggH_heft) 
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &     abs(pmassB-key_MB_GGH(cache_index)) .lt. cache_tol_ggH_heft) 
     &         ) then
             cycle SEARCHLOOP
            endif
            ! cycle loops
            if ( .NOT.(
     &   abs(nloops-key_NLOOPS(cache_index)) .lt. cache_tol_ggH_heft)
     &         ) then
             cycle SEARCHLOOP
            endif
            ! cycle epsorders
            if ( .NOT.(
     &    abs(eps-key_EPS(cache_index)) .lt. cache_tol_ggH_heft )
     &         ) then
             cycle SEARCHLOOP
            endif
            FOUNDIT = .True.
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,3
              HEFTNLORe(i) = value_HEFTNLORe(cache_index,i)
              HEFTNLOIm(i) = value_HEFTNLOIm(cache_index,i)
            enddo
            HEFTLO = value_HEFTLO(cache_index)
            exit SEARCHLOOP
          enddo SEARCHLOOP

      end subroutine

      subroutine ADD_TO_CACHE_GGHHEFT(pmassA, pmassB,
     &    nloops, eps, HEFTLO,
     &    HEFTNLORe, HEFTNLOIm)
          implicit none
C Arguments
          double precision pmassA, pmassB, nloops, eps, HEFTLO
          double precision HEFTNLORe(3)
          double precision HEFTNLOIm(3)
C Local
          integer i,j,cache_index
C Cache
          include 'gghHEFT_cache.inc'

          cache_index = MOD(curr_cache_size,max_cache_ggH_heft)+1
          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = MIN(curr_cache_size + 1,max_cache_ggH_heft)
          key_MA_GGH(cache_index)=pmassA
          key_MB_GGH(cache_index)=pmassB
          key_NLOOPS = nloops
          key_EPS = eps
          value_HEFTLO(cache_index) = HEFTLO
          do i=1,3
            value_HEFTNLORe(cache_index,i)=HEFTNLORe(i)
            value_HEFTNLOIm(cache_index,i)=HEFTNLOIm(i)
          enddo

      end subroutine



      subroutine set1LoopGGHHEFTCoeffs()
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision HEFTNLORe(3)
          double precision HEFTNLOIm(3)
          double precision mH , nloops
          double precision muR, eps
          double precision HEFTLO
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save HEFTNLORe
          save HEFTNLOIm
          save HEFTLO

          mH = MDL_MH
          muR =MU_R
          nloops = MDL_n_loops_HEFT
          eps = MDL_eps_order_HEFT

          CALL ACCESS_CACHE_GGHHEFT(mH, muR,nloops,eps,HEFTLO,
     &                      HEFTNLORe, HEFTNLOIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
            ! Write(*,*) 'Recomputing it'
            if ((int(nloops).EQ.0) .and. (.NOT.(int(eps).EQ.0))
     &       .or.(int(nloops).EQ.1) .and. (.NOT.(int(eps).LE.0))
     &      ) THEN
              WRITE(*,*) 'EPS-ORDER DOES NOT EXIST'
              Write (*,*) 'LOOPS', nloops
              write(*,*) 'EPS-ORDER', eps
              call abort()
            endif

            
            if (int(nloops).EQ.0) THEN
              HEFTLO =1.0d0  
              do i=1,3
                ! set NLO to 0
                HEFTNLORe(i) = 0
                HEFTNLOIm(i) = 0
              enddo
            endif
            if (int(nloops).NE.0) THEN
               HEFTLO = 1.0d0
              !  HEFTLO = 0
              call %(C_prefix)sget_ggh_heft_coefs_fortran(mH,muR,
     &                    HEFTNLORe,HEFTNLOIm)
              ! WRITE(*,*) "i GOT FROM C++"
              ! do i=1,3
              !   write(*,*) "Re", i, HEFTNLORe(i)
              !   write(*,*) "Im", i, HEFTNLOIm(i)
              ! enddo
              if (int(eps).EQ.0) THEN
                ! set poles to 0
                do i=1,2
                  HEFTNLORe(i) =0
                  HEFTNLOIm(i) =0
                enddo
              endif
              if (int(eps).EQ.-1) THEN
                ! set poles 1/eps^2 and eps^0 to 0
                  HEFTNLORe(1) =0
                  HEFTNLOIm(1) =0
                  HEFTNLORe(3) =0
                  HEFTNLOIm(3) =0                
              endif
              if (int(eps).EQ.-2) THEN
                ! set poles 1/eps and eps^0 to 0
                  HEFTNLORe(2) =0
                  HEFTNLOIm(2) =0
                  HEFTNLORe(3) =0
                  HEFTNLOIm(3) =0                
              endif
            endif
            ! write(*,*) "I SET STUFF TO 0"
            ! do i=1,3
            !   write(*,*) "Re", i, HEFTNLORe(i)
            !   write(*,*) "Im", i, HEFTNLOIm(i)
            ! enddo
          ! NOW WE UPDATE
          
             CALL ADD_TO_CACHE_GGHHEFT(mH,muR,nloops,eps,
     &                    HEFTLO, HEFTNLORe, HEFTNLOIm)
          endif
!         Update couplings
          MDL_GGH_HEFT_LO = HEFTLO
          !  write(*,*) "before update", MDL_GGH_HEFT1L_EP0_RE, MDL_GGH_HEFT1L_EP0_IM 
          
          MDL_GGH_HEFT1L_EPM2_RE  = real(HEFTNLORe(1) ,16)
          MDL_GGH_HEFT1L_EPM1_RE  = real(HEFTNLORe(2) ,16)
          MDL_GGH_HEFT1L_EP0_RE  = real(HEFTNLORe(3) ,16)
          ! eps^-2 is pure real
          MDL_GGH_HEFT1L_EPM1_IM  = real(HEFTNLOIm(2) ,16)
          MDL_GGH_HEFT1L_EP0_IM  = real(HEFTNLOIm(3) ,16)
          call COUP()
          ! write(*,*) "after update", MDL_GGH_HEFT1L_EP0_RE, MDL_GGH_HEFT1L_EP0_IM 
        end subroutine set1LoopGGHHEFTCoeffs
