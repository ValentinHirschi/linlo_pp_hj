# This file was automatically created by FeynRules $Revision: 535 $
# Mathematica version: 7.0 for Mac OS X x86 (64-bit) (November 11, 2008)
# Date: Fri 18 Mar 2011 18:40:51


from object_library import all_couplings, Coupling

from function_library import complexconjugate, re, im, csc, sec, acsc, asec

# ======================================================================
# Infinite HEFT
# ======================================================================
GGH_HEFT_0L_C1 = Coupling(name = 'GGH_HEFT_LO_C1',
                value = '(CHEFT)*(complex(0,1))*GGH_HEFT_LO',
                order = {'GGHEFT':1,"QCD":2,"QED":1})

# Renormalized but NOT IR-subtracted                
GGH_EFT_1L_EP0 = Coupling(name = 'GGH_EFT_1L_EP0',
                value = '(CHEFT)*aS/(4.*cmath.pi)*(GGH_HEFT1L_EP0_RE+GGH_HEFT1L_EP0_IM*complex(0,1))',
                order = {'GGHEFT':1,"QCD":4,"QED":1})

GGH_EFT_1L_EPM1 = Coupling(name = 'GGH_EFT_1L_EPM1',
                value = '(CHEFT)*aS/(4.*cmath.pi)*complex(0,1)*(GGH_HEFT1L_EPM1_RE+GGH_HEFT1L_EPM1_IM*complex(0,1))',
                order = {'GGHEFT':1,"QCD":4,"QED":1})

# ((-I/2)*aS*CHeft*Nc)/(eps^2*Pi) Nc=3
GGH_EFT_1L_EPM2 = Coupling(name = 'GGH_EFT_1L_EPM2',
                value = '(CHEFT)*aS/(4.*cmath.pi)*complex(0,1)*(GGH_HEFT1L_EPM2_RE)',
                order = {'GGHEFT':1,"QCD":4,"QED":1})

# my color factor is -Tr[T^a T^b T^c]+Tr[T^a T^c T^b] = 1/2 i f^abc
# therefore I include a -1/2 i
GGGH_HEFT_C1 = Coupling(name = 'GGGH_HEFT_C1',
                value = '(-0.5)*(CHEFT)*G*GGGH_HEFT_ForFac1',
                order = {'GGGHEFT':1,"QCD":3,"QED":1})
GGGH_HEFT_C2 = Coupling(name = 'GGGH_HEFT_C2',
                value = '(-0.5)*(CHEFT)*G*GGGH_HEFT_ForFac2',
                order = {'GGGHEFT':1,"QCD":3,"QED":1})
GGGH_HEFT_C3 = Coupling(name = 'GGGH_HEFT_C3',
                value = '(-0.5)*(CHEFT)*G*GGGH_HEFT_ForFac3',
                order = {'GGGHEFT':1,"QCD":3,"QED":1})
GGGH_HEFT_C4 = Coupling(name = 'GGGH_HEFT_C4',
                value = '(-0.5)*(CHEFT)*G*GGGH_HEFT_ForFac4',
                order = {'GGGHEFT':1,"QCD":3,"QED":1})



# ======================================================================
# Effective fake coupling for the tensor in GGH EW 
# ======================================================================
# Z-exchange (WW-exchange) 2-loop
GGHEWZZ2L_C1 = Coupling(name = 'GGHEWZZ2L_C1',
                value = '(AllGGHEWZZCoup2L)*(GGHEWZZ2L_ForFac1_RE+complex(0,1)*GGHEWZZ2L_ForFac1_IM)',
                order = {#'GGHEW2L':1,
                "QCD":2,"QED":3#,"ZZ":1
                })
GGHEWWW2L_C1 = Coupling(name = 'GGHEWWW2L_C1',
                value = '(AllGGHEWWWCoup2L)*(GGHEWWW2L_ForFac1_RE+complex(0,1)*GGHEWWW2L_ForFac1_IM)',
                order = {#'GGHEW2L':1,
                "QCD":2,"QED":3#,"WW":1
                })

