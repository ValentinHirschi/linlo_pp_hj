      PROGRAM MAIN
           
           double precision    :: P(0:3,4), G_INPUT, MU_R_INPUT
           INTEGER  I,J,FM_K, PID
           integer :: num_args, ix
           double precision ME_result
           character(len=512) PARAM_NAME
           character(len=50), dimension(:), allocatable :: args
           character(len=512) FILE_NAME
           character(len=512) APP_CMD
           character(len=512) APP_PID
           character(len=512) APP_ME

           
           include 'LI_at_NLO_proc/Source/MODEL/coupl.inc'
           integer dummy_integer
           double precision floatReads(18)
        
           
           num_args = command_argument_count()
           allocate(args(num_args)) 
      
           do ix = 1, num_args
               call get_command_argument(ix,args(ix))
               ! now parse the argument as you wish
           end do
           IF (COMMAND_ARGUMENT_COUNT().NE.1) THEN
               WRITE(*,*) "Exp 1 args, not ",COMMAND_ARGUMENT_COUNT()
               STOP "Wrong number of arguments."
           ENDIF

           FM_K = 1
           READ(args(FM_K),*) PID

           open(1337,
     &     file="%(grid_file)s",
     &     status='old')

           read(1337, *) dummy_integer
           do i=1,PID
              read(1337,*)  (floatReads(j),j=1,18)
           enddo
           close(1337)

           FM_K = 1
           DO I=1,4
             DO J=0,3
               P(J,I) = floatReads(FM_K)
               FM_K = FM_K+1
             ENDDO
           ENDDO
           G_INPUT = floatreads(FM_K)
           FM_K = FM_K+1
           MU_R_INPUT = floatreads(FM_K)

           
           !WRITE(*,*) 'P1=',(P(J,1),J=0,3)      
           !WRITE(*,*) 'P2=',(P(J,2),J=0,3)      
           !WRITE(*,*) 'P3=',(P(J,3),J=0,3)      
           !WRITE(*,*) 'P4=',(P(J,4),J=0,3)
           !WRITE(*,*) 'G=',G_INPUT
           !WRITE(*,*) 'MU_R=',MU_R_INPUT

           PARAM_NAME = "./LI_at_NLO_proc/Cards/param_card.dat"
           CALL PROC_2_setpara2(PARAM_NAME)
           G = G_INPUT
           MU_R = MU_R_INPUT
           CALL PROC_2_UPDATE_AS_PARAM()
           CALL PROC_2_P2_SMATRIX(P,ME_result)
                      

          WRITE(*,*) "BEGIN MG RESULT"
          WRITE(*,*) PID
          WRITE(*,*) ME_result
          WRITE(*,*) "END MG RESULT"
C         WE APPEND TO A SPECIFIC LINE
C         THEREFORE THERE WILL BE NO CONFLICT
          write(APP_PID,*) PID+1
          APP_PID =trim(APP_PID)
          APP_PID =adjustl(APP_PID)
          write(APP_ME,*) ME_RESULT
          APP_ME =trim(APP_ME)
          APP_ME =adjustl(APP_ME)
          write(APP_CMD, *) "sed -i.bak '",adjustl(trim(APP_PID)),
     &          "s/$/  ", adjustl(trim(APP_ME)),
     &     "/'  %(grid_file)s"
           CALL SYSTEM(APP_CMD)
      END PROGRAM MAIN
      
      
