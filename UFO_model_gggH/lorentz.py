from object_library import all_lorentz, Lorentz

###################################################
# PPHJ-tensor structures
###################################################

#gggHTensStruc1_expr = '-1*(((-(Metric(1, 2)*P(-6, 1)*P(-6, 2)) + P(1, 2)*P(2, 1))*(-(P(-15, 2)*P(-15, 3)*P(3, 1)) + P(-10, 1)*P(-10, 3)*P(3, 2)))/(P(-15, 2)*P(-15, 3)))'
#gggHTensStruc2_expr = '-1*(((P(-10, 1)*P(-10, 3)*P(1, 2) - P(-6, 1)*P(-6, 2)*P(1, 3))*(-(Metric(2, 3)*P(-15, 2)*P(-15, 3)) + P(2, 3)*P(3, 2)))/(P(-10, 1)*P(-10, 3)))'
#gggHTensStruc3_expr = '-1*(((P(-15, 2)*P(-15, 3)*P(2, 1) - P(-6, 1)*P(-6, 2)*P(2, 3))*(-(Metric(1, 3)*P(-10, 1)*P(-10, 3)) + P(1, 3)*P(3, 1)))/(P(-15, 2)*P(-15, 3)))'
#gggHTensStruc4_expr = '-1*(-(Metric(1, 3)*P(-15, 2)*P(-15, 3)*P(2, 1)) + Metric(1, 3)*P(-6, 1)*P(-6, 2)*P(2, 3) + Metric(1, 2)*P(-15, 2)*P(-15, 3)*P(3, 1) + P(1, 2)*(Metric(2, 3)*P(-10, 1)*P(-10, 3) - P(2, 3)*P(3, 1)) - Metric(1, 2)*P(-10, 1)*P(-10, 3)*P(3, 2) + P(1, 3)*(-(Metric(2, 3)*P(-6, 1)*P(-6, 2)) + P(2, 1)*P(3, 2)))'

# We of course assume the gluons to be onshell here!
# mu nu and tau are the Lorenz indices of p1:mu  p2:nu  p3:tau
# T212 (s12*g[mu, nu] - 2*P[2, mu]*P[1, nu])*(s23*P[1, tau] - s13*P[2, tau])/(2*s13)
gggHTensStruc1_expr = '( ( P(-10,1)*P(-10,2)*Metric(1,2) - P(1,2)*P(2,1) ) * ( P(-11,2)*P(-11,3)*P(3,1) - P(-12,1)*P(-12,3)*P(3,2) ) ) / ( P(-13,1)*P(-13,3) )'
# T332 (s23*g[nu, tau] - 2*P[3, nu]*P[2, tau])*(s13*P[2, mu] - s12*P[3, mu])/(2*s12)
gggHTensStruc2_expr = '( ( P(-10,2)*P(-10,3)*Metric(2,3) - P(2,3)*P(3,2) ) * ( P(-11,1)*P(-11,3)*P(1,2) - P(-12,1)*P(-12,2)*P(1,3) ) ) / ( P(-13,1)*P(-13,2) )'
# T311 (s13*g[tau, mu] - 2*P[1, tau]*P[3, mu])*(s12*P[3, nu] - s23*P[1, nu])/(2*s23)
gggHTensStruc3_expr = '( ( P(-10,1)*P(-10,3)*Metric(3,1) - P(3,1)*P(1,3) ) * ( P(-11,1)*P(-11,2)*P(2,3) - P(-12,2)*P(-12,3)*P(2,1) ) ) / ( P(-13,2)*P(-13,3) )'
# T312 (  g[mu, nu]*(s23*P[1, tau] - s13*P[2, tau]) 
#       + g[nu, tau]*(s13*P[2, mu] - s12*P[3, mu]) 
#       + g[tau, mu]*(s12*P[3, nu] - s23*P[1, nu]) 
#       + 2*P[3, mu]*P[1, nu]*P[2, tau] 
#       - 2*P[2, mu]*P[3, nu]*P[1, tau]
#      )/2
gggHTensStruc4_expr = ('(  Metric(1,2) * ( P(-10,2)*P(-10,3)*P(3,1) - P(-11,1)*P(-11,3)*P(3,2) )'+ 
                      '+ Metric(2,3) * ( P(-12,1)*P(-12,3)*P(1,2) - P(-13,1)*P(-13,2)*P(1,3) )'+
                      '+ Metric(3,1) * ( P(-14,1)*P(-14,2)*P(2,3) - P(-15,2)*P(-15,3)*P(2,1) )'+
                      '+ P(1,3)*P(2,1)*P(3,2)'+
                      '- P(1,2)*P(2,3)*P(3,1)'+
                      ')')

