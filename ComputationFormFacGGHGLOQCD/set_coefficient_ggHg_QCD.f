      subroutine resetGGHGQCDLOCache()
            implicit none
C Cache
            include 'gghgQCDLO_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_GGHGQCDLO(p, pmassA, pmassB, 
     &    oneLoopTensorRe, oneLoopTensorIm,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision P(0:3,3)
          double precision pmassA, pmassB
          logical FOUNDIT
          double precision oneLoopTensorRe(4)
          double precision oneLoopTensorIm(4)
C Local
          integer i,j, cache_index
C Cache
          include 'gghgQCDLO_cache.inc'
                   
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
              do j=1,3
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
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,4
              oneLoopTensorRe(i) = value_oneLoopTensorRe(cache_index,i)
              oneLoopTensorIm(i) = value_oneLoopTensorIm(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP
       
      end subroutine      

      subroutine ADD_TO_CACHE_GGHGQCDLO(p, pmassA, pmassB, 
     &    oneLoopTensorRe, oneLoopTensorIm)
          implicit none
C Arguments
C We only consider the gluon momenta
          double precision P(0:3,3)
          double precision pmassA, pmassB
          double precision oneLoopTensorRe(4)
          double precision oneLoopTensorIm(4)
C Local
          integer i,j,cache_index
C Cache
          include 'gghgQCDLO_cache.inc'
 
          cache_index = MOD(curr_cache_size,max_cache_size)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = MIN(curr_cache_size + 1,max_cache_size)          
          do i=0,3
            do j=1,3
              key_P(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MA(cache_index)=pmassA
          key_MB(cache_index)=pmassB
          do i=1,4
            value_oneLoopTensorRe(cache_index,i)=oneLoopTensorRe(i)
            value_oneLoopTensorIm(cache_index,i)=oneLoopTensorIm(i)
          enddo

      end subroutine      



      subroutine set1LoopGGHGQCDLOCoefficients(P) 
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision oneLoopTensorRe(4) 
          double precision oneLoopTensorIm(4)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save oneLoopTensorRe
          save oneLoopTensorIm
          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo


          CALL ACCESS_CACHE_GGHGQCDLO(P, MDL_MH, MDL_MT, 
     &                      oneLoopTensorRe, oneLoopTensorIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing it GGVVAMP'
             call %(C_prefix)sget_gggh_tensor_coefs_fortran(PGGG,MDL_MH,MDL_MT,
     &     oneLoopTensorRe,oneLoopTensorIm)
             CALL ADD_TO_CACHE_GGHGQCDLO(P,MDL_MH, MDL_MT, 
     &                         oneLoopTensorRe, oneLoopTensorIm)
          endif     
!         Update couplings
          MDL_GGGHQCD_ForFac1_RE  = real(oneLoopTensorRe(1) ,16)
          MDL_GGGHQCD_ForFac2_RE  = real(oneLoopTensorRe(2) ,16)
          MDL_GGGHQCD_ForFac3_RE  = real(oneLoopTensorRe(3) ,16)
          MDL_GGGHQCD_ForFac4_RE  = real(oneLoopTensorRe(4) ,16)
          MDL_GGGHQCD_ForFac1_IM  = real(oneLoopTensorIm(1) ,16)
          MDL_GGGHQCD_ForFac2_IM  = real(oneLoopTensorIm(2) ,16)
          MDL_GGGHQCD_ForFac3_IM  = real(oneLoopTensorIm(3) ,16)
          MDL_GGGHQCD_ForFac4_IM  = real(oneLoopTensorIm(4) ,16)
          call COUP()
      end subroutine set1LoopGGHGQCDLOCoefficients