# Z-exchange (WW-exchange) 3-loop (how to put the epsilon poles?)
GGHEWZZ3L_C1 = Coupling(name = 'GGHEWZZ3L_C1',
                value = '(AllGGHEWZZCoup3L)*(GGHEWZZ3L_ForFac1_RE+complex(0,1)*GGHEWZZ3L_ForFac1_IM)',
                order = {#'GGHEW3L':1,
                "QCD":4,"QED":3#,"ZZ":1
                })
GGHEWWW3L_C1 = Coupling(name = 'GGHEWWW3L_C1',
                value = '(AllGGHEWWWCoup3L)*(GGHEWWW3L_ForFac1_RE+complex(0,1)*GGHEWWW3L_ForFac1_IM)',
                order = {#'GGHEW3L':1,
                "QCD":4,"QED":3#,"WW":1
                })


# ======================================================================
# Effective fake couplings for each of the 4 tensors in GGGH-QCD massive
# ======================================================================
# AllGGGHQCDCoup = Coupling(name = 'AllGGGHQCDCoup',
#                  value = '-((complex(0,1)*yt)/cmath.sqrt(2))*G**3',
#                  order = {'GGGHQCD':1,"QCD":3,"QED":1})

GGGHQCD_C1 = Coupling(name = 'GGGHQCD_C1',
                value = '(AllGGGHQCDCoup)*(GGGHQCD_ForFac1_RE+complex(0,1)*GGGHQCD_ForFac1_IM)',
                order = {'GGGHQCD':1,"QCD":3,"QED":1})

GGGHQCD_C2 = Coupling(name = 'GGGHQCD_C2',
                value = '(AllGGGHQCDCoup)*(GGGHQCD_ForFac2_RE+complex(0,1)*GGGHQCD_ForFac2_IM)',
                order = {'GGGHQCD':1,"QCD":3,"QED":1})

GGGHQCD_C3 = Coupling(name = 'GGGHQCD_C3',
                value = '(AllGGGHQCDCoup)*(GGGHQCD_ForFac3_RE+complex(0,1)*GGGHQCD_ForFac3_IM)',
                order = {'GGGHQCD':1,"QCD":3,"QED":1})

GGGHQCD_C4 = Coupling(name = 'GGGHQCD_C4',
                value = '(AllGGGHQCDCoup)*(GGGHQCD_ForFac4_RE+complex(0,1)*GGGHQCD_ForFac4_IM)',
                order = {'GGGHQCD':1,"QCD":3,"QED":1})


# =========================================================================
# Effective fake couplings for each of the 4 tensors in GGHG EW ZZ-exchange
# =========================================================================
# AllGGGHEWZZCoup = Coupling(name = 'AllGGGHEWZZCoup',
#                  value = '-((complex(0,1)*yt)/cmath.sqrt(2))*G**3',
#                  order = {'GGGHEW':1,"QCD":3,"QED":3,"ZZ":1})

GGGHEWZZ_C1 = Coupling(name = 'GGGHEWZZ_C1',
                value = '(AllGGGHEWZZCoup)*(GGGHEWZZ_ForFac1_RE+complex(0,1)*GGGHEWZZ_ForFac1_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"ZZ":1
                })

GGGHEWZZ_C2 = Coupling(name = 'GGGHEWZZ_C2',
                value = '(AllGGGHEWZZCoup)*(GGGHEWZZ_ForFac2_RE+complex(0,1)*GGGHEWZZ_ForFac2_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"ZZ":1
                })

GGGHEWZZ_C3 = Coupling(name = 'GGGHEWZZ_C3',
                value = '(AllGGGHEWZZCoup)*(GGGHEWZZ_ForFac3_RE+complex(0,1)*GGGHEWZZ_ForFac3_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"ZZ":1
                })

