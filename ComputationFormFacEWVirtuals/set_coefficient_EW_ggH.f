      subroutine resetGGHEWCache()
            implicit none
C Cache
            include 'gghEW_cache.inc'
c          write(*,*) 'EMPTYING CACHE! ',curr_size_ewvirt
            curr_size_ewvirt = 0

      end subroutine
C
      subroutine ACCESS_CACHE_GGHEW(nloops,
     &    EWLORe, EWLOIm, EWNLORe,EWNLOIm,
     &    FOUNDIT)

          implicit none
C Arguments
          double precision nloops
          double precision EWLORe(2)
          double precision EWLOIm(2)
          double precision EWNLORe(2)
          double precision EWNLOIm(2)
          logical FOUNDIT
          
C Local
          integer i,j, cache_index
C Cache
          include 'gghEW_cache.inc'

          FOUNDIT = .False.

          SEARCHLOOP : do cache_index=1,curr_size_ewvirt
            if (.NOT.(
     &        abs(nloops-key_NLOOPSEW(cache_index)) .lt. tol_ewvirt )
     &         ) then
             cycle SEARCHLOOP
            endif
            
            FOUNDIT = .True.
            ! write(*,*) 'RECYCLED A CALL! ',cache_index
            do i=1,2
              EWLORe(i) = value_EWLORe(cache_index,i)
              EWLOIm(i) = value_EWLOIm(cache_index,i)
              EWNLORe(i) = value_EWNLORe(cache_index,i)
              EWNLOIm(i) = value_EWNLOIm(cache_index,i)
            enddo
            exit SEARCHLOOP
          enddo SEARCHLOOP

      end subroutine

      subroutine ADD_TO_CACHE_GGHEW(
     &    nloops, EWLORe, EWLOIm, EWNLORe,EWNLOIm)
          implicit none
C Arguments
          double precision nloops
          double precision EWLORe(2)
          double precision EWLOIm(2)
          double precision EWNLORe(2)
          double precision EWNLOIm(2)
C Local
          integer i,j,cache_index
C Cache
          include 'gghEW_cache.inc'

          cache_index = MOD(curr_size_ewvirt,max_cache_ewvirt)+1
c          write(*,*) 'ADDING ENTRY TO CACHE ',cache_index
          curr_size_ewvirt = MIN(curr_size_ewvirt + 1,max_cache_ewvirt)
          
          key_NLOOPSEW(cache_index)=nloops
          
          
          do i=1,2
            value_EWLORe(cache_index,i)=EWLORe(i)
            value_EWLOIm(cache_index,i)=EWLOIm(i)
            value_EWNLORe(cache_index,i)=EWNLORe(i)
            value_EWNLOIm(cache_index,i)=EWNLOIm(i)
          enddo

      end subroutine



      subroutine setGGHEWCoeffs(muR,nloops)
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision mur,nloops,mH,mZ,mW
          double precision EWLORe(2)
          double precision EWLOIm(2)
          double precision EWNLORe(2)
          double precision EWNLOIm(2)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save EWLORe
          save EWLOIm
          save EWNLORe
          save EWNLOIm
          ! We start by setting all couplings to 0
          MDL_GGHEWZZ2L_ForFac1_RE=0;
          MDL_GGHEWZZ2L_ForFac1_IM=0;
          MDL_GGHEWWW2L_ForFac1_RE=0;
          MDL_GGHEWWW2L_ForFac1_IM=0;
          MDL_GGHEWZZ3L_ForFac1_RE=0;
          MDL_GGHEWZZ3L_ForFac1_IM=0;
          MDL_GGHEWWW3L_ForFac1_RE=0;
          MDL_GGHEWWW3L_ForFac1_IM=0;
          CALL COUP()

          mZ = MDL_MZ
          mW = MDL_MW
          mH = MDL_MH
          muR =MU_R
          nloops = MDL_n_loops_EW
          
          ! Get Values for the couplings
          CALL ACCESS_CACHE_GGHEW(nloops,
     &            EWLORe,EWLOIm, EWNLORe,EWNLOIm,             
     &            FOUNDIT)
          if (.NOT.FOUNDIT) THEN
            ! Write(*,*) 'Recomputing it'
             CALL get_ggh_ew_coefs_fortran(
     &         mH,mW,mZ,muR,
     &         EWLORe,EWLOIm,EWNLORe,EWNLOIm) 
             CALL ADD_TO_CACHE_GGHEW(nloops,
     &               EWLORe,EWLOIm, EWNLORe,EWNLOIm)
          endif

          ! Now we set the relevant non-zero values
          if ((int(nloops))==2) THEN
            MDL_GGHEWZZ2L_ForFac1_RE=EWLORe(1);
            MDL_GGHEWZZ2L_ForFac1_IM=EWLOIm(1);
            MDL_GGHEWWW2L_ForFac1_RE=EWLORe(2);
            MDL_GGHEWWW2L_ForFac1_IM=EWLOIm(2);
          endif
          if ((int(nloops))==3) THEN
            MDL_GGHEWZZ3L_ForFac1_RE=EWNLORe(1);
            MDL_GGHEWZZ3L_ForFac1_IM=EWNLOIm(1);
            MDL_GGHEWWW3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWWW3L_ForFac1_IM=EWNLOIm(2);
          endif
          if ((int(nloops))==99) THEN
            MDL_GGHEWZZ2L_ForFac1_RE=EWLORe(1);
            MDL_GGHEWZZ2L_ForFac1_IM=EWLOIm(1);
            MDL_GGHEWWW2L_ForFac1_RE=EWLORe(2);
            MDL_GGHEWWW2L_ForFac1_IM=EWLOIm(2);
            MDL_GGHEWZZ3L_ForFac1_RE=EWNLORe(1);
            MDL_GGHEWZZ3L_ForFac1_IM=EWNLOIm(1);
            MDL_GGHEWWW3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWWW3L_ForFac1_IM=EWNLOIm(2);
          endif
