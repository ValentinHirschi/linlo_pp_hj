      subroutine resetGGHGEWCache()
            implicit none
C Cache
            include 'gghgEW_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_GGHGEW(p, pmassA, pmassB, 
     &    ewrealsRe, ewrealsIm,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision P(0:3,3)
          double precision pmassA, pmassB
          logical FOUNDIT
          double precision ewrealsRe(4)
          double precision ewrealsIm(4)
C Local
          integer i,j, cache_index
C Cache
          include 'gghgEW_cache.inc'
                   
          FOUNDIT = .False.
       
          SEARCHLOOP : do cache_index=1,curr_cache_size
            if ( .NOT.(
     &       abs(pmassA-key_MAewreals(cache_index)) .lt. tol_EWREALS ) 
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(pmassB-key_MBewreals(cache_index)) .lt. tol_EWREALS ) 
     &         ) then
             cycle SEARCHLOOP
            endif
            do i=0,3
              do j=1,3
                if ( .NOT.(
     &     abs(P(i,j)-key_Pewreals(cache_index,i,j)) .lt. tol_EWREALS) 
     &         ) then
                  cycle SEARCHLOOP
                endif
              enddo
            enddo
            FOUNDIT = .True.
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,4
              ewrealsRe(i) = value_ewrealsRe(cache_index,i)
              ewrealsIm(i) = value_ewrealsIm(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP
       
      end subroutine ACCESS_CACHE_GGHGEW     

      subroutine ADD_TO_CACHE_GGHGEW(p, pmassA, pmassB, 
     &    ewrealsRe, ewrealsIm)
          implicit none
C Arguments
C We only consider the gluon momenta
          double precision P(0:3,3)
          double precision pmassA, pmassB
          double precision ewrealsRe(4)
          double precision ewrealsIm(4)
C Local
          integer i,j,cache_index
C Cache
          include 'gghgEW_cache.inc'
 
          cache_index = MOD(curr_cache_size,max_cache_EWREALs)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = MIN(curr_cache_size + 1,max_cache_EWREALs)         
          do i=0,3
            do j=1,3
              key_Pewreals(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MAewreals(cache_index)=pmassA
          key_MBewreals(cache_index)=pmassB
          do i=1,4
            value_ewrealsRe(cache_index,i)=ewrealsRe(i)
            value_ewrealsIm(cache_index,i)=ewrealsIm(i)
          enddo

      end subroutine ADD_TO_CACHE_GGHGEW   



      subroutine set2LoopGGHGEWZZCoefficients(P) 
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision ewrealsRe(4) 
          double precision ewrealsIm(4)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save ewrealsRe
          save ewrealsIm
          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo


          CALL ACCESS_CACHE_GGHGEW(P, MDL_MH, MDL_MZ, 
     &                      ewrealsRe, ewrealsIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 2-loop tensor for Z exchange'
             call get_gggh_tensor_coefs_ew(PGGG,MDL_MH,MDL_MZ,
     &     ewrealsRe,ewrealsIm)
             CALL ADD_TO_CACHE_GGHGEW(P,MDL_MH, MDL_MZ, 
     &                         ewrealsRe, ewrealsIm)
          endif     
!         Update couplings
          MDL_GGGHEWZZ_ForFac1_RE  = real(ewrealsRe(1) ,16)
          MDL_GGGHEWZZ_ForFac2_RE  = real(ewrealsRe(2) ,16)
          MDL_GGGHEWZZ_ForFac3_RE  = real(ewrealsRe(3) ,16)
          MDL_GGGHEWZZ_ForFac4_RE  = real(ewrealsRe(4) ,16)
          MDL_GGGHEWZZ_ForFac1_IM  = real(ewrealsIm(1) ,16)
          MDL_GGGHEWZZ_ForFac2_IM  = real(ewrealsIm(2) ,16)
          MDL_GGGHEWZZ_ForFac3_IM  = real(ewrealsIm(3) ,16)
          MDL_GGGHEWZZ_ForFac4_IM  = real(ewrealsIm(4) ,16)
          call COUP()
      end subroutine set2LoopGGHGEWZZCoefficients


      subroutine set2LoopGGHGEWWWCoefficients(P) 
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision ewrealsRe(4) 
          double precision ewrealsIm(4)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save ewrealsRe
          save ewrealsIm
          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo


          CALL ACCESS_CACHE_GGHGEW(P, MDL_MH, MDL_MW, 
     &                      ewrealsRe, ewrealsIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 2-loop tensor for Z exchange'
            call get_gggh_tensor_coefs_ew(PGGG,MDL_MH,MDL_MW,
     &     ewrealsRe,ewrealsIm)
            CALL ADD_TO_CACHE_GGHGEW(P,MDL_MH, MDL_MW, 
     &                         ewrealsRe, ewrealsIm)
          endif     
  !         Update couplings
          MDL_GGGHEWWW_ForFac1_RE  = real(ewrealsRe(1) ,16)
          MDL_GGGHEWWW_ForFac2_RE  = real(ewrealsRe(2) ,16)
          MDL_GGGHEWWW_ForFac3_RE  = real(ewrealsRe(3) ,16)
          MDL_GGGHEWWW_ForFac4_RE  = real(ewrealsRe(4) ,16)
          MDL_GGGHEWWW_ForFac1_IM  = real(ewrealsIm(1) ,16)
          MDL_GGGHEWWW_ForFac2_IM  = real(ewrealsIm(2) ,16)
          MDL_GGGHEWWW_ForFac3_IM  = real(ewrealsIm(3) ,16)
          MDL_GGGHEWWW_ForFac4_IM  = real(ewrealsIm(4) ,16)
          call COUP()
      end subroutine set2LoopGGHGEWWWCoefficients

      subroutine setGGHGEWWW(P)
        implicit none
        include 'coupl.inc'
        include 'input.inc'
        double precision P(0:3,3)
        ! Set all relevant couplings to 0
        MDL_GGGHEWZZ_ForFac1_RE  = 0
        MDL_GGGHEWZZ_ForFac2_RE  = 0
        MDL_GGGHEWZZ_ForFac3_RE  = 0
        MDL_GGGHEWZZ_ForFac4_RE  = 0
        MDL_GGGHEWZZ_ForFac1_IM  = 0
        MDL_GGGHEWZZ_ForFac2_IM  = 0
        MDL_GGGHEWZZ_ForFac3_IM  = 0
        MDL_GGGHEWZZ_ForFac4_IM  = 0
        MDL_GGGHEWWW_ForFac1_RE  = 0
        MDL_GGGHEWWW_ForFac2_RE  = 0
        MDL_GGGHEWWW_ForFac3_RE  = 0
        MDL_GGGHEWWW_ForFac4_RE  = 0
        MDL_GGGHEWWW_ForFac1_IM  = 0
        MDL_GGGHEWWW_ForFac2_IM  = 0
        MDL_GGGHEWWW_ForFac3_IM  = 0
        MDL_GGGHEWWW_ForFac4_IM  = 0
        CALL COUP()
        ! update the WW couplings
        set2LoopGGHGEWWWCoefficients(P)
      end subroutine setGGHGEWWW

      subroutine setGGHGEWZZ(P)
        implicit none
        include 'coupl.inc'
        include 'input.inc'
        double precision P(0:3,3)
        ! Set all relevant couplings to 0
        MDL_GGGHEWZZ_ForFac1_RE  = 0
        MDL_GGGHEWZZ_ForFac2_RE  = 0
        MDL_GGGHEWZZ_ForFac3_RE  = 0
        MDL_GGGHEWZZ_ForFac4_RE  = 0
        MDL_GGGHEWZZ_ForFac1_IM  = 0
        MDL_GGGHEWZZ_ForFac2_IM  = 0
        MDL_GGGHEWZZ_ForFac3_IM  = 0
        MDL_GGGHEWZZ_ForFac4_IM  = 0
        MDL_GGGHEWWW_ForFac1_RE  = 0
        MDL_GGGHEWWW_ForFac2_RE  = 0
        MDL_GGGHEWWW_ForFac3_RE  = 0
        MDL_GGGHEWWW_ForFac4_RE  = 0
        MDL_GGGHEWWW_ForFac1_IM  = 0
        MDL_GGGHEWWW_ForFac2_IM  = 0
        MDL_GGGHEWWW_ForFac3_IM  = 0
        MDL_GGGHEWWW_ForFac4_IM  = 0
        CALL COUP()
        ! update the ZZ couplings
        set2LoopGGHGEWZZCoefficients(P)
      end subroutine setGGHGEWZZ
      
      subroutine setGGHGEW(P)
        implicit none
        include 'coupl.inc'
        include 'input.inc'
        double precision P(0:3,3)
        ! Set all relevant couplings to 0
        MDL_GGGHEWZZ_ForFac1_RE  = 0
        MDL_GGGHEWZZ_ForFac2_RE  = 0
        MDL_GGGHEWZZ_ForFac3_RE  = 0
        MDL_GGGHEWZZ_ForFac4_RE  = 0
        MDL_GGGHEWZZ_ForFac1_IM  = 0
        MDL_GGGHEWZZ_ForFac2_IM  = 0
        MDL_GGGHEWZZ_ForFac3_IM  = 0
        MDL_GGGHEWZZ_ForFac4_IM  = 0
        MDL_GGGHEWWW_ForFac1_RE  = 0
        MDL_GGGHEWWW_ForFac2_RE  = 0
        MDL_GGGHEWWW_ForFac3_RE  = 0
        MDL_GGGHEWWW_ForFac4_RE  = 0
        MDL_GGGHEWWW_ForFac1_IM  = 0
        MDL_GGGHEWWW_ForFac2_IM  = 0
        MDL_GGGHEWWW_ForFac3_IM  = 0
        MDL_GGGHEWWW_ForFac4_IM  = 0
        CALL COUP()
        ! update the ALL couplings
        set2LoopGGHGEWZZCoefficients(P)
        set2LoopGGHGEWWCoefficients(P)
      end subroutine setGGHGEW

