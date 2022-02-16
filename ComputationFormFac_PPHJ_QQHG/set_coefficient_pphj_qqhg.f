      subroutine resetQQHGCache()
            implicit none
C Cache
            include 'qqhg_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_cache_size
            curr_cache_size = 0

      end subroutine
C      
      subroutine ACCESS_CACHE_QQHG(identifier, p, pmassA, pmassB, MUR, 
     &    resRe, resIm,
     &    FOUNDIT)
            
          implicit none
C Arguments
          double precision P(0:3,3)
          integer identifier
          double precision pmassA, pmassB, MUR
          logical FOUNDIT
          double precision resRe(4)
          double precision resIm(4)
C Local
          integer i,j, cache_index
C Cache
          include 'qqhg_cache.inc'
                   
          FOUNDIT = .False.
       
          SEARCHLOOP : do cache_index=1,curr_cache_size
            if ( .NOT.(
     &       identifier.eq.key_id(cache_index) )
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(pmassA-key_MA(cache_index)) .lt. qqhg_tol ) 
     &         ) then
              cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(pmassB-key_MB(cache_index)) .lt. qqhg_tol ) 
     &         ) then
             cycle SEARCHLOOP
            endif
            if ( .NOT.(
     &       abs(MUR-key_MUR(cache_index)) .lt. qqhg_tol ) 
     &         ) then
             cycle SEARCHLOOP
            endif
            do i=0,3
              do j=1,3
                if ( .NOT.(
     &     abs(P(i,j)-key_P(cache_index,i,j)) .lt. qqhg_tol ) 
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
       
      end subroutine ACCESS_CACHE_QQHG    

      subroutine ADD_TO_CACHE_QQHG(identifier, p, pmassA, pmassB, MUR,
     &    resRe, resIm)
          implicit none
C Arguments
C We only consider the gluon momenta
          double precision P(0:3,3)
          double precision pmassA, pmassB, MUR
          integer identifier
          double precision resRe(4)
          double precision resIm(4)
C Local
          integer i,j,cache_index
C Cache
          include 'qqhg_cache.inc'
 
          cache_index = MOD(curr_cache_size,qqhg_max_cache)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_cache_size = MIN(curr_cache_size + 1,qqhg_max_cache)
          do i=0,3
            do j=1,3
              key_P(cache_index,i,j) = P(i,j)
            enddo
          enddo
          key_MA(cache_index)=pmassA
          key_MB(cache_index)=pmassB
          key_MUR(cache_index)=MUR
          key_id(cache_index)=identifier
          do i=1,4
            value_Im(cache_index,i)=resRe(i)
            value_Re(cache_index,i)=resIm(i)
          enddo

      end subroutine ADD_TO_CACHE_QQHG   

      subroutine set_pphj_qqhg_heft_0l_coeffs(selected_channel, P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PQQG(12)
          double precision resRe(4) 
          double precision resIm(4)
          integer selected_channel

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
          integer eval_mode
          integer pphj_eps_order
          logical do_debug
          integer pphj_run_id

          inc_ytqcd = .False.
          inc_ytmb = .False.
          inc_ytmt = .False.
          inc_ybqcd = .False.
          inc_ybmb = .False.
          inc_ybmt = .False.
          pphj_nf = NINT(MDL_PPHJ_nf)
          do_debug = (MDL_PPHJ_DEBUG.ge.0.0d0)
          pphj_run_id = NINT(MDL_PPHJ_RUN_ID)
          eval_mode = 0
          pphj_eps_order = 0


          ! We parse PQQG to the C routine
          do i=1,3
            do j=0,3
                PQQG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_QQHG((identifier*10+selected_channel), P, MDL_MB, MDL_MT, MU_R, 
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 0-loop HEFT tensor'
             call %(C_prefix)sget_pphj_qqhg_tensor_coefs(pphj_run_id,do_debug,
     &           HEFTselected, eval_mode, selected_channel, pphj_eps_order, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PQQG,MDL_MB,MDL_MT, MDL_MH, MU_R, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_QQHG((identifier*10+selected_channel), P,MDL_MB, MDL_MT, MU_R, 
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_QQGH0LHEFT_ForFac1_RE = real(resRe(1) ,16)
          MDL_QQGH0LHEFT_ForFac2_RE = real(resRe(2) ,16)
          MDL_QQGH0LHEFT_ForFac1_IM = real(resIm(1) ,16)
          MDL_QQGH0LHEFT_ForFac2_IM = real(resIm(2) ,16)
          call COUP()

      end subroutine set_pphj_qqhg_heft_0l_coeffs

      subroutine set_pphj_qqhg_heft_1l_coeffs(selected_channel, P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PQQG(12)
          double precision resRe(4) 
          double precision resIm(4)
          integer selected_channel

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
          integer eval_mode
          integer pphj_nf
          integer pphj_eps_order
          logical do_debug
          integer pphj_run_id

          inc_ytqcd = .False.
          inc_ytmb = .False.
          inc_ytmt = .False.
          inc_ybqcd = .False.
          inc_ybmb = .False.
          inc_ybmt = .False.
          eval_mode = 0
          pphj_nf = NINT(MDL_PPHJ_nf)
          pphj_run_id = NINT(MDL_PPHJ_RUN_ID)
          do_debug = (MDL_PPHJ_DEBUG.ge.0.0d0)
          pphj_eps_order = 0


          ! We parse PQQG to the C routine
          do i=1,3
            do j=0,3
                PQQG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_QQHG((identifier*10+selected_channel), P, MDL_MB, MDL_MT, MU_R,
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 1-loop HEFT tensor'
             call %(C_prefix)sget_pphj_qqhg_tensor_coefs(pphj_run_id,do_debug,
     &           HEFTselected, eval_mode, selected_channel, pphj_eps_order, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PQQG,MDL_MB,MDL_MT, MDL_MH, MU_R, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_QQHG((identifier*10+selected_channel), P,MDL_MB, MDL_MT, MU_R,
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_QQGH1LHEFT_ForFac1_RE = real(resRe(1) ,16)
          MDL_QQGH1LHEFT_ForFac2_RE = real(resRe(2) ,16)
          MDL_QQGH1LHEFT_ForFac1_IM = real(resIm(1) ,16)
          MDL_QQGH1LHEFT_ForFac2_IM = real(resIm(2) ,16)
          call COUP()

      end subroutine set_pphj_qqhg_heft_1l_coeffs

      subroutine set_pphj_qqhg_qcd_1l_coeffs(selected_channel, P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PQQG(12)
          double precision resRe(4) 
          double precision resIm(4)
          integer selected_channel

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

          integer eval_mode
          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf, pphj_eps_order
          logical do_debug
          integer pphj_run_id

          inc_ytqcd = MDL_QQGH1LQCD_yt.gt.0.0d0
          inc_ytmb = MDL_QQGH1LQCD_yt.gt.0.0d0
          inc_ytmt = MDL_QQGH1LQCD_yt.gt.0.0d0
          inc_ybqcd = MDL_QQGH1LQCD_yb.gt.0.0d0
          inc_ybmb = MDL_QQGH1LQCD_yb.gt.0.0d0
          inc_ybmt = MDL_QQGH1LQCD_yb.gt.0.0d0
          pphj_nf = NINT(MDL_PPHJ_nf)
          pphj_run_id = NINT(MDL_PPHJ_RUN_ID)
          do_debug = (MDL_PPHJ_DEBUG.ge.0.0d0)
          eval_mode = NINT(MDL_QQGH1LQCD_eval_mode)
          pphj_eps_order = NINT(MDL_QQGH1LQCD_eps_order)

          ! We parse PQQG to the C routine
          do i=1,3
            do j=0,3
                PQQG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_QQHG((identifier*10+selected_channel), P, MDL_MB, MDL_MT, MU_R,
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 1-loop tensor'
             call %(C_prefix)sget_pphj_qqhg_tensor_coefs(pphj_run_id,do_debug,
     &           HEFTselected, eval_mode, selected_channel, pphj_eps_order, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PQQG,MDL_MB,MDL_MT, MDL_MH, MU_R, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_QQHG((identifier*10+selected_channel), P,MDL_MB, MDL_MT, MU_R,
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_QQGH1LQCD_ForFac1_RE = real(resRe(1) ,16)
          MDL_QQGH1LQCD_ForFac2_RE = real(resRe(2) ,16)
          MDL_QQGH1LQCD_ForFac1_IM = real(resIm(1) ,16)
          MDL_QQGH1LQCD_ForFac2_IM = real(resIm(2) ,16)
          call COUP()

      end subroutine set_pphj_qqhg_qcd_1l_coeffs

      subroutine set_pphj_qqhg_qcd_2l_coeffs(selected_channel, P)

          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision P(0:3,3)
          double precision PQQG(12)
          double precision resRe(4) 
          double precision resIm(4)
          integer selected_channel

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

          integer eval_mode
          logical inc_ytqcd, inc_ytmb, inc_ytmt
          logical inc_ybqcd, inc_ybmb, inc_ybmt
          integer pphj_nf, pphj_eps_order
          logical do_debug
          integer pphj_run_id

          inc_ytqcd = MDL_QQGH2LQCD_ytqcd.gt.0.0d0
          inc_ytmb = MDL_QQGH2LQCD_ytmb.gt.0.0d0
          inc_ytmt = MDL_QQGH2LQCD_ytmt.gt.0.0d0
          inc_ybqcd = MDL_QQGH2LQCD_ybqcd.gt.0.0d0
          inc_ybmb = MDL_QQGH2LQCD_ybmb.gt.0.0d0
          inc_ybmt = MDL_QQGH2LQCD_ybmt.gt.0.0d0
          pphj_eps_order = NINT(MDL_QQGH2LQCD_eps_order)
          eval_mode = NINT(MDL_QQGH2LQCD_eval_mode)
          pphj_nf = NINT(MDL_PPHJ_nf)
          pphj_run_id = NINT(MDL_PPHJ_RUN_ID)
          do_debug = (MDL_PPHJ_DEBUG.ge.0.0d0)

          ! We parse PQQG to the C routine
          do i=1,3
            do j=0,3
                PQQG((i-1)*4+j+1) = P(j,i)
            enddo
          enddo

          CALL ACCESS_CACHE_QQHG((identifier*10+selected_channel), P, MDL_MB, MDL_MT, MU_R,
     &                      resRe, resIm,
     &                      FOUNDIT)
          if (.NOT.FOUNDIT) THEN
c             Write(*,*) 'Recomputing 2-loop tensor'
             call %(C_prefix)sget_pphj_qqhg_tensor_coefs(pphj_run_id,do_debug,
     &           HEFTselected, eval_mode, selected_channel, pphj_eps_order, nloop, pphj_nf,
     &           inc_ytqcd, inc_ytmb, inc_ytmt,
     &           inc_ybqcd, inc_ybmb, inc_ybmt,
     &           PQQG,MDL_MB,MDL_MT, MDL_MH, MU_R, MDL_YB, MDL_YT,resRe,resIm)
             CALL ADD_TO_CACHE_QQHG((identifier*10+selected_channel), P,MDL_MB, MDL_MT, MU_R,
     &                         resRe, resIm)
          endif

!         Update couplings
          MDL_QQGH2LQCD_ForFac1_RE = real(resRe(1) ,16)
          MDL_QQGH2LQCD_ForFac2_RE = real(resRe(2) ,16)
          MDL_QQGH2LQCD_ForFac1_IM = real(resIm(1) ,16)
          MDL_QQGH2LQCD_ForFac2_IM = real(resIm(2) ,16)
          call COUP()

      end subroutine set_pphj_qqhg_qcd_2l_coeffs
