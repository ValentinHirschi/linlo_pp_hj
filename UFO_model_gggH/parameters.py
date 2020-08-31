# This file was automatically created by FeynRules $Revision: 634 $
# Mathematica version: 8.0 for Mac OS X x86 (64-bit) (November 6, 2010)
# Date: Wed 6 Jul 2011 14:07:37


from object_library import all_parameters, Parameter


from function_library import complexconjugate, re, im, csc, sec, acsc, asec


# This is a default parameter object representing 0.
ZERO = Parameter(name='ZERO',
                 nature='internal',
                 type='real',
                 value='0.0',
                 texname='0')
# Loop related parameters

lhv = Parameter(name='lhv',
                nature='internal',
                type='real',
                value='1.0',
                texname='\lambda_{HV}')

Ncol = Parameter(name='Ncol',
                 nature='internal',
                 type='real',
                 value='3.0',
                 texname='N_{col}')

CA = Parameter(name='CA',
               nature='internal',
               type='real',
               value='3.0',
               texname='C_{A}')

TF = Parameter(name='TF',
               nature='internal',
               type='real',
               value='0.5',
               texname='T_{F}')

CF = Parameter(name='CF',
               nature='internal',
               type='real',
               value='(4.0/3.0)',
               texname='C_{F}')

MU_R = Parameter(name='MU_R',
                 nature='external',
                 type='real',
                 value=125.09,
                 # value=91.188,
                 texname='\\text{\\mu_r}',
                 lhablock='LOOP',
                 lhacode=[1])

# User-defined parameters.
aEWM1 = Parameter(name='aEWM1',
                  nature='external',
                  type='real',
                  value=132.50698,
                  texname='\\text{aEWM1}',
                  lhablock='SMINPUTS',
                  lhacode=[1])

Gf = Parameter(name='Gf',
               nature='external',
               type='real',
               value=0.0000116639,
               texname='G_f',
               lhablock='SMINPUTS',
               lhacode=[2])

aS = Parameter(name='aS',
               nature='external',
               type='real',
               value=0.118,
               texname='\\text{aS}',
               lhablock='SMINPUTS',
               lhacode=[3])

lamWS = Parameter(name='lamWS',
                  nature='external',
                  type='real',
                  value=0.2253,
                  texname='\\text{lamWS}',
                  lhablock='Wolfenstein',
                  lhacode=[1])

AWS = Parameter(name='AWS',
                nature='external',
                type='real',
                value=0.808,
                texname='\\text{AWS}',
                lhablock='Wolfenstein',
                lhacode=[2])

rhoWS = Parameter(name='rhoWS',
                  nature='external',
                  type='real',
                  value=0.132,
                  texname='\\text{rhoWS}',
                  lhablock='Wolfenstein',
                  lhacode=[3])

etaWS = Parameter(name='etaWS',
                  nature='external',
                  type='real',
                  value=0.341,
                  texname='\\text{etaWS}',
                  lhablock='Wolfenstein',
                  lhacode=[4])

ymc = Parameter(name='ymc',
                nature='external',
                type='real',
                value=1.27,
                texname='\\text{ymc}',
                lhablock='YUKAWA',
                lhacode=[4])

ymb = Parameter(name='ymb',
                nature='external',
                type='real',
                value=4.2,
                texname='\\text{ymb}',
                lhablock='YUKAWA',
                lhacode=[5])

ymt = Parameter(name='ymt',
                nature='external',
                type='real',
                value=172.0,
                texname='\\text{ymt}',
                lhablock='YUKAWA',
                lhacode=[6])

yme = Parameter(name='yme',
                nature='external',
                type='real',
                value=0.0005110000000000001,
                texname='\\text{yme}',
                lhablock='YUKAWA',
                lhacode=[11])

ymm = Parameter(name='ymm',
                nature='external',
                type='real',
                value=0.10566,
                texname='\\text{ymm}',
                lhablock='YUKAWA',
                lhacode=[13])

ymtau = Parameter(name='ymtau',
                  nature='external',
                  type='real',
                  value=1.777,
                  texname='\\text{ymtau}',
                  lhablock='YUKAWA',
                  lhacode=[15])

MC = Parameter(name='MC',
               nature='external',
               type='real',
               value=1.42,
               texname='\\text{MC}',
               lhablock='MASS',
               lhacode=[4])

MT = Parameter(name='MT',
               nature='external',
               type='real',
               value=172.,
               texname='\\text{MT}',
               lhablock='MASS',
               lhacode=[6])

MB = Parameter(name='MB',
               nature='external',
               type='real',
               value=4.7,
               texname='\\text{MB}',
               lhablock='MASS',
               lhacode=[5])

MZ = Parameter(name='MZ',
               nature='external',
               type='real',
               value=91.1876,
               texname='\\text{MZ}',
               lhablock='MASS',
               lhacode=[23])

MH = Parameter(name='MH',
               nature='external',
               type='real',
               value=125.09,
               texname='\\text{MH}',
               lhablock='MASS',
               lhacode=[25])

Me = Parameter(name='Me',
               nature='external',
               type='real',
               value=0.0005110000000000001,
               texname='\\text{Me}',
               lhablock='MASS',
               lhacode=[11])

MM = Parameter(name='MM',
               nature='external',
               type='real',
               value=0.10566,
               texname='\\text{MM}',
               lhablock='MASS',
               lhacode=[13])