GGGHEWZZ_C4 = Coupling(name = 'GGGHEWZZ_C4',
                value = '(AllGGGHEWZZCoup)*(GGGHEWZZ_ForFac4_RE+complex(0,1)*GGGHEWZZ_ForFac4_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"ZZ":1
                })


# =========================================================================
# Effective fake couplings for each of the 4 tensors in GGHG EW W+W-exchange
# =========================================================================
# AllGGGHEWWWCoup = Coupling(name = 'AllGGGHEWWWCoup',
#                  value = '-((complex(0,1)*yt)/cmath.sqrt(2))*G**3',
#                  order = {'GGGHEW':1,"QCD":3,"QED":3,"WW":1})

GGGHEWWW_C1 = Coupling(name = 'GGGHEWWW_C1',
                value = '(AllGGGHEWWWCoup)*(GGGHEWWW_ForFac1_RE+complex(0,1)*GGGHEWWW_ForFac1_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"WW":1
                })

GGGHEWWW_C2 = Coupling(name = 'GGGHEWWW_C2',
                value = '(AllGGGHEWWWCoup)*(GGGHEWWW_ForFac2_RE+complex(0,1)*GGGHEWWW_ForFac2_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"WW":1
                })

GGGHEWWW_C3 = Coupling(name = 'GGGHEWWW_C3',
                value = '(AllGGGHEWWWCoup)*(GGGHEWWW_ForFac3_RE+complex(0,1)*GGGHEWWW_ForFac3_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"WW":1
                })

GGGHEWWW_C4 = Coupling(name = 'GGGHEWWW_C4',
                value = '(AllGGGHEWWWCoup)*(GGGHEWWW_ForFac4_RE+complex(0,1)*GGGHEWWW_ForFac4_IM)',
                order = {#'GGGHEW':1,
                "QCD":3,"QED":3#,"WW":1
                })


# ======================================================================

GC_HHHH = Coupling(name = 'GC_HHHH',
                value = '-6*complex(0,1)*lam',
                order = {'QED':2})

GC_1 = Coupling(name = 'GC_1',
                value = '-(ee*complex(0,1))/3.',
                order = {'QED':1})

GC_2 = Coupling(name = 'GC_2',
                value = '(2*ee*complex(0,1))/3.',
                order = {'QED':1})

GC_3 = Coupling(name = 'GC_3',
                value = '-(ee*complex(0,1))',
                order = {'QED':1})

GC_4 = Coupling(name = 'GC_4',
                value = '-G',
                order = {'QCD':1})

GC_5 = Coupling(name = 'GC_5',
                value = 'complex(0,1)*G',
                order = {'QCD':1})

GC_6 = Coupling(name = 'GC_6',
                value = 'complex(0,1)*G**2',
                order = {'QCD':2})

GC_7 = Coupling(name = 'GC_7',
                value = 'cw*complex(0,1)*gw',
                order = {'QED':1})

GC_8 = Coupling(name = 'GC_8',
                value = '-(complex(0,1)*gw**2)',
                order = {'QED':2})

GC_9 = Coupling(name = 'GC_9',
                value = 'cw**2*complex(0,1)*gw**2',
                order = {'QED':2})

GC_10 = Coupling(name = 'GC_10',
                 value = '(ee**2*complex(0,1))/(2.*sw**2)',
                 order = {'QED':2})

GC_11 = Coupling(name = 'GC_11',
                 value = '(ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_12 = Coupling(name = 'GC_12',
                 value = '(CKM11*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_13 = Coupling(name = 'GC_13',
                 value = '(CKM12*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_14 = Coupling(name = 'GC_14',
                 value = '(CKM13*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_15 = Coupling(name = 'GC_15',
                 value = '(CKM21*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_16 = Coupling(name = 'GC_16',
                 value = '(CKM22*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_17 = Coupling(name = 'GC_17',
                 value = '(CKM23*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_18 = Coupling(name = 'GC_18',
                 value = '(CKM31*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_19 = Coupling(name = 'GC_19',
                 value = '(CKM32*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_20 = Coupling(name = 'GC_20',
                 value = '(CKM33*ee*complex(0,1))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_21 = Coupling(name = 'GC_21',
                 value = '-(cw*ee*complex(0,1))/(2.*sw)',
                 order = {'QED':1})

