      subroutine resetGGHGHEFTCache()
            implicit none
C Cache
            include 'gghgHEFT_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_GGHGHEFT(p, pmassA, 
     &    gghgHEFTTensor,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision P(0:3,3)
          double precision pmassA
          logical FOUNDIT
          double precision gghgHEFTTensor(4)
C Local
          integer i,j, cache_index
C Cache
          include 'gghgHEFT_cache.inc'
                   
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
              gghgHEFTTensor(i) = value_gghgHEFTTensor(cache_index,i)              
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP
       
      end subroutine      

      subroutine ADD_TO_CACHE_GGHGHEFT(p, pmassA, 
     &    gghgHEFTTensor)
          implicit none
C Arguments
C We only consider the gluon momenta
          double precision P(0:3,3)
          double precision pmassA
          double precision gghgHEFTTensor(4)
          
C Local
          integer i,j,cache_index
C Cache
          include 'gghgHEFT_cache.inc'
 
          cache_index = MOD(curr_cache_size,max_cache_size)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = curr_cache_size + 1          
          do i=0,3
            do j=1,3
              key_P(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MA(cache_index)=pmassA
          
          do i=1,4
            value_gghgHEFTTensor(cache_index,i)=gghgHEFTTensor(i)
          enddo

      end subroutine      



      subroutine setGGHGHEFTCoefficients(P) 
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision gghgHEFTTensor(4) 
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save gghgHEFTTensor
          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo


          CALL ACCESS_CACHE_GGHGHEFT(P, MDL_MH,
     &                      gghgHEFTTensor,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing it GGVVAMP'
             call get_gggh_heft_coefs_fortran(PGGG,MDL_MH,
     &     gghgHEFTTensor)
             CALL ADD_TO_CACHE_GGHGHEFT(P,MDL_MH,
     &                         gghgHEFTTensor)
          endif     
!         Update couplings
          MDL_GGGH_HEFT_ForFac1  = real(gghgHEFTTensor(1) ,16)
          MDL_GGGH_HEFT_ForFac2  = real(gghgHEFTTensor(2) ,16)
          MDL_GGGH_HEFT_ForFac3  = real(gghgHEFTTensor(3) ,16)
          MDL_GGGH_HEFT_ForFac4  = real(gghgHEFTTensor(4) ,16)
          call COUP()
      end subroutine setGGHGHEFTCoefficients