# For the following vertex:
#    q(p1) qbar(p2) g(p3) h(p4) (all momenta incoming)
# Then the two tensor structures used are:
#   p_1^(mu3) slash(p3) - (p1+p3)^2 gamma(mu3)/2
#   p_2^mu3 slash(p3) - (p2+p3)^2 gamma(mu3)/2
# Note that the FF are only valid for on-shell massless external, so we remove p_i^2 terms here.
qqgHTensStruc1_expr = 'P(3,1)*Gamma(-21,2,1)*P(-21,3) - P(-22,1)*P(-22,3)*Gamma(3,2,1)'
qqgHTensStruc2_expr = 'P(3,2)*Gamma(-31,2,1)*P(-31,3) - P(-32,2)*P(-32,3)*Gamma(3,2,1)'

# Heft 0L

gggHTensStruc1HEFT0L = Lorentz(
    name='gggHTensStruc1HEFT0L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc1_expr
)
gggHTensStruc2HEFT0L = Lorentz(
    name='gggHTensStruc2HEFT0L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc2_expr
)
gggHTensStruc3HEFT0L = Lorentz(
    name='gggHTensStruc3HEFT0L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc3_expr
)
gggHTensStruc4HEFT0L = Lorentz(
    name='gggHTensStruc4HEFT0L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc4_expr
)

qqgHTensStruc1HEFT0L = Lorentz(
    name='qqgHTensStruc1HEFT0L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc1_expr
)
qqgHTensStruc2HEFT0L = Lorentz(
    name='qqgHTensStruc2HEFT0L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc2_expr
)

# Heft 1L

gggHTensStruc1HEFT1L = Lorentz(
    name='gggHTensStruc1HEFT1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc1_expr
)
gggHTensStruc2HEFT1L = Lorentz(
    name='gggHTensStruc2HEFT1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc2_expr
)
gggHTensStruc3HEFT1L = Lorentz(
    name='gggHTensStruc3HEFT1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc3_expr
)
gggHTensStruc4HEFT1L = Lorentz(
    name='gggHTensStruc4HEFT1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc4_expr
)

qqgHTensStruc1HEFT1L = Lorentz(
    name='qqgHTensStruc1HEFT1L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc1_expr
)
qqgHTensStruc2HEFT1L = Lorentz(
    name='qqgHTensStruc2HEFT1L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc2_expr
)

# QCD 1L

gggHTensStruc1QCD1L = Lorentz(
    name='gggHTensStruc1QCD1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc1_expr
)
gggHTensStruc2QCD1L = Lorentz(
    name='gggHTensStruc2QCD1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc2_expr
)
gggHTensStruc3QCD1L = Lorentz(
    name='gggHTensStruc3QCD1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc3_expr
)
gggHTensStruc4QCD1L = Lorentz(
    name='gggHTensStruc4QCD1L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc4_expr
)

qqgHTensStruc1QCD1L = Lorentz(
    name='qqgHTensStruc1QCD1L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc1_expr
)
qqgHTensStruc2QCD1L = Lorentz(
    name='qqgHTensStruc2QCD1L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc2_expr
)

# QCD 2L

gggHTensStruc1QCD2L = Lorentz(
    name='gggHTensStruc1QCD2L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc1_expr
)
gggHTensStruc2QCD2L = Lorentz(
    name='gggHTensStruc2QCD2L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc2_expr
)
gggHTensStruc3QCD2L = Lorentz(
    name='gggHTensStruc3QCD2L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc3_expr
)
gggHTensStruc4QCD2L = Lorentz(
    name='gggHTensStruc4QCD2L',
    spins=[3, 3, 3, 1],
    structure=gggHTensStruc4_expr
)

qqgHTensStruc1QCD2L = Lorentz(
    name='qqgHTensStruc1QCD2L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc1_expr
)
qqgHTensStruc2QCD2L = Lorentz(
    name='qqgHTensStruc2QCD2L',
    spins=[2, 2, 3, 1],
    structure=qqgHTensStruc2_expr
)