GC_22 = Coupling(name = 'GC_22',
                 value = '(cw*ee*complex(0,1))/(2.*sw)',
                 order = {'QED':1})

GC_23 = Coupling(name = 'GC_23',
                 value = '-(ee*complex(0,1)*sw)/(6.*cw)',
                 order = {'QED':1})

GC_24 = Coupling(name = 'GC_24',
                 value = '(ee*complex(0,1)*sw)/(2.*cw)',
                 order = {'QED':1})

GC_25 = Coupling(name = 'GC_25',
                 value = 'complex(0,1)*gw*sw',
                 order = {'QED':1})

GC_26 = Coupling(name = 'GC_26',
                 value = '-2*cw*complex(0,1)*gw**2*sw',
                 order = {'QED':2})

GC_27 = Coupling(name = 'GC_27',
                 value = 'complex(0,1)*gw**2*sw**2',
                 order = {'QED':2})

GC_28 = Coupling(name = 'GC_28',
                 value = '(cw*ee*complex(0, 1))/(2.*sw) + (ee*complex(0,1)*sw)/(2.*cw)',
                 order = {'QED':1})

GC_29 = Coupling(name = 'GC_29',
                 value = 'ee**2*complex(0,1) + (cw**2*ee**2*complex(0,1))/(2.*sw**2) + (ee**2*complex(0,1)*sw**2)/(2.*cw**2)',
                 order = {'QED':2})

GC_30 = Coupling(name = 'GC_30',
                 value = '-6*complex(0,1)*lam*v',
                 order = {'QED':1})

GC_31 = Coupling(name = 'GC_31',
                 value = '(ee**2*complex(0,1)*v)/(2.*sw**2)',
                 order = {'QED':1})

GC_32 = Coupling(name = 'GC_32',
                 value = 'ee**2*complex(0,1)*v + (cw**2*ee**2*complex(0,1)*v)/(2.*sw**2) + (ee**2*complex(0,1)*sw**2*v)/(2.*cw**2)',
                 order = {'QED':1})

GC_33 = Coupling(name = 'GC_33',
                 value = '-((complex(0,1)*yb)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_34 = Coupling(name = 'GC_34',
                 value = '-((complex(0,1)*yc)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_35 = Coupling(name = 'GC_35',
                 value = '-((complex(0,1)*ye)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_36 = Coupling(name = 'GC_36',
                 value = '-((complex(0,1)*ym)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_37 = Coupling(name = 'GC_37',
                 value = '-((complex(0,1)*yt)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_38 = Coupling(name = 'GC_38',
                 value = '-((complex(0,1)*ytau)/cmath.sqrt(2))',
                 order = {'QED':1})