MTA = Parameter(name='MTA',
                nature='external',
                type='real',
                value=1.777,
                texname='\\text{MTA}',
                lhablock='MASS',
                lhacode=[15])

WT = Parameter(name='WT',
               nature='external',
               type='real',
               value=1.50833649,
               texname='\\text{WT}',
               lhablock='DECAY',
               lhacode=[6])

WZ = Parameter(name='WZ',
               nature='external',
               type='real',
               value=2.44140351,
               texname='\\text{WZ}',
               lhablock='DECAY',
               lhacode=[23])

WW = Parameter(name='WW',
               nature='external',
               type='real',
               value=2.04759951,
               texname='\\text{WW}',
               lhablock='DECAY',
               lhacode=[24])

WH = Parameter(name='WH',
               nature='external',
               type='real',
               value=6.38233934e-03,
               texname='\\text{WH}',
               lhablock='DECAY',
               lhacode=[25])

WTau = Parameter(name='WTau',
                 nature='external',
                 type='real',
                 value=2.27e-12,
                 texname='\\text{WTau}',
                 lhablock='DECAY',
                 lhacode=[15])

CKM11 = Parameter(name='CKM11',
                  nature='internal',
                  type='complex',
                  value='1 - lamWS**2/2.',
                  texname='\\text{CKM11}')

CKM12 = Parameter(name='CKM12',
                  nature='internal',
                  type='complex',
                  value='lamWS',
                  texname='\\text{CKM12}')

CKM13 = Parameter(name='CKM13',
                  nature='internal',
                  type='complex',
                  value='AWS*lamWS**3*(-(etaWS*complex(0,1)) + rhoWS)',
                  texname='\\text{CKM13}')

CKM21 = Parameter(name='CKM21',
                  nature='internal',
                  type='complex',
                  value='-lamWS',
                  texname='\\text{CKM21}')

CKM22 = Parameter(name='CKM22',
                  nature='internal',
                  type='complex',
                  value='1 - lamWS**2/2.',
                  texname='\\text{CKM22}')

CKM23 = Parameter(name='CKM23',
                  nature='internal',
                  type='complex',
                  value='AWS*lamWS**2',
                  texname='\\text{CKM23}')

CKM31 = Parameter(name='CKM31',
                  nature='internal',
                  type='complex',
                  value='AWS*lamWS**3*(1 - etaWS*complex(0,1) - rhoWS)',
                  texname='\\text{CKM31}')

CKM32 = Parameter(name='CKM32',
                  nature='internal',
                  type='complex',
                  value='-(AWS*lamWS**2)',
                  texname='\\text{CKM32}')

CKM33 = Parameter(name='CKM33',
                  nature='internal',
                  type='complex',
                  value='1',
                  texname='\\text{CKM33}')

aEW = Parameter(name='aEW',
                nature='internal',
                type='real',
                value='1/aEWM1',
                texname='\\text{aEW}')

G = Parameter(name='G',
              nature='internal',
              type='real',
              value='2*cmath.sqrt(aS)*cmath.sqrt(cmath.pi)',
              texname='G')

MW = Parameter(name='MW',
               nature='internal',
               type='real',
               #value='80.385',
               value='cmath.sqrt(MZ**2/2. + cmath.sqrt(MZ**4/4. - (aEW*cmath.pi*MZ**2)/(Gf*cmath.sqrt(2))))',
               texname='M_W')

ee = Parameter(name='ee',
               nature='internal',
               type='real',
               value='2*cmath.sqrt(aEW)*cmath.sqrt(cmath.pi)',
               texname='e')

sw2 = Parameter(name='sw2',
                nature='internal',
                type='real',
                value='1 - MW**2/MZ**2',
                texname='\\text{sw2}')

cw = Parameter(name='cw',
               nature='internal',
               type='real',
               value='cmath.sqrt(1 - sw2)',
               texname='c_w')

sw = Parameter(name='sw',
               nature='internal',
               type='real',
               value='cmath.sqrt(sw2)',
               texname='s_w')

g1 = Parameter(name='g1',
               nature='internal',
               type='real',
               value='ee/cw',
               texname='g_1')

gw = Parameter(name='gw',
               nature='internal',
               type='real',
               value='ee/sw',
               texname='g_w')

v = Parameter(name='v',
              nature='internal',
              type='real',
              value='(2*MW*sw)/ee',
              texname='v')

lam = Parameter(name='lam',
                nature='internal',
                type='real',
                value='MH**2/(2.*v**2)',
                texname='\\text{lam}')

yb = Parameter(name='yb',
               nature='internal',
               type='real',
               value='(ymb*cmath.sqrt(2))/v',
               texname='\\text{yb}')

yc = Parameter(name='yc',
               nature='internal',
               type='real',
               value='(ymc*cmath.sqrt(2))/v',
               texname='\\text{yc}')

ye = Parameter(name='ye',
               nature='internal',
               type='real',
               value='(yme*cmath.sqrt(2))/v',
               texname='\\text{ye}')

ym = Parameter(name='ym',
               nature='internal',
               type='real',
               value='(ymm*cmath.sqrt(2))/v',
               texname='\\text{ym}')

yt = Parameter(name='yt',
               nature='internal',
               type='real',
               value='(ymt*cmath.sqrt(2))/v',
               texname='\\text{yt}')

ytau = Parameter(name='ytau',
                 nature='internal',
                 type='real',
                 value='(ymtau*cmath.sqrt(2))/v',
                 texname='\\text{ytau}')