###################################################
# GGGH-tensor structures
###################################################
gggHTensStruc1 = Lorentz(
    name='gggHTensStruc1',
    spins=[3, 3, 3, 1],
    structure='-1*(((-(Metric(1, 2)*P(-6, 1)*P(-6, 2)) + P(1, 2)*P(2, 1))*(-(P(-15, 2)*P(-15, 3)*P(3, 1)) + P(-10, 1)*P(-10, 3)*P(3, 2)))/(P(-15, 2)*P(-15, 3)))'
)
gggHTensStruc2 = Lorentz(
    name='gggHTensStruc2',
    spins=[3, 3, 3, 1],
    structure='-1*(((P(-10, 1)*P(-10, 3)*P(1, 2) - P(-6, 1)*P(-6, 2)*P(1, 3))*(-(Metric(2, 3)*P(-15, 2)*P(-15, 3)) + P(2, 3)*P(3, 2)))/(P(-10, 1)*P(-10, 3)))'
)
gggHTensStruc3 = Lorentz(
    name='gggHTensStruc3',
    spins=[3, 3, 3, 1],
    structure='-1*(((P(-15, 2)*P(-15, 3)*P(2, 1) - P(-6, 1)*P(-6, 2)*P(2, 3))*(-(Metric(1, 3)*P(-10, 1)*P(-10, 3)) + P(1, 3)*P(3, 1)))/(P(-15, 2)*P(-15, 3)))'
)
gggHTensStruc4 = Lorentz(
    name='gggHTensStruc4',
    spins=[3, 3, 3, 1],
    structure='-1*(-(Metric(1, 3)*P(-15, 2)*P(-15, 3)*P(2, 1)) + Metric(1, 3)*P(-6, 1)*P(-6, 2)*P(2, 3) + Metric(1, 2)*P(-15, 2)*P(-15, 3)*P(3, 1) + P(1, 2)*(Metric(2, 3)*P(-10, 1)*P(-10, 3) - P(2, 3)*P(3, 1)) - Metric(1, 2)*P(-10, 1)*P(-10, 3)*P(3, 2) + P(1, 3)*(-(Metric(2, 3)*P(-6, 1)*P(-6, 2)) + P(2, 1)*P(3, 2)))'
)


###################################################
# GGH-tensor structures
###################################################
# we do not use the structure in (2.6) of 1711.11113v2
ggHTensStruc1 = Lorentz(
    name='ggHTensStruc1',
    spins=[3, 3, 1],
    structure='1*( Metric(1, 2)*(P(-6, 1)*P(-6, 2)) - P(1, 2)*P(2, 1))'
)
###################################
# CounterTerms Lorentz structures #
###################################

R2_GG_1 = Lorentz(name='R2_GG_1',
                  spins=[3, 3],
                  structure='P(-1,1)*P(-1,1)*Metric(1,2)')

R2_GG_2 = Lorentz(name='R2_GG_2',
                  spins=[3, 3],
                  structure='P(1,1)*P(2,1)')

R2_GG_3 = Lorentz(name='R2_GG_3',
                  spins=[3, 3],
                  structure='Metric(1,2)')

R2_QQ_1 = Lorentz(name='R2_QQ_1',
                  spins=[2, 2],
                  structure='P(-1,1)*Gamma(-1,2,1)')

R2_QQ_2 = Lorentz(name='R2_QQ_2',
                  spins=[2, 2],
                  structure='Identity(1,2)')

GHGHG = Lorentz(name='GHGHG',
                spins=[1, 1, 3],
                structure='P(3,2)')

# =============================================================================================
#  4-gluon R2 vertex
# =============================================================================================


R2_4G_1234 = Lorentz(name='R2_4G_1234',
                     spins=[3, 3, 3, 3],
                     structure='Metric(1,2)*Metric(3,4)')

R2_4G_1324 = Lorentz(name='R2_4G_1324',
                     spins=[3, 3, 3, 3],
                     structure='Metric(1,3)*Metric(2,4)')

R2_4G_1423 = Lorentz(name='R2_4G_1423',
                     spins=[3, 3, 3, 3],
                     structure='Metric(1,4)*Metric(2,3)')

R2RGA_VVVV10 = Lorentz(name='R2RGA_VVVV10',
                       spins=[3, 3, 3, 3],
                       structure='Metric(1,4)*Metric(2,3) + Metric(1,3)*Metric(2,4) + Metric(1,2)*Metric(3,4)')

R2RGA_VVVV2 = Lorentz(name='R2RGA_VVVV2',
                      spins=[3, 3, 3, 3],
                      structure='Metric(1,4)*Metric(2,3)')

R2RGA_VVVV3 = Lorentz(name='R2RGA_VVVV3',
                      spins=[3, 3, 3, 3],
                      structure='Metric(1,3)*Metric(2,4)')

R2RGA_VVVV5 = Lorentz(name='R2RGA_VVVV5',
                      spins=[3, 3, 3, 3],
                      structure='Metric(1,2)*Metric(3,4)')

# =============================================================================================

R2_GGZ = Lorentz(name='R2_GGZ',
                 spins=[3, 3, 3],
                 structure='Epsilon(3,1,2,-1)*P(-1,2)-Epsilon(3,1,2,-1)*P(-1,1)')

