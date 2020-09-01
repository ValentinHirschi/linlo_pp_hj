      PROGRAM MAIN  
           double precision    :: P(0:3,4), G_INPUT, MU_R_INPUT
           INTEGER  I,J,FM_K
           integer :: num_args, ix
           double precision ME_result
           character(len=512) PARAM_NAME
           character(len=50), dimension(:), allocatable :: args
           
           include 'LI_at_NLO_proc/Source/MODEL/coupl.inc'

           num_args = command_argument_count()
           allocate(args(num_args)) 
      
           do ix = 1, num_args
               call get_command_argument(ix,args(ix))
               ! now parse the argument as you wish
           end do
           IF (COMMAND_ARGUMENT_COUNT().NE.18) THEN
               WRITE(*,*) "Expected 18 args, not ",COMMAND_ARGUMENT_COUNT()
               STOP "Wrong number of arguments."
           ENDIF
           FM_K = 1
           DO I=1,4
             DO J=0,3
               READ (args(FM_K),*) P(J,I)
               FM_K = FM_K+1
             ENDDO
           ENDDO
           READ (args(FM_K),*) G_INPUT
           FM_K = FM_K+1
           READ (args(FM_K),*) MU_R_INPUT

           
c           WRITE(*,*) 'P1=',(P(J,1),J=0,3)      
c           WRITE(*,*) 'P2=',(P(J,2),J=0,3)      
c           WRITE(*,*) 'P3=',(P(J,3),J=0,3)      
c           WRITE(*,*) 'P4=',(P(J,4),J=0,3)
c           WRITE(*,*) 'G=',G_INPUT
c           WRITE(*,*) 'MU_R=',MU_R_INPUT

           PARAM_NAME = "./LI_at_NLO_proc/Cards/param_card.dat" 
           CALL PROC_2_setpara2(PARAM_NAME)
           G = G_INPUT
           MU_R = MU_R_INPUT
           CALL PROC_2_UPDATE_AS_PARAM()
           CALL PROC_2_P2_SMATRIX(P,ME_result)
           WRITE(*,*) ME_result

      END PROGRAM MAIN
      
      