muH = Parameter(name='muH',
                nature='internal',
                type='real',
                value='cmath.sqrt(lam*v**2)',
                texname='\\mu')

# To facilitate R2 writings

AxialZUp = Parameter(name='AxialZUp',
                     nature='internal',
                     type='real',
                     value='(3.0/2.0)*(-(ee*sw)/(6.*cw))-(1.0/2.0)*((cw*ee)/(2.*sw))',
                     texname='AxialZUp')

AxialZDown = Parameter(name='AxialZDown',
                       nature='internal',
                       type='real',
                       value='(-1.0/2.0)*(-(cw*ee)/(2.*sw))+(-3.0/2.0)*(-(ee*sw)/(6.*cw))',
                       texname='AxialZdown')

VectorZUp = Parameter(name='VectorZUp',
                      nature='internal',
                      type='real',
                      value='(1.0/2.0)*((cw*ee)/(2.*sw))+(5.0/2.0)*(-(ee*sw)/(6.*cw))',
                      texname='AxialZUp')

VectorZDown = Parameter(name='VectorZDown',
                        nature='internal',
                        type='real',
                        value='(1.0/2.0)*(-(cw*ee)/(2.*sw))+(-1.0/2.0)*(-(ee*sw)/(6.*cw))',
                        texname='AxialZdown')

VectorAUp = Parameter(name='VectorAUp',
                      nature='internal',
                      type='real',
                      value='(2*ee)/3.',
                      texname='VectorAUp')

VectorADown = Parameter(name='VectorADown',
                        nature='internal',
                        type='real',
                        value='-(ee)/3.',
                        texname='VectorADown')

VectorWmDxU = Parameter(name='VectorWmDxU',
                        nature='internal',
                        type='real',
                        value='(1.0/2.0)*((ee)/(sw*cmath.sqrt(2)))',
                        texname='VectorWmDxU')

AxialWmDxU = Parameter(name='AxialWmDxU',
                       nature='internal',
                       type='real',
                       value='(-1.0/2.0)*((ee)/(sw*cmath.sqrt(2)))',
                       texname='AxialWmDxU')

VectorWpUxD = Parameter(name='VectorWpUxD',
                        nature='internal',
                        type='real',
                        value='(1.0/2.0)*((ee)/(sw*cmath.sqrt(2)))',
                        texname='VectorWpUxD')

AxialWpUxD = Parameter(name='AxialWpUxD',
                       nature='internal',
                       type='real',
                       value='-(1.0/2.0)*((ee)/(sw*cmath.sqrt(2)))',
                       texname='AxialWpUxD')

# == Additional parameters for goldstones

CKM1x1 = Parameter(name='CKM1x1',
                   nature='internal',
                   type='complex',
                   value='1 - lamWS**2/2.',
                   texname='\\text{CKM1x1}')

CKM1x2 = Parameter(name='CKM1x2',
                   nature='internal',
                   type='complex',
                   value='lamWS',
                   texname='\\text{CKM1x2}')

CKM1x3 = Parameter(name='CKM1x3',
                   nature='internal',
                   type='complex',
                   value='AWS*lamWS**3*(-(etaWS*complex(0,1)) + rhoWS)',
                   texname='\\text{CKM1x3}')

CKM2x1 = Parameter(name='CKM2x1',
                   nature='internal',
                   type='complex',
                   value='-lamWS',
                   texname='\\text{CKM2x1}')

CKM2x2 = Parameter(name='CKM2x2',
                   nature='internal',
                   type='complex',
                   value='1 - lamWS**2/2.',
                   texname='\\text{CKM2x2}')

CKM2x3 = Parameter(name='CKM2x3',
                   nature='internal',
                   type='complex',
                   value='AWS*lamWS**2',
                   texname='\\text{CKM2x3}')

CKM3x1 = Parameter(name='CKM3x1',
                   nature='internal',
                   type='complex',
                   value='AWS*lamWS**3*(1 - etaWS*complex(0,1) - rhoWS)',
                   texname='\\text{CKM3x1}')

CKM3x2 = Parameter(name='CKM3x2',
                   nature='internal',
                   type='complex',
                   value='-(AWS*lamWS**2)',
                   texname='\\text{CKM3x2}')

CKM3x3 = Parameter(name='CKM3x3',
                   nature='internal',
                   type='complex',
                   value='1',
                   texname='\\text{CKM3x3}')

I1x31 = Parameter(name='I1x31',
                  nature='internal',
                  type='complex',
                  value='yb*complexconjugate(CKM1x3)',
                  texname='\\text{I1x31}')

I1x32 = Parameter(name='I1x32',
                  nature='internal',
                  type='complex',
                  value='yb*complexconjugate(CKM2x3)',
                  texname='\\text{I1x32}')

I1x33 = Parameter(name='I1x33',
                  nature='internal',
                  type='complex',
                  value='yb*complexconjugate(CKM3x3)',
                  texname='\\text{I1x33}')

I2x12 = Parameter(name='I2x12',
                  nature='internal',
                  type='complex',
                  value='yc*complexconjugate(CKM2x1)',
                  texname='\\text{I2x12}')

I2x13 = Parameter(name='I2x13',
                  nature='internal',
                  type='complex',
                  value='yt*complexconjugate(CKM3x1)',
                  texname='\\text{I2x13}')

I2x22 = Parameter(name='I2x22',
                  nature='internal',
                  type='complex',
                  value='yc*complexconjugate(CKM2x2)',
                  texname='\\text{I2x22}')

