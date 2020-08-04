      subroutine resetGGHGQCDLOCache()
            implicit none
C Cache
            include 'gghgQCDLO_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE(p, pmassA, pmassB, 
     &    oneLoopTensorRe, oneLoopTensorIm,
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
      
      subroutine set1LoopGGHGQCDCoefficients(P,mH,mT) 
        include 'coupl.inc'

            double precision P(16)
            double precision oneLoopTensorRe(4) 
            double precision oneLoopTensorIm(4)
            double precision mH, mT
            ! ask val why we save
            save oneLoopTensorRe
            save oneLoopTensorIm

            call get_gggh_tensor_coefs_fortran(P,mT,mH,
     &     oneLoopTensorRe,oneLoopTensorIm)
!         Update couplings
            MD_GGGH_ForFac1_RE  = real(oneLoopTensorRe(1) ,16)
            MD_GGGH_ForFac2_RE  = real(oneLoopTensorRe(2) ,16)
            MD_GGGH_ForFac3_RE  = real(oneLoopTensorRe(3) ,16)
            MD_GGGH_ForFac4_RE  = real(oneLoopTensorRe(4) ,16)
            MD_GGGH_ForFac1_IM  = real(oneLoopTensorIm(1) ,16)
            MD_GGGH_ForFac2_IM  = real(oneLoopTensorIm(2) ,16)
            MD_GGGH_ForFac3_IM  = real(oneLoopTensorIm(3) ,16)
            MD_GGGH_ForFac4_IM  = real(oneLoopTensorIm(4) ,16)
            call COUP()

      end subroutine set1LoopGGHGQCDCoefficients
