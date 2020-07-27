import numpy as np
from wolframclient.evaluation import WolframLanguageSession
from wolframclient.language import wl, Global, wlexpr


#Compute the Lorentz scalar product
def dot(self, v):
     return self[0]*v[0] - self[1]*v[1] - self[2]*v[2] - self[3]*v[3]



# evaluate form-factors in mathematica
def evalFormFacfromMath(s,t,mH,mT, *pathToMfile, **kwargs):
     pathToMfile = kwargs.get('pathToMfile', "./mathematicaRoutines/evaluation_amp.m")
     session = WolframLanguageSession()
     session.evaluate(wl.Get(pathToMfile))
     formfacs=np.array(session.evaluate(Global.computeFormFactors(s,t,mH,mT)))
     session.terminate()
     return formfacs