I2x23 = Parameter(name='I2x23',
                  nature='internal',
                  type='complex',
                  value='yt*complexconjugate(CKM3x2)',
                  texname='\\text{I2x23}')

I2x32 = Parameter(name='I2x32',
                  nature='internal',
                  type='complex',
                  value='yc*complexconjugate(CKM2x3)',
                  texname='\\text{I2x32}')

I2x33 = Parameter(name='I2x33',
                  nature='internal',
                  type='complex',
                  value='yt*complexconjugate(CKM3x3)',
                  texname='\\text{I2x33}')

I3x21 = Parameter(name='I3x21',
                  nature='internal',
                  type='complex',
                  value='CKM2x1*yc',
                  texname='\\text{I3x21}')

I3x22 = Parameter(name='I3x22',
                  nature='internal',
                  type='complex',
                  value='CKM2x2*yc',
                  texname='\\text{I3x22}')

I3x23 = Parameter(name='I3x23',
                  nature='internal',
                  type='complex',
                  value='CKM2x3*yc',
                  texname='\\text{I3x23}')

I3x31 = Parameter(name='I3x31',
                  nature='internal',
                  type='complex',
                  value='CKM3x1*yt',
                  texname='\\text{I3x31}')

I3x32 = Parameter(name='I3x32',
                  nature='internal',
                  type='complex',
                  value='CKM3x2*yt',
                  texname='\\text{I3x32}')

I3x33 = Parameter(name='I3x33',
                  nature='internal',
                  type='complex',
                  value='CKM3x3*yt',
                  texname='\\text{I3x33}')

I4x13 = Parameter(name='I4x13',
                  nature='internal',
                  type='complex',
                  value='CKM1x3*yb',
                  texname='\\text{I4x13}')

I4x23 = Parameter(name='I4x23',
                  nature='internal',
                  type='complex',
                  value='CKM2x3*yb',
                  texname='\\text{I4x23}')

I4x33 = Parameter(name='I4x33',
                  nature='internal',
                  type='complex',
                  value='CKM3x3*yb',
                  texname='\\text{I4x33}')

Vector_ubGp = Parameter(name='Vector_ubGp',
                        nature='internal',
                        type='complex',
                        value='I1x31',
                        texname='\\text{Vector_ubGp}')

Vector_cdGp = Parameter(name='Vector_cdGp',
                        nature='internal',
                        type='complex',
                        value='-I2x12',
                        texname='\\text{Vector_cdGp}')

Vector_csGp = Parameter(name='Vector_csGp',
                        nature='internal',
                        type='complex',
                        value='-I2x22',
                        texname='\\text{Vector_csGp}')

Vector_cbGp = Parameter(name='Vector_cbGp',
                        nature='internal',
                        type='complex',
                        value='I1x32-I2x32',
                        texname='\\text{Vector_cbGp}')

Vector_tdGp = Parameter(name='Vector_tdGp',
                        nature='internal',
                        type='complex',
                        value='-I2x13',
                        texname='\\text{Vector_tdGp}')

Vector_tsGp = Parameter(name='Vector_tsGp',
                        nature='internal',
                        type='complex',
                        value='-I2x23',
                        texname='\\text{Vector_tsGp}')

Vector_tbGp = Parameter(name='Vector_tbGp',
                        nature='internal',
                        type='complex',
                        value='I1x33-I2x33',
                        texname='\\text{Vector_tbGp}')

Axial_ubGp = Parameter(name='Axial_ubGp',
                       nature='internal',
                       type='complex',
                       value='-I1x31',
                       texname='\\text{Axial_ubGp}')

Axial_cdGp = Parameter(name='Axial_cdGp',
                       nature='internal',
                       type='complex',
                       value='-I2x12',
                       texname='\\text{Axial_cdGp}')

Axial_csGp = Parameter(name='Axial_csGp',
                       nature='internal',
                       type='complex',
                       value='-I2x22',
                       texname='\\text{Axial_csGp}')

Axial_cbGp = Parameter(name='Axial_cbGp',
                       nature='internal',
                       type='complex',
                       value='-I2x32-I1x32',
                       texname='\\text{Axial_cbGp}')

Axial_tdGp = Parameter(name='Axial_tdGp',
                       nature='internal',
                       type='complex',
                       value='-I2x13',
                       texname='\\text{Axial_tdGp}')

Axial_tsGp = Parameter(name='Axial_tsGp',
                       nature='internal',
                       type='complex',
                       value='-I2x23',
                       texname='\\text{Axial_tsGp}')

Axial_tbGp = Parameter(name='Axial_tbGp',
                       nature='internal',
                       type='complex',
                       value='-I2x33-I1x33',
                       texname='\\text{Axial_tbGp}')

Vector_ubGm = Parameter(name='Vector_ubGm',
                        nature='internal',
                        type='complex',
                        value='-I4x13',
                        texname='\\text{Vector_ubGm}')

Vector_cdGm = Parameter(name='Vector_cdGm',
                        nature='internal',
                        type='complex',
                        value='I3x21',
                        texname='\\text{Vector_cdGm}')

Vector_csGm = Parameter(name='Vector_csGm',
                        nature='internal',
                        type='complex',
                        value='I3x22',
                        texname='\\text{Vector_csGm}')

Vector_cbGm = Parameter(name='Vector_cbGm',
                        nature='internal',
                        type='complex',
                        value='I3x23-I4x23',
                        texname='\\text{Vector_cbGm}')

