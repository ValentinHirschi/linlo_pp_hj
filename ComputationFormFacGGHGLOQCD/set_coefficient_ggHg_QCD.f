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
            GGGH_ForFac1_RE  = real(oneLoopTensorRe(1) ,16)
            GGGH_ForFac2_RE  = real(oneLoopTensorRe(2) ,16)
            GGGH_ForFac3_RE  = real(oneLoopTensorRe(3) ,16)
            GGGH_ForFac4_RE  = real(oneLoopTensorRe(4) ,16)
            GGGH_ForFac1_IM  = real(oneLoopTensorIm(1) ,16)
            GGGH_ForFac2_IM  = real(oneLoopTensorIm(2) ,16)
            GGGH_ForFac3_IM  = real(oneLoopTensorIm(3) ,16)
            GGGH_ForFac4_IM  = real(oneLoopTensorIm(4) ,16)
            call COUP()

      end subroutine set1LoopGGHGQCDCoefficients
