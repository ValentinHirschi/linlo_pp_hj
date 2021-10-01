      subroutine resetGGHGCache()
            implicit none
C Cache
            include 'gghg_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_GGHG(identifier, p, pmassA, pmassB, 
     &    resRe, resIm,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision P(0:3,3)
          integer identifier
          double precision pmassA, pmassB
          logical FOUNDIT
          double precision resRe(4)
          double precision resIm(4)
C Local
          integer i,j, cache_index
C Cache
          include 'gghg_cache.inc'
                   
          FOUNDIT = .False.
       
          SEARCHLOOP : do cache_index=1,curr_cache_size
            if ( .NOT.(
     &       identifier.eq.key_id(cache_index) )
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(pmassA-key_MA(cache_index)) .lt. gghg_tol ) 
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(pmassB-key_MB(cache_index)) .lt. gghg_tol ) 
     &         ) then
             cycle SEARCHLOOP
            endif
            do i=0,3
              do j=1,3
                if ( .NOT.(
     &     abs(P(i,j)-key_P(cache_index,i,j)) .lt. gghg_tol ) 
     &         ) then
                  cycle SEARCHLOOP
                endif
              enddo
            enddo
            FOUNDIT = .True.
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,4
              resRe(i) = value_Im(cache_index,i)
              resIm(i) = value_Re(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP
       
      end subroutine ACCESS_CACHE_GGHG    

      subroutine ADD_TO_CACHE_GGHG(identifier, p, pmassA, pmassB, 
     &    resRe, resIm)
          implicit none
C Arguments
C We only consider the gluon momenta
          double precision P(0:3,3)
          double precision pmassA, pmassB
          integer identifier
          double precision resRe(4)
          double precision resIm(4)
C Local
          integer i,j,cache_index
C Cache
          include 'gghg_cache.inc'
 
          cache_index = MOD(curr_cache_size,gghg_max_cache)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = MIN(curr_cache_size + 1,gghg_max_cache)
          do i=0,3
            do j=1,3
              key_P(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MA(cache_index)=pmassA
          key_MB(cache_index)=pmassB
          key_id(cache_index)=identifier
          do i=1,4
            value_Im(cache_index,i)=resRe(i)
            value_Re(cache_index,i)=resIm(i)
          enddo

      end subroutine ADD_TO_CACHE_GGHG   

      subroutine set_pphj_gghg_heft_0l_coeffs(P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision resRe(4) 
          double precision resIm(4)

c         Assign nloop=-1 to the meaning of HEFT 0l          
          integer identifier
          parameter (identifier=-1)
          integer nloop
          parameter (nloop=0)
          logical HEFTselected
          parameter (HEFTselected=.true.)

          logical FOUNDIT
          integer i, j
          save resRe
          save resIm

          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf

          inc_ytqcd = .False.
          inc_ytmb = .False.
          inc_ytmt = .False.
          inc_ybqcd = .False.
          inc_ybmb = .False.
          inc_ybmt = .False.
          pphj_nf = MDL_PPHJ_nf


          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_GGHG(identifier, P, MDL_MB, MDL_MT, 
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 0-loop HEFT tensor'
             call %(C_prefix)sget_pphj_gghg_tensor_coefs(
     &           HEFTselected, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PGGG,MDL_MB,MDL_MT, MDL_MH, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_GGHG(identifier, P,MDL_MB, MDL_MT, 
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_GGGH0LHEFT_ForFac1_RE = real(resRe(1) ,16)
          MDL_GGGH0LHEFT_ForFac2_RE = real(resRe(2) ,16)
          MDL_GGGH0LHEFT_ForFac3_RE = real(resRe(3) ,16)
          MDL_GGGH0LHEFT_ForFac4_RE = real(resRe(4) ,16)
          MDL_GGGH0LHEFT_ForFac1_IM = real(resIm(1) ,16)
          MDL_GGGH0LHEFT_ForFac2_IM = real(resIm(2) ,16)
          MDL_GGGH0LHEFT_ForFac3_IM = real(resIm(3) ,16)
          MDL_GGGH0LHEFT_ForFac4_IM = real(resIm(4) ,16)
          call COUP()

      end subroutine set_pphj_gghg_heft_0l_coeffs

      subroutine set_pphj_gghg_heft_1l_coeffs(P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision resRe(4) 
          double precision resIm(4)

c         Assign nloop=-2 to the meaning of HEFT 1l          
          integer identifier
          parameter (identifier=-2)
          integer nloop
          parameter (nloop=1)
          logical HEFTselected
          parameter (HEFTselected=.true.)

          logical FOUNDIT
          integer i, j
          save resRe
          save resIm

          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf

          inc_ytqcd = .False.
          inc_ytmb = .False.
          inc_ytmt = .False.
          inc_ybqcd = .False.
          inc_ybmb = .False.
          inc_ybmt = .False.
          pphj_nf = MDL_PPHJ_nf


          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_GGHG(identifier, P, MDL_MB, MDL_MT, 
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 1-loop HEFT tensor'
             call %(C_prefix)sget_pphj_gghg_tensor_coefs(
     &           HEFTselected, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PGGG,MDL_MB,MDL_MT, MDL_MH, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_GGHG(identifier, P,MDL_MB, MDL_MT, 
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_GGGH1LHEFT_ForFac1_RE = real(resRe(1) ,16)
          MDL_GGGH1LHEFT_ForFac2_RE = real(resRe(2) ,16)
          MDL_GGGH1LHEFT_ForFac3_RE = real(resRe(3) ,16)
          MDL_GGGH1LHEFT_ForFac4_RE = real(resRe(4) ,16)
          MDL_GGGH1LHEFT_ForFac1_IM = real(resIm(1) ,16)
          MDL_GGGH1LHEFT_ForFac2_IM = real(resIm(2) ,16)
          MDL_GGGH1LHEFT_ForFac3_IM = real(resIm(3) ,16)
          MDL_GGGH1LHEFT_ForFac4_IM = real(resIm(4) ,16)
          call COUP()

      end subroutine set_pphj_gghg_heft_1l_coeffs

      subroutine set_pphj_gghg_qcd_1l_coeffs(P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision resRe(4) 
          double precision resIm(4)

c         Assign nloop=1 to the meaning of QCD 0l          
          integer identifier
          parameter (identifier=1)
          integer nloop
          parameter (nloop=1)
          logical HEFTselected
          parameter (HEFTselected=.false.)

          logical FOUNDIT
          integer i, j
          save resRe
          save resIm

          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf

          inc_ytqcd = MDL_GGGH1LQCD_inc_yt.gt.0.0d0
          inc_ytmb = MDL_GGGH1LQCD_inc_yt.gt.0.0d0
          inc_ytmt = MDL_GGGH1LQCD_inc_yt.gt.0.0d0
          inc_ybqcd = MDL_GGGH1LQCD_inc_yb.gt.0.0d0
          inc_ybmb = MDL_GGGH1LQCD_inc_yb.gt.0.0d0
          inc_ybmt = MDL_GGGH1LQCD_inc_yb.gt.0.0d0
          pphj_nf = MDL_PPHJ_nf


          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_GGHG(identifier, P, MDL_MB, MDL_MT, 
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 1-loop tensor'
             call %(C_prefix)sget_pphj_gghg_tensor_coefs(
     &           HEFTselected, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PGGG,MDL_MB,MDL_MT, MDL_MH, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_GGHG(identifier, P,MDL_MB, MDL_MT, 
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_GGGH1LQCD_ForFac1_RE = real(resRe(1) ,16)
          MDL_GGGH1LQCD_ForFac2_RE = real(resRe(2) ,16)
          MDL_GGGH1LQCD_ForFac3_RE = real(resRe(3) ,16)
          MDL_GGGH1LQCD_ForFac4_RE = real(resRe(4) ,16)
          MDL_GGGH1LQCD_ForFac1_IM = real(resIm(1) ,16)
          MDL_GGGH1LQCD_ForFac2_IM = real(resIm(2) ,16)
          MDL_GGGH1LQCD_ForFac3_IM = real(resIm(3) ,16)
          MDL_GGGH1LQCD_ForFac4_IM = real(resIm(4) ,16)
          call COUP()

      end subroutine set_pphj_gghg_qcd_1l_coeffs

      subroutine set_pphj_gghg_qcd_2l_coeffs(P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PGGG(12)
          double precision resRe(4) 
          double precision resIm(4)

c         Assign nloop=1 to the meaning of QCD 0l          
          integer identifier
          parameter (identifier=2)
          integer nloop
          parameter (nloop=2)
          logical HEFTselected
          parameter (HEFTselected=.false.)

          logical FOUNDIT
          integer i, j
          save resRe
          save resIm

          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf

          inc_ytqcd = MDL_GGGH2LQCD_inc_ytqcd.gt.0.0d0
          inc_ytmb = MDL_GGGH2LQCD_inc_ytmb.gt.0.0d0
          inc_ytmt = MDL_GGGH2LQCD_inc_ytmt.gt.0.0d0
          inc_ybqcd = MDL_GGGH2LQCD_inc_ybqcd.gt.0.0d0
          inc_ybmb = MDL_GGGH2LQCD_inc_ybmb.gt.0.0d0
          inc_ybmt = MDL_GGGH2LQCD_inc_ybmt.gt.0.0d0
          pphj_nf = MDL_PPHJ_nf

          ! We parse PGGG to the C routine
          do i=1,3
            do j=0,3
                PGGG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_GGHG(identifier, P, MDL_MB, MDL_MT, 
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 2-loop tensor'
             call %(C_prefix)sget_pphj_gghg_tensor_coefs(
     &           HEFTselected, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PGGG,MDL_MB,MDL_MT, MDL_MH, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_GGHG(identifier, P,MDL_MB, MDL_MT, 
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_GGGH2LQCD_ForFac1_RE = real(resRe(1) ,16)
          MDL_GGGH2LQCD_ForFac2_RE = real(resRe(2) ,16)
          MDL_GGGH2LQCD_ForFac3_RE = real(resRe(3) ,16)
          MDL_GGGH2LQCD_ForFac4_RE = real(resRe(4) ,16)
          MDL_GGGH2LQCD_ForFac1_IM = real(resIm(1) ,16)
          MDL_GGGH2LQCD_ForFac2_IM = real(resIm(2) ,16)
          MDL_GGGH2LQCD_ForFac3_IM = real(resIm(3) ,16)
          MDL_GGGH2LQCD_ForFac4_IM = real(resIm(4) ,16)
          call COUP()

      end subroutine set_pphj_gghg_qcd_2l_coeffs