Vector_tdGm = Parameter(name='Vector_tdGm',
                        nature='internal',
                        type='complex',
                        value='I3x31',
                        texname='\\text{Vector_tdGm}')

Vector_tsGm = Parameter(name='Vector_tsGm',
                        nature='internal',
                        type='complex',
                        value='I3x32',
                        texname='\\text{Vector_tsGm}')

Vector_tbGm = Parameter(name='Vector_tbGm',
                        nature='internal',
                        type='complex',
                        value='I3x33-I4x33',
                        texname='\\text{Vector_tbGm}')

Axial_ubGm = Parameter(name='Axial_ubGm',
                       nature='internal',
                       type='complex',
                       value='-I4x13',
                       texname='\\text{Axial_ubGm}')

Axial_cdGm = Parameter(name='Axial_cdGm',
                       nature='internal',
                       type='complex',
                       value='-I3x21',
                       texname='\\text{Axial_cdGm}')

Axial_csGm = Parameter(name='Axial_csGm',
                       nature='internal',
                       type='complex',
                       value='-I3x22',
                       texname='\\text{Axial_csGm}')

Axial_cbGm = Parameter(name='Axial_cbGm',
                       nature='internal',
                       type='complex',
                       value='-I4x23-I3x23',
                       texname='\\text{Axial_cbGm}')

Axial_tdGm = Parameter(name='Axial_tdGm',
                       nature='internal',
                       type='complex',
                       value='-I3x31',
                       texname='\\text{Axial_tdGm}')

Axial_tsGm = Parameter(name='Axial_tsGm',
                       nature='internal',
                       type='complex',
                       value='-I3x32',
                       texname='\\text{Axial_tsGm}')

Axial_tbGm = Parameter(name='Axial_tbGm',
                       nature='internal',
                       type='complex',
                       value='-I4x33-I3x33',
                       texname='\\text{Axial_tbGm}')


LZCouplingUp = Parameter(name='LZCouplingUp',
                         nature='internal',
                         type='complex',
                         value='(1./2.-(sw2)*(2.0/3.0))/(cw*sw)',
                         texname='LZCouplingUp')

LZCouplingDown = Parameter(name='LZCouplingDown',
                           nature='internal',
                           type='complex',
                           value='(-1./2.-(sw2)*(-1.0/3.0))/(cw*sw)',
                           texname='LZCouplingDown')

RZCouplingUp = Parameter(name='RZCouplingUp',
                         nature='internal',
                         type='complex',
                         value='(-sw*(2.0/3.0))/cw',
                         texname='RZCouplingUp')

RZCouplingDown = Parameter(name='RZCouplingDown',
                           nature='internal',
                           type='complex',
                           value='(-sw*(-1.0/3.0))/cw',
                           texname='RZCouplingDown')

LWCoupling = Parameter(name='LWCoupling',
                       nature='internal',
                       type='complex',
                       value='1./(sw*cmath.sqrt(2))',
                       texname='LWCoupling')
# ===============================================================================
# Overall Coupling for GG->HX in infinite t-mass HEFT.
# ===============================================================================


# gg >h NLO n_loops allows for selection of LO or NLO
n_loops_HEFT = Parameter(name='n_loops_HEFT',
                         nature='external',
                         type='real',
                         value=1.0,
                         texname='\\text{n_loops_HEFT}',
                         lhablock='GGHHEFT',
                         lhacode=[19998])

# gg >h epsorder allows for selection of eps pole in NLO
eps_order_HEFT = Parameter(name='eps_order_HEFT',
                           nature='external',
                           type='real',
                           value=0.0,
                           texname='\\text{eps_order_HEFT}',
                           lhablock='GGHHEFT',
                           lhacode=[19999])

# wilson coefficient for infinite top heft
CHEFT = Parameter(name='CHEFT',
                  nature='internal',
                  type='complex',
                  value='-aS/(3.*cmath.pi*v)',
                  texname='AllGGHEWCoup',
                  lhablock='GGHEFT',
                  lhacode=[20000])


GGH_HEFT1L_EP0_RE = Parameter(name='GGH_HEFT1L_EP0_RE',
                              nature='external',
                              type='complex',
                              value=20.001,
                              texname='\\text{GGH_HEFT1L_EP0_RE}',
                              lhablock='GGHHEFT',
                              lhacode=[20001])

GGH_HEFT1L_EP0_IM = Parameter(name='GGH_HEFT1L_EP0_IM',
                              nature='external',
                              type='complex',
                              value=20.002,
                              texname='\\text{GGH_HEFT1L_EP0_IM}',
                              lhablock='GGHHEFT',
                              lhacode=[20002])
GGH_HEFT1L_EPM1_RE = Parameter(name='GGH_HEFT1L_EPM1_RE',
                               nature='external',
                               type='complex',
                               value=20.003,
                               texname='\\text{GGH_HEFT1L_EPM1_RE}',
                               lhablock='GGHHEFT',
                               lhacode=[20003])
GGH_HEFT1L_EPM1_IM = Parameter(name='GGH_HEFT1L_EPM1_IM',
                               nature='external',
                               type='complex',
                               value=20.004,
                               texname='\\text{GGH_HEFT1L_EPM1_IM}',
                               lhablock='GGHHEFT',
                               lhacode=[20004])
GGH_HEFT1L_EPM2_RE = Parameter(name='GGH_HEFT1L_EPM2_RE',
                               nature='external',
                               type='complex',
                               value=20.005,
                               texname='\\text{GGH_HEFT1L_EPM2_RE}',
                               lhablock='GGHHEFT',
                               lhacode=[20005])