!         Update couplings
          call COUP()
 
        end subroutine setGGHEWCoeffs

        subroutine setGGHEWCoeffsWW(muR,nloops)
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision mur,nloops,mH,mZ,mW
          double precision EWLORe(2)
          double precision EWLOIm(2)
          double precision EWNLORe(2)
          double precision EWNLOIm(2)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save EWLORe
          save EWLOIm
          save EWNLORe
          save EWNLOIm
          ! We start by setting all couplings to 0
          MDL_GGHEWZZ2L_ForFac1_RE=0;
          MDL_GGHEWZZ2L_ForFac1_IM=0;
          MDL_GGHEWWW2L_ForFac1_RE=0;
          MDL_GGHEWWW2L_ForFac1_IM=0;
          MDL_GGHEWZZ3L_ForFac1_RE=0;
          MDL_GGHEWZZ3L_ForFac1_IM=0;
          MDL_GGHEWWW3L_ForFac1_RE=0;
          MDL_GGHEWWW3L_ForFac1_IM=0;
          CALL COUP()

          mZ = MDL_MZ
          mW = MDL_MW
          mH = MDL_MH
          muR =MU_R
          nloops = MDL_n_loops_EW
          
          ! Get Values for the couplings
          CALL ACCESS_CACHE_GGHEW(muR,nloops,
     &            EWLORe,EWLOIm, EWNLORe,EWNLOIm,             
     &            FOUNDIT)
          if (.NOT.FOUNDIT) THEN
            ! Write(*,*) 'Recomputing it'
             CALL get_ggh_ew_coefs_fortran(
     &         mH,mW,mZ,muR,
     &         EWLORe,EWLOIm,EWNLORe,EWNLOIm) 
             CALL ADD_TO_CACHE_GGHEW(muR,nloops,
     &               EWLORe,EWLOIm, EWNLORe,EWNLOIm)
          endif

          ! Now we set the relevant non-zero values
          if ((int(nloops))==2) THEN
            MDL_GGHEWWW2L_ForFac1_RE=EWLORe(2);
            MDL_GGHEWWW2L_ForFac1_IM=EWLOIm(2);
          endif
          if ((int(nloops))==3) THEN
            MDL_GGHEWWW3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWWW3L_ForFac1_IM=EWNLOIm(2);
          endif
          if ((int(nloops))==99) THEN
            MDL_GGHEWWW2L_ForFac1_RE=EWLORe(2);
            MDL_GGHEWWW2L_ForFac1_IM=EWLOIm(2);
            MDL_GGHEWWW3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWWW3L_ForFac1_IM=EWNLOIm(2);
          endif
!         Update couplings
          call COUP()
 
        end subroutine setGGHEWCoeffsWW

        subroutine setGGHEWCoeffsZZ(muR,nloops)
          implicit none
          include 'coupl.inc'
          include 'input.inc'
          double precision mur,nloops,mH,mZ,mW
          double precision EWLORe(2)
          double precision EWLOIm(2)
          double precision EWNLORe(2)
          double precision EWNLOIm(2)
          logical FOUNDIT
          integer i, j
          ! ask val why we save
          save EWLORe
          save EWLOIm
          save EWNLORe
          save EWNLOIm
          ! We start by setting all couplings to 0
          MDL_GGHEWZZ2L_ForFac1_RE=0;
          MDL_GGHEWZZ2L_ForFac1_IM=0;
          MDL_GGHEWWW2L_ForFac1_RE=0;
          MDL_GGHEWWW2L_ForFac1_IM=0;
          MDL_GGHEWZZ3L_ForFac1_RE=0;
          MDL_GGHEWZZ3L_ForFac1_IM=0;
          MDL_GGHEWWW3L_ForFac1_RE=0;
          MDL_GGHEWWW3L_ForFac1_IM=0;
          CALL COUP()

          mZ = MDL_MZ
          mW = MDL_MW
          mH = MDL_MH
          muR =MU_R
          nloops = MDL_n_loops_EW
          
          ! Get Values for the couplings
          CALL ACCESS_CACHE_GGHEW(muR,nloops,
     &            EWLORe,EWLOIm, EWNLORe,EWNLOIm,             
     &            FOUNDIT)
          if (.NOT.FOUNDIT) THEN
            ! Write(*,*) 'Recomputing it'
             CALL get_ggh_ew_coefs_fortran(
     &         mH,mW,mZ,muR,
     &         EWLORe,EWLOIm,EWNLORe,EWNLOIm) 
             CALL ADD_TO_CACHE_GGHEW(muR,nloops,
     &               EWLORe,EWLOIm, EWNLORe,EWNLOIm)
          endif

          ! Now we set the relevant non-zero values
          if ((int(nloops))==2) THEN
            MDL_GGHEWZZ2L_ForFac1_RE=EWLORe(1);
            MDL_GGHEWZZ2L_ForFac1_IM=EWLOIm(1);
          endif
          if ((int(nloops))==3) THEN
            MDL_GGHEWZZ3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWZZ3L_ForFac1_IM=EWNLOIm(2);
          endif
          if ((int(nloops))==99) THEN
            MDL_GGHEWZZ2L_ForFac1_RE=EWLORe(1);
            MDL_GGHEWZZ2L_ForFac1_IM=EWLOIm(1);
            MDL_GGHEWZZ3L_ForFac1_RE=EWNLORe(2);
            MDL_GGHEWZZ3L_ForFac1_IM=EWNLOIm(2);
          endif
!         Update couplings
          call COUP()
 
        end subroutine setGGHEWCoeffsZZ