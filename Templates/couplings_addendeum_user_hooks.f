      SUBROUTINE %(proc_prefix)s_UPDATE_LINLO_COUPLINGS(
     &     IN_MB, IN_MT, IN_MH, IN_YMB,IN_YMT, IN_MW, IN_MZ,
     &      IN_WT, IN_WH, IN_WW, IN_WZ, IN_AEWM1, IN_GF, IN_PPHJ_RUN_ID
     & )

      IMPLICIT NONE
      DOUBLE PRECISION PI, ZERO
      LOGICAL READLHA
      PARAMETER  (PI=3.141592653589793D0)
      PARAMETER  (ZERO=0D0)

      DOUBLE PRECISION  IN_MB, IN_MT, IN_MH, IN_PPHJ_RUN_ID
      DOUBLE PRECISION IN_YMB,IN_YMT, IN_MW, IN_MZ
      DOUBLE PRECISION IN_WT, IN_WH, IN_WW, IN_WZ, IN_AEWM1, IN_GF
      INCLUDE 'model_functions.inc'
      REAL*16 MP__PI, MP__ZERO
      PARAMETER (MP__PI=3.1415926535897932384626433832795E0_16)
      PARAMETER (MP__ZERO=0E0_16)
      INCLUDE 'input.inc'
      INCLUDE 'coupl.inc'
      include 'formats.inc'

      LOGICAL UPDATELOOP
      COMMON /TO_UPDATELOOP/UPDATELOOP

c      WRITE(*,*) 'Before update: GC_33=',GC_33

      MDL_MB = IN_MB
      MDL_MT = IN_MT
      MDL_MH = IN_MH
      MDL_YMB = IN_YMB
      MDL_YMT = IN_YMT
      MDL_MW = IN_MW
      MDL_MZ = IN_MZ
      
      MDL_GF = IN_GF
      AEWM1 = IN_AEWM1 

      MDL_PPHJ_RUN_ID = IN_PPHJ_RUN_ID


      READLHA = .TRUE.
      INCLUDE 'intparam_definition.inc'

      CALL %(proc_prefix)s_COUP1()
C     
couplings needed to be evaluated points by points
C     
      CALL %(proc_prefix)s_COUP2()

c      WRITE(*,*) 'After GC_33=',GC_33
cx      include 'param_write.inc'
cx      include 'coupl_write.inc'
c      pause
      
      RETURN
      END

      
      SUBROUTINE %(proc_prefix)s_UPDATE_LINLO_EPSORD(
     &  GGGH1,QQGH1,GGGH2,QQGH2
     &     )

      IMPLICIT NONE
      DOUBLE PRECISION PI, ZERO
      LOGICAL READLHA
      PARAMETER  (PI=3.141592653589793D0)
      PARAMETER  (ZERO=0D0)

      DOUBLE PRECISION GGGH1,QQGH1,GGGH2,QQGH2
      INCLUDE 'model_functions.inc'
      INCLUDE 'input.inc'
      INCLUDE 'coupl.inc'
      include 'formats.inc'


      MDL_GGGH1LQCD_EPS_ORDER = GGGH1
      MDL_QQGH1LQCD_EPS_ORDER = QQGH1
      MDL_GGGH2LQCD_EPS_ORDER = GGGH2
      MDL_QQGH2LQCD_EPS_ORDER = QQGH2
      
      RETURN
      END