GGH_HEFT_LO = Parameter(name='GGH_HEFT_LO',
                        nature='external',
                        type='complex',
                        value=20.006,
                        texname='\\text{GGH_HEFT_LO}',
                        lhablock='GGHHEFT',
                               lhacode=[20006])
# gg>hg
GGGH_HEFT_ForFac1 = Parameter(name='GGGH_HEFT_ForFac1',
                              nature='external',
                              type='complex',
                              value=30.001,
                              texname='\\text{GGGH_HEFT_ForFac1}',
                              lhablock='GGGHHEFT',
                              lhacode=[30001])
GGGH_HEFT_ForFac2 = Parameter(name='GGGH_HEFT_ForFac2',
                              nature='external',
                              type='complex',
                              value=30.002,
                              texname='\\text{GGGH_HEFT_ForFac2}',
                              lhablock='GGGHHEFT',
                              lhacode=[30002])
GGGH_HEFT_ForFac3 = Parameter(name='GGGH_HEFT_ForFac3',
                              nature='external',
                              type='complex',
                              value=30.003,
                              texname='\\text{GGGH_HEFT_ForFac3}',
                              lhablock='GGGHHEFT',
                              lhacode=[30003])
GGGH_HEFT_ForFac4 = Parameter(name='GGGH_HEFT_ForFac4',
                              nature='external',
                              type='complex',
                              value=30.004,
                              texname='\\text{GGGH_HEFT_ForFac4}',
                              lhablock='GGGHHEFT',
                              lhacode=[30004])
# ===============================================================================
# Overall Coupling for GGH EW. We use 1711.1113v2 eq (6.3)
# ===============================================================================
# Z-exchange
CZew = Parameter(name='CZew',
                 nature='internal',
                 type='complex',
                 value='(2./cw**4*(5./4.-7./3.*sw2+22./9.*sw2**2))',
                 texname='CZew',
                 lhablock='EW',
                 lhacode=[22200]
                 )
AllGGHEWZZCoup2L = Parameter(name='AllGGHEWZZCoup2L',
                             nature='internal',
                             type='complex',
                             value='-complex(0,1)*aEW**2*aS*v/(64.*cmath.pi*sw2**2)*CZew',
                             texname='AllGGHEWCoup',
                             lhablock='GGHEWZZ',
                             lhacode=[22000])
# W exchange
AllGGHEWWWCoup2L = Parameter(name='AllGGHEWWWCoup2L',
                             nature='internal',
                             type='complex',
                             value='-complex(0,1)*aEW**2*aS*v/(64.*cmath.pi*sw2**2)*(4.)',
                             texname='AllGGGHEWWWCoup',
                             lhablock='GGHEWWW',
                             lhacode=[33000])
# Z-exchange
AllGGHEWZZCoup3L = Parameter(name='AllGGHEWZZCoup3L',
                             nature='internal',
                             type='complex',
                             value='AllGGHEWZZCoup2L*aS/(2.*cmath.pi)',
                             texname='AllGGHEWCoup',
                             lhablock='GGHEWZZ',
                             lhacode=[44000])
# W exchange
AllGGHEWWWCoup3L = Parameter(name='AllGGHEWWWCoup3L',
                             nature='internal',
                             type='complex',
                             value='AllGGHEWWWCoup2L*aS/(2.*cmath.pi)',
                             texname='AllGGGHEWWWCoup',
                             lhablock='GGHEWWW',
                             lhacode=[55000])

# ===============================================================================
# Overall Coupling for GGGH
# ===============================================================================
# my color factor is -Tr[T^a T^b T^c]+Tr[T^a T^c T^b] = 1/2 i f^abc
# therefore I include a 1/2 i
# QCD
AllGGGHQCDCoup = Parameter(name='AllGGGHQCDCoup',
                           nature='internal',
                           type='complex',
                           value='((complex(0,1)*yt)/cmath.sqrt(2))*G**3',
                           texname='AllGGGHQCDCoup',
                           lhablock='GGGHQCD',
                           lhacode=[66000])
# Z-exchange
AllGGGHEWZZCoup = Parameter(name='AllGGGHEWZZCoup',
                            nature='internal',
                            type='complex',
                            value='0.5*complex(0,1)*G**3*gw**3*MW/cw**4*(5./8. - (7.*sw**2)/6. + (11.*sw**4)/9.)',
                            texname='AllGGGHEWCoup',
                            lhablock='GGGHEWZZ',
                            lhacode=[77000])
# W exchange
AllGGGHEWZZCoup = Parameter(name='AllGGGHEWWWCoup',
                            nature='internal',
                            type='complex',
                            value='0.5*complex(0,1)*G**3*gw**3*MW',
                            texname='AllGGGHEWWWCoup',
                            lhablock='GGGHEWWW',
                            lhacode=[88000])
# ===============================================================================
# Form Factors for ggH
# ===============================================================================
n_loops_EW = Parameter(name='n_loops_EW',
                       nature='external',
                       type='real',
                       value=99,
                       texname='\\text{n_loops_EW}',
                       lhablock='GGHEW',
                       lhacode=[22011])

# eps_order_EW=Parameter(name='eps_order_EW',
#                         nature='external',
#                         type='real',
#                         value=1,
#                         texname='\\text{eps_order_EW}',
#                         lhablock='GGHEW',
#                         lhacode=[22022])

# 2-Loop
# Z-exchange
GGHEWZZ2L_ForFac1_RE = Parameter(name='GGHEWZZ2L_ForFac1_RE',
                                 nature='external',
                                 type='complex',
                                 value=22.001,
                                 texname='\\text{GGHEWZZ2L_ForFac1_RE}',
                                 lhablock='GGHEWZZ',
                                 lhacode=[22001])
GGHEWZZ2L_ForFac1_IM = Parameter(name='GGHEWZZ2L_ForFac1_IM',
                                 nature='external',
                                 type='complex',
                                 value=22.002,
                                 texname='\\text{GGHEWZZ2L_ForFac1_IM}',
                                 lhablock='GGHEWZZ',
                                 lhacode=[22002])
# W-exchange
GGHEWWW2L_ForFac1_RE = Parameter(name='GGHEWWW2L_ForFac1_RE',
                                 nature='external',
                                 type='complex',
                                 value=33.001,
                                 texname='\\text{GGHEWWW2L_ForFac1_RE}',
                                 lhablock='GGHEWWW',
                                 lhacode=[33001])
GGHEWWW2L_ForFac1_IM = Parameter(name='GGHEWWW2L_ForFac1_IM',
                                 nature='external',
                                 type='complex',
                                 value=33.002,
                                 texname='\\text{GGHEWWW2L_ForFac1_IM}',
                                 lhablock='GGHEWWW',
                                 lhacode=[33002])
# 3-Loop
# Z-exchange
GGHEWZZ3L_ForFac1_RE = Parameter(name='GGHEWZZ3L_ForFac1_RE',
                                 nature='external',
                                 type='complex',
                                 value=44.001,
                                 texname='\\text{GGHEWZZ3L_ForFac1_RE}',
                                 lhablock='GGHEWZZ',
                                 lhacode=[44001])
GGHEWZZ3L_ForFac1_IM = Parameter(name='GGHEWZZ3L_ForFac1_IM',
                                 nature='external',
                                 type='complex',
                                 value=44.002,
                                 texname='\\text{GGHEWZZ3L_ForFac1_IM}',
                                 lhablock='GGHEWZZ',
                                 lhacode=[44002])
# W-exchange
GGHEWWW3L_ForFac1_RE = Parameter(name='GGHEWWW3L_ForFac1_RE',
                                 nature='external',
                                 type='complex',
                                 value=55.001,
                                 texname='\\text{GGHEWWW3L_ForFac1_RE}',
                                 lhablock='GGHEWWW',
                                 lhacode=[55001])
GGHEWWW3L_ForFac1_IM = Parameter(name='GGHEWWW3L_ForFac1_IM',
                                 nature='external',
                                 type='complex',
                                 value=55.002,
                                 texname='\\text{GGHEWWW3L_ForFac1_IM}',
                                 lhablock='GGHEWWW',
                                 lhacode=[55002])
# ===============================================================================
# Form Factors for ggHg
# ===============================================================================


GGGHQCD_ForFac1_RE = Parameter(name='GGGHQCD_ForFac1_RE',
                               nature='external',
                               type='complex',
                               value=66.001,
                               texname='\\text{GGGHQCD_ForFac1_RE}',
                               lhablock='GGGHQCD',
                               lhacode=[66001])

GGGHQCD_ForFac1_IM = Parameter(name='GGGHQCD_ForFac1_IM',
                               nature='external',
                               type='complex',
                               value=66.002,
                               texname='\\text{GGGHQCD_ForFac1_IM}',
                               lhablock='GGGHQCD',
                               lhacode=[66002])

GGGHQCD_ForFac2_RE = Parameter(name='GGGHQCD_ForFac2_RE',
                               nature='external',
                               type='complex',
                               value=66.003,
                               texname='\\text{GGGHQCD_ForFac2_RE}',
                               lhablock='GGGHQCD',
                               lhacode=[66003])

GGGHQCD_ForFac2_IM = Parameter(name='GGGHQCD_ForFac2_IM',
                               nature='external',
                               type='complex',
                               value=66.004,
                               texname='\\text{GGGHQCD_ForFac2_IM}',
                               lhablock='GGGHQCD',
                               lhacode=[66004])

GGGHQCD_ForFac3_RE = Parameter(name='GGGHQCD_ForFac3_RE',
                               nature='external',
                               type='complex',
                               value=66.005,
                               texname='\\text{GGGHQCD_ForFac3_RE}',
                               lhablock='GGGHQCD',
                               lhacode=[66005])

GGGHQCD_ForFac3_IM = Parameter(name='GGGHQCD_ForFac3_IM',
                               nature='external',
                               type='complex',
                               value=66.006,
                               texname='\\text{GGGHQCD_ForFac3_IM}',
                               lhablock='GGGHQCD',
                               lhacode=[66006])

GGGHQCD_ForFac4_RE = Parameter(name='GGGHQCD_ForFac4_RE',
                               nature='external',
                               type='complex',
                               value=66.007,
                               texname='\\text{GGGHQCD_ForFac4_RE}',
                               lhablock='GGGHQCD',
                               lhacode=[66007])

GGGHQCD_ForFac4_IM = Parameter(name='GGGHQCD_ForFac4_IM',
                               nature='external',
                               type='complex',
                               value=66.008,
                               texname='\\text{GGGHQCD_ForFac4_IM}',
                               lhablock='GGGHQCD',
                               lhacode=[66008])
# ----------------------------------------------------------
# EW ZZ-exchange
# ----------------------------------------------------------


