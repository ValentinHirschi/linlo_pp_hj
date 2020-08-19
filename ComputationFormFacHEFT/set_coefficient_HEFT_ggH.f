      subroutine resetGGHHEFTCache()
            implicit none
C Cache
            include 'gghHEFT_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C
      subroutine ACCESS_CACHE_GGHHEFT(pmassA, pmassB, nloops, eps,
     &    HEFTLO, HEFTTensorRe, HEFTTensorIm,
     &    FOUNDIT)

          implicit none
C Arguments
          double precision pmassA, pmassB, nloops, eps, HEFTLO
          double precision HEFTTensorRe(3)
          double precision HEFTTensorIm(3)
          logical FOUNDIT
          
C Local
          integer i,j, cache_index
C Cache
          include 'gghHEFT_cache.inc'

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
            ! cycle loops
            if (
     &       ( abs(nloops-key_NLOOPS(cache_index)) .lt. cache_tolerance ))
     &         ) then
             cycle SEARCHLOOP
            endif
            ! cycle epsorders
            if (
     &       ( abs(eps-key_EPS(cache_index)) .lt. cache_tolerance ))
     &         ) then
             cycle SEARCHLOOP
            endif
            FOUNDIT = .True.
            write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,3
              HEFTTensorRe(i) = value_HEFTTensorRe(cache_index,i)
              HEFTTensorIm(i) = value_HEFTTensorIm(cache_index,i)
            enddo
            HEFTLO = value_HEFTLO
            exit SEARCHLOOP
          enddo SEARCHLOOP

      end subroutine

      subroutine ADD_TO_CACHE_GGHHEFT(pmassA, pmassB,
     &    nloops, eps, HEFTLO
     &    HEFTTensorRe, HEFTTensorIm)
          implicit none
C Arguments
          double precision pmassA, pmassB, nloops, eps, HEFTLO
          double precision HEFTTensorRe(2)
          double precision HEFTTensorIm(2)
C Local
          integer i,j,cache_index
C Cache
          include 'gghHEFT_cache.inc'

          cache_index = MOD(curr_cache_size,max_cache_size)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = curr_cache_size + 1
          key_MA(cache_index)=pmassA
          key_MB(cache_index)=pmassB
          key_NLOOPS = nloops
          key_EPS = eps
          value_HEFTLO = HEFTLO
          do i=1,3
            value_HEFTTensorRe(cache_index,i)=HEFTTensorRe(i)
            value_HEFTTensorIm(cache_index,i)=HEFTTensorIm(i)
          enddo

      end subroutine



      subroutine set1LoopGGHHEFTCoeffs(mH,muR,nloops,eps)
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision HEFTTensorRe(2)
          double precision HEFTTensorIm(2)
          double precision mH , nloops
          double precision muR, eps
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save HEFTTensorRe
          save HEFTTensorIm
          save HEFTLO

          mH = MDL_MH
          muR =MU_R
          nloops = MDL_n_loops_HEFT
          eps = MDL_eps_order_HEFT

          CALL ACCESS_CACHE_GGHHEFT(mH, muR,nloops,eps,HEFTLO
     &                      HEFTTensorRe, HEFTTensorIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
            Write(*,*) 'Recomputing it'
            if ((int(nloops).EQ.0) .and. (.NOT.(int(eps).EQ.0))
     &       ) THEN
              WRITE(*,*) 'EPS-ORDER DOES NOT EXIST'
              Write (*,*) 'LOOPS', nloops
              write(*,*) 'EPS-ORDER', eps
              call abort()
            endif


            if (int(nloops).EQ.0) THEN
              HEFTLO =1.0
              do i=1,3
                ! set NLO to 0
                HEFTTensorRe(i) = 0
                HEFTTensorIm(i) = 0
              enddo
            else
              HEFTLO = 0
              call get_ggh_heft_coefs_fortran(mH,muR,
     &                    HEFTTensorRe,HEFTTensorIm)
              if (int(eps).EQ.0) THEN
                ! set poles to 0
                do i=1,2
                  HEFTTensorRe(i) =0
                  HEFTTensorIm(i) =0
                enddo
              endif
              if (int(eps).EQ.-1) THEN
                ! set poles 1/eps^2 and eps^0 to 0
                  HEFTTensorRe(1) =0
                  HEFTTensorIm(1) =0
                  HEFTTensorRe(3) =0
                  HEFTTensorIm(3) =0                
              endif
              if (int(eps).EQ.-2) THEN
                ! set poles 1/eps and eps^0 to 0
                  HEFTTensorRe(2) =0
                  HEFTTensorIm(2) =0
                  HEFTTensorRe(3) =0
                  HEFTTensorIm(3) =0                
              endif
          ! NOW WE UPDATE
          
             CALL ADD_TO_CACHE_GGHHEFT(mH,muR,nloops,eps,
     &                    HEFTLO, HEFTTensorRe, HEFTTensorIm)
          endif
!         Update couplings
          MDL_GGH_HEFT_LO = HEFTLO

          MDL_GGH_HEFT1L_EPM2_RE  = real(HEFTTensorRe(1) ,16)
          MDL_GGH_HEFT1L_EPM1_RE  = real(HEFTTensorRe(2) ,16)
          MDL_GGH_HEFT1L_EP0_RE  = real(HEFTTensorRe(3) ,16)

          MDL_GGH_HEFT1L_EPM1_IM  = real(HEFTTensorIm(2) ,16)
          MDL_GGH_HEFT1L_EP0_IM  = real(HEFTTensorIm(3) ,16)
          call COUP()
      end subroutine set1LoopGGHHEFTCoeffs