GC_39 = Coupling(name = 'GC_39',
                 value = '(ee*complex(0,1)*complexconjugate(CKM11))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_40 = Coupling(name = 'GC_40',
                 value = '(ee*complex(0,1)*complexconjugate(CKM12))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_41 = Coupling(name = 'GC_41',
                 value = '(ee*complex(0,1)*complexconjugate(CKM13))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_42 = Coupling(name = 'GC_42',
                 value = '(ee*complex(0,1)*complexconjugate(CKM21))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_43 = Coupling(name = 'GC_43',
                 value = '(ee*complex(0,1)*complexconjugate(CKM22))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_44 = Coupling(name = 'GC_44',
                 value = '(ee*complex(0,1)*complexconjugate(CKM23))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_45 = Coupling(name = 'GC_45',
                 value = '(ee*complex(0,1)*complexconjugate(CKM31))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_46 = Coupling(name = 'GC_46',
                 value = '(ee*complex(0,1)*complexconjugate(CKM32))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})

GC_47 = Coupling(name = 'GC_47',
                 value = '(ee*complex(0,1)*complexconjugate(CKM33))/(sw*cmath.sqrt(2))',
                 order = {'QED':1})


# == Additional coupling for the goldstones for Feynman gauge

GC_1033 = Coupling(name = 'GC_1033',
                 value = '-6*complex(0,1)*lam',
                 order = {'QED':2})

GC_1031 = Coupling(name = 'GC_1031',
                 value = '-2*complex(0,1)*lam',
                 order = {'QED':2})

GC_1032 = Coupling(name = 'GC_1032',
                 value = '-4*complex(0,1)*lam',
                 order = {'QED':2})

GC_1068 = Coupling(name = 'GC_1068',
                 value = '-2*complex(0,1)*lam*v',
                 order = {'QED':1})

GC_1006 = Coupling(name = 'GC_1006',
                value = '2*ee**2*complex(0,1)',
                order = {'QED':2})

GC_1003 = Coupling(name = 'GC_1003',
                value = '-(ee*complex(0,1))',
                order = {'QED':1})

GC_1055 = Coupling(name = 'GC_1055',
                 value = '-(ee**2*complex(0,1))/(2.*sw)',
                 order = {'QED':2})

GC_1054 = Coupling(name = 'GC_1054',
                 value = '-ee**2/(2.*sw)',
                 order = {'QED':2})

GC_1074 = Coupling(name = 'GC_1074',
                 value = '-(ee**2*v)/(2.*sw)',
                 order = {'QED':1})

GC_1039 = Coupling(name = 'GC_1039',
                 value = '(ee*complex(0,1))/(2.*sw)',
                 order = {'QED':1})

GC_1037 = Coupling(name = 'GC_1037',
                 value = '-ee/(2.*sw)',
                 order = {'QED':1})

GC_1056 = Coupling(name = 'GC_1056',
                 value = 'ee**2/(2.*sw)',
                 order = {'QED':2})

GC_1075 = Coupling(name = 'GC_1075',
                 value = '(ee**2*v)/(2.*sw)',
                 order = {'QED':1})

GC_1038 = Coupling(name = 'GC_1038',
                 value = '-(ee*complex(0,1))/(2.*sw)',
                 order = {'QED':1})

GC_1034 = Coupling(name = 'GC_1034',
                 value = '(ee**2*complex(0,1))/(2.*sw**2)',
                 order = {'QED':2})

GC_1063 = Coupling(name = 'GC_1063',
                 value = '(cw*ee**2*complex(0,1))/sw - (ee**2*complex(0,1)*sw)/cw',
                 order = {'QED':2})

GC_1060 = Coupling(name = 'GC_1060',
                 value = '-(cw*ee)/(2.*sw) - (ee*sw)/(2.*cw)',
                 order = {'QED':1})

GC_1061 = Coupling(name = 'GC_1061',
                 value = '-(cw*ee*complex(0,1))/(2.*sw) + (ee*complex(0,1)*sw)/(2.*cw)',
                 order = {'QED':1})

GC_1008 = Coupling(name = 'GC_1008',
                value = '(ee**2*complex(0,1))/(2.*cw)',
                order = {'QED':2})

GC_1009 = Coupling(name = 'GC_1009',
                value = 'ee**2/(2.*cw)',
                order = {'QED':2})

GC_1067 = Coupling(name = 'GC_1067',
                 value = '(ee**2*v)/(2.*cw)',
                 order = {'QED':1})

GC_1007 = Coupling(name = 'GC_1007',
                value = '-ee**2/(2.*cw)',
                order = {'QED':2})

GC_1066 = Coupling(name = 'GC_1066',
                 value = '-(ee**2*v)/(2.*cw)',
                 order = {'QED':1})

GC_1065 = Coupling(name = 'GC_1065',
                 value = 'ee**2*complex(0,1) + (cw**2*ee**2*complex(0,1))/(2.*sw**2) + (ee**2*complex(0,1)*sw**2)/(2.*cw**2)',
                 order = {'QED':2})

GC_1064 = Coupling(name = 'GC_1064',
                 value = '-(ee**2*complex(0,1)) + (cw**2*ee**2*complex(0,1))/(2.*sw**2) + (ee**2*complex(0,1)*sw**2)/(2.*cw**2)',
                 order = {'QED':2})

GC_1082 = Coupling(name = 'GC_1082',
                 value = '-(yb/cmath.sqrt(2))',
                 order = {'QED':1})

GC_1016 = Coupling(name = 'GC_1016',
                 value = '-I2x12',
                 order = {'QED':1})

GC_1017 = Coupling(name = 'GC_1017',
                 value = '-I2x13',
                 order = {'QED':1})

GC_1018 = Coupling(name = 'GC_1018',
                 value = '-I2x22',
                 order = {'QED':1})

GC_1019 = Coupling(name = 'GC_1019',
                 value = '-I2x23',
                 order = {'QED':1})

GC_1013 = Coupling(name = 'GC_1013',
                 value = 'I1x31',
                 order = {'QED':1})

GC_1014 = Coupling(name = 'GC_1014',
                 value = 'I1x32',
                 order = {'QED':1})

GC_1020 = Coupling(name = 'GC_1020',
                 value = '-I2x32',
                 order = {'QED':1})

GC_1015 = Coupling(name = 'GC_1015',
                 value = 'I1x33',
                 order = {'QED':1})

GC_1021 = Coupling(name = 'GC_1021',
                 value = '-I2x33',
                 order = {'QED':1})

GC_1088 = Coupling(name = 'GC_1088',
                 value = '-(ye/cmath.sqrt(2))',
                 order = {'QED':1})

GC_1092 = Coupling(name = 'GC_1092',
                 value = '-(ym/cmath.sqrt(2))',
                 order = {'QED':1})

GC_1098 = Coupling(name = 'GC_1098',
                 value = '-(ytau/cmath.sqrt(2))',
                 order = {'QED':1})

GC_1087 = Coupling(name = 'GC_1087',
                 value = 'ye',
                 order = {'QED':1})

GC_1091 = Coupling(name = 'GC_1091',
                 value = 'ym',
                 order = {'QED':1})

GC_1097 = Coupling(name = 'GC_1097',
                 value = 'ytau',
                 order = {'QED':1})

GC_1028 = Coupling(name = 'GC_1028',
                 value = '-I4x13',
                 order = {'QED':1})

GC_1022 = Coupling(name = 'GC_1022',
                 value = 'I3x21',
                 order = {'QED':1})

GC_1023 = Coupling(name = 'GC_1023',
                 value = 'I3x22',
                 order = {'QED':1})

GC_1024 = Coupling(name = 'GC_1024',
                 value = 'I3x23',
                 order = {'QED':1})

GC_1025 = Coupling(name = 'GC_1025',
                 value = 'I3x31',
                 order = {'QED':1})

GC_1029 = Coupling(name = 'GC_1029',
                 value = '-I4x23',
                 order = {'QED':1})

GC_1026 = Coupling(name = 'GC_1026',
                 value = 'I3x32',
                 order = {'QED':1})

GC_1027 = Coupling(name = 'GC_1027',
                 value = 'I3x33',
                 order = {'QED':1})

GC_1030 = Coupling(name = 'GC_1030',
                 value = '-I4x33',
                 order = {'QED':1})

GC_1085 = Coupling(name = 'GC_1085',
                 value = 'yc/cmath.sqrt(2)',
                 order = {'QED':1})

GC_1095 = Coupling(name = 'GC_1095',
                 value = 'yt/cmath.sqrt(2)',
                 order = {'QED':1})

GC_1086 = Coupling(name = 'GC_1086',
                 value = '-ye',
                 order = {'QED':1})

GC_1090 = Coupling(name = 'GC_1090',
                 value = '-ym',
                 order = {'QED':1})

GC_1096 = Coupling(name = 'GC_1096',
                 value = '-ytau',
                 order = {'QED':1})