R2_GGVV = Lorentz(name='R2_GGVV',
                  spins=[3, 3, 3, 3],
                  structure='Metric(1,2)*Metric(3,4)+Metric(1,3)*Metric(2,4)+Metric(1,4)*Metric(2,3)')

R2_GGHH = Lorentz(name='R2_GGHH',
                  spins=[3, 3, 1, 1],
                  structure='Metric(1,2)')

R2_GGGVa = Lorentz(name='R2_GGGVa',
                   spins=[3, 3, 3, 3],
                   structure='Epsilon(4,1,2,3)')

###################
# Base structures #
###################

UUV1 = Lorentz(name='UUV1',
               spins=[-1, -1, 3],
               structure='P(3,2) + P(3,3)')

SSS1 = Lorentz(name='SSS1',
               spins=[1, 1, 1],
               structure='1')

FFS1 = Lorentz(name='FFS1',
               spins=[2, 2, 1],
               structure='Identity(2,1)')

FFV1 = Lorentz(name='FFV1',
               spins=[2, 2, 3],
               structure='Gamma(3,2,1)')

FFV2 = Lorentz(name='FFV2',
               spins=[2, 2, 3],
               structure='Gamma(3,2,-1)*ProjM(-1,1)')

FFV3 = Lorentz(name='FFV3',
               spins=[2, 2, 3],
               structure='Gamma(3,2,-1)*ProjM(-1,1) - 2*Gamma(3,2,-1)*ProjP(-1,1)')

FFV4 = Lorentz(name='FFV4',
               spins=[2, 2, 3],
               structure='Gamma(3,2,-1)*ProjM(-1,1) + 2*Gamma(3,2,-1)*ProjP(-1,1)')

FFV5 = Lorentz(name='FFV5',
               spins=[2, 2, 3],
               structure='Gamma(3,2,-1)*ProjM(-1,1) + 4*Gamma(3,2,-1)*ProjP(-1,1)')

VVS1 = Lorentz(name='VVS1',
               spins=[3, 3, 1],
               structure='Metric(1,2)')

VVV1 = Lorentz(name='VVV1',
               spins=[3, 3, 3],
               structure='P(3,1)*Metric(1,2) - P(3,2)*Metric(1,2) - P(2,1)*Metric(1,3) + P(2,3)*Metric(1,3) + P(1,2)*Metric(2,3) - P(1,3)*Metric(2,3)')

VVSS1 = Lorentz(name='VVSS1',
                spins=[3, 3, 1, 1],
                structure='Metric(1,2)')

VVVV1 = Lorentz(name='VVVV1',
                spins=[3, 3, 3, 3],
                structure='Metric(1,4)*Metric(2,3) - Metric(1,3)*Metric(2,4)')

VVVV2 = Lorentz(name='VVVV2',
                spins=[3, 3, 3, 3],
                structure='Metric(1,4)*Metric(2,3) + Metric(1,3)*Metric(2,4) - 2*Metric(1,2)*Metric(3,4)')

VVVV3 = Lorentz(name='VVVV3',
                spins=[3, 3, 3, 3],
                structure='Metric(1,4)*Metric(2,3) - Metric(1,2)*Metric(3,4)')

VVVV4 = Lorentz(name='VVVV4',
                spins=[3, 3, 3, 3],
                structure='Metric(1,3)*Metric(2,4) - Metric(1,2)*Metric(3,4)')

VVVV5 = Lorentz(name='VVVV5',
                spins=[3, 3, 3, 3],
                structure='Metric(1,4)*Metric(2,3) - (Metric(1,3)*Metric(2,4))/2. - (Metric(1,2)*Metric(3,4))/2.')

# == Additional lorentz structure for Fenyman goldstones

UUS1 = Lorentz(name='UUS1',
               spins=[-1, -1, 1],
               structure='1')

FFS8 = Lorentz(name='FFS8',
               spins=[2, 2, 1],
               structure='ProjM(2,1)')

FFS2 = Lorentz(name='FFS2',
               spins=[2, 2, 1],
               structure='ProjM(2,1) - ProjP(2,1)')

FFS3 = Lorentz(name='FFS3',
               spins=[2, 2, 1],
               structure='ProjP(2,1)')

FFS4 = Lorentz(name='FFS4',
               spins=[2, 2, 1],
               structure='ProjM(2,1) + ProjP(2,1)')

VSS1 = Lorentz(name='VSS1',
               spins=[3, 1, 1],
               structure='P(1,2) - P(1,3)')

SSSS1 = Lorentz(name='SSSS1',
                spins=[1, 1, 1, 1],
                structure='1')