GGGHEWZZ_ForFac1_RE = Parameter(name='GGGHEWZZ_ForFac1_RE',
                                nature='external',
                                type='complex',
                                value=77.001,
                                texname='\\text{GGGHEWZZ_ForFac1_RE}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77001])

GGGHEWZZ_ForFac1_IM = Parameter(name='GGGHEWZZ_ForFac1_IM',
                                nature='external',
                                type='complex',
                                value=77.002,
                                texname='\\text{GGGHEWZZ_ForFac1_IM}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77002])

GGGHEWZZ_ForFac2_RE = Parameter(name='GGGHEWZZ_ForFac2_RE',
                                nature='external',
                                type='complex',
                                value=77.003,
                                texname='\\text{GGGHEWZZ_ForFac2_RE}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77003])

GGGHEWZZ_ForFac2_IM = Parameter(name='GGGHEWZZ_ForFac2_IM',
                                nature='external',
                                type='complex',
                                value=77.004,
                                texname='\\text{GGGHEWZZ_ForFac2_IM}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77004])

GGGHEWZZ_ForFac3_RE = Parameter(name='GGGHEWZZ_ForFac3_RE',
                                nature='external',
                                type='complex',
                                value=77.005,
                                texname='\\text{GGGHEWZZ_ForFac3_RE}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77005])

GGGHEWZZ_ForFac3_IM = Parameter(name='GGGHEWZZ_ForFac3_IM',
                                nature='external',
                                type='complex',
                                value=77.006,
                                texname='\\text{GGGHEWZZ_ForFac3_IM}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77006])

GGGHEWZZ_ForFac4_RE = Parameter(name='GGGHEWZZ_ForFac4_RE',
                                nature='external',
                                type='complex',
                                value=77.007,
                                texname='\\text{GGGHEWZZ_ForFac4_RE}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77007])

GGGHEWZZ_ForFac4_IM = Parameter(name='GGGHEWZZ_ForFac4_IM',
                                nature='external',
                                type='complex',
                                value=77.008,
                                texname='\\text{GGGHEWZZ_ForFac4_IM}',
                                lhablock='GGGHEWZZ',
                                lhacode=[77008])

# ----------------------------------------------------------
# EW WW-exchange
# ----------------------------------------------------------

GGGHEWWW_ForFac1_RE = Parameter(name='GGGHEWWW_ForFac1_RE',
                                nature='external',
                                type='complex',
                                value=88.001,
                                texname='\\text{GGGHEWWW_ForFac1_RE}',
                                lhablock='GGGHEWWW',
                                lhacode=[88001])

GGGHEWWW_ForFac1_IM = Parameter(name='GGGHEWWW_ForFac1_IM',
                                nature='external',
                                type='complex',
                                value=88.002,
                                texname='\\text{GGGHEWWW_ForFac1_IM}',
                                lhablock='GGGHEWWW',
                                lhacode=[88002])

GGGHEWWW_ForFac2_RE = Parameter(name='GGGHEWWW_ForFac2_RE',
                                nature='external',
                                type='complex',
                                value=88.003,
                                texname='\\text{GGGHEWWW_ForFac2_RE}',
                                lhablock='GGGHEWWW',
                                lhacode=[88003])

GGGHEWWW_ForFac2_IM = Parameter(name='GGGHEWWW_ForFac2_IM',
                                nature='external',
                                type='complex',
                                value=88.004,
                                texname='\\text{GGGHEWWW_ForFac2_IM}',
                                lhablock='GGGHEWWW',
                                lhacode=[88004])

GGGHEWWW_ForFac3_RE = Parameter(name='GGGHEWWW_ForFac3_RE',
                                nature='external',
                                type='complex',
                                value=88.005,
                                texname='\\text{GGGHEWWW_ForFac3_RE}',
                                lhablock='GGGHEWWW',
                                lhacode=[88005])

GGGHEWWW_ForFac3_IM = Parameter(name='GGGHEWWW_ForFac3_IM',
                                nature='external',
                                type='complex',
                                value=88.006,
                                texname='\\text{GGGHEWWW_ForFac3_IM}',
                                lhablock='GGGHEWWW',
                                lhacode=[88006])
GGGHEWWW_ForFac4_RE = Parameter(name='GGGHEWWW_ForFac4_RE',
                                nature='external',
                                type='complex',
                                value=88.007,
                                texname='\\text{GGGHEWWW_ForFac4_RE}',
                                lhablock='GGGHEWWW',
                                lhacode=[88007])

GGGHEWWW_ForFac4_IM = Parameter(name='GGGHEWWW_ForFac4_IM',
                                nature='external',
                                type='complex',
                                value=88.008,
                                texname='\\text{GGGHEWWW_ForFac4_IM}',
                                lhablock='GGGHEWWW',
                                lhacode=[88008])


# -----------------------------------------------------------------------------
# one-loop GGGH related parameters
# -----------------------------------------------------------------------------

n_loops = Parameter(name='n_loops',
                    nature='external',
                    type='real',
                    value=1.0,
                    texname='\\text{n_loops}',
                    lhablock='GGGHQCD',
                    lhacode=[40001])

requiredRelativeAccuracy = Parameter(name='requiredRelativeAccuracy',
                                     nature='external',
                                     type='real',
                                     value=1.0e-7,
                                     texname='\\text{requiredRelativeAccuracy}',
                                     lhablock='GGGHQCD',
                                     lhacode=[40002])
