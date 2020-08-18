      subroutine resetGGHHEFTCache()
            implicit none
C Cache
            include 'gghHEFT_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_GGHHEFT(pmassA, pmassB, 
     &    HEFTTensorRe, HEFTTensorIm,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision pmassA, pmassB
          logical FOUNDIT
          double precision HEFTTensorRe(2)
          double precision HEFTTensorIm(2)
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
            FOUNDIT = .True.
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,2
              HEFTTensorRe(i) = value_HEFTTensorRe(cache_index,i)
              HEFTTensorIm(i) = value_HEFTTensorIm(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP
       
      end subroutine      

      subroutine ADD_TO_CACHE_GGHHEFT(pmassA, pmassB, 
     &    HEFTTensorRe, HEFTTensorIm)
          implicit none
C Arguments
          double precision pmassA, pmassB
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
          do i=1,2
            value_HEFTTensorRe(cache_index,i)=HEFTTensorRe(i)
            value_HEFTTensorIm(cache_index,i)=HEFTTensorIm(i)
          enddo

      end subroutine      



      subroutine set1LoopGGHHEFTCoeffs(mH,muR) 
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision HEFTTensorRe(2) 
          double precision HEFTTensorIm(2)
          double precision mH
          double precision muR
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save HEFTTensorRe
          save HEFTTensorIm



          CALL ACCESS_CACHE_GGHHEFT(mH, muR, 
     &                      HEFTTensorRe, HEFTTensorIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing it GGVVAMP'
             call get_ggh_heft_coefs_fortran(mH,muR,
     &     HEFTTensorRe,HEFTTensorIm)
             CALL ADD_TO_CACHE_GGHHEFT(mH, muR, 
     &                         HEFTTensorRe, HEFTTensorIm)
          endif     
!         Update couplings
          MDL_GGH_HEFT1L_EPM1_RE  = real(HEFTTensorRe(1) ,16)
          MDL_GGH_HEFT1L_EP0_RE  = real(HEFTTensorRe(2) ,16)
          MDL_GGH_HEFT1L_EPM1_IM  = real(HEFTTensorIm(1) ,16)
          MDL_GGH_HEFT1L_EP0_IM  = real(HEFTTensorIm(2) ,16)
          call COUP()
      end subroutine set1LoopGGHHEFTCoeffs
