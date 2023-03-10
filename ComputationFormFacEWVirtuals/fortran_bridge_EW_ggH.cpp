#include <iostream>
#include <stdexcept>
#include <stdio.h>
#include <string>
#include <sstream>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>
#include <math.h>
using namespace std;



extern"C" void %(C_prefix)sget_ggh_ew_coefs_fortran_(
		                const double &	massHiggs,
						const double & massW,
						const double & massZ,
						const double &	muR,
						double *ewTensorLORe,
						double *ewTensorLOIm,
						double *ewTensorNLORe,
						double *ewTensorNLOIm
						)  {

	double allow_dev, mZ, mW, mH;
	double A0wwRe,ANLOFinwwRe;
	double A0wwIm,ANLOFinwwIm;
	double A0zzRe,  ANLOFinzzRe;
	double A0zzIm,  ANLOFinzzIm;
	double CA, beta0, nf, prefac3Lvs2L, prefacTensDiff,prefacFKS;
	
	double prefacI1Eps0Re,prefacI1Eps0Im;
	
	bool recomp;
	int i;
	// euler_gamma -- The Euler Mascheroni Constant
    // const double euler_gamma = 0.5772156649015328606065;
	// allow for variation of the masses
	allow_dev = 1.e-004;
	// values used for computation
	mH=125.09;
	mW=80.385;
	mZ = 91.1876;
	CA = 3.;
	nf = 5.;
	beta0 = 11./6.*CA-2./3.*1./2.*nf;
	// FKS match prefac
	prefacFKS = CA*pow(M_PI,2)*0.5;
	// The 3Loop is differently normalized than the 2loop
	prefac3Lvs2L = 8.;
	// I have a different tensor structure then given in the
	// papers on the virtuals
	prefacTensDiff =-2./pow(mH,2);



	recomp =false;

	// These are the catani subtracted values of 1711.1113v2
	ANLOFinzzRe =-2.97580125634092878835130586898977665654*prefacTensDiff;
	ANLOFinzzIm =-41.19509385404224724165178749439486111*prefacTensDiff;
	ANLOFinwwRe =-11.315570583184121341121574935828846867*prefacTensDiff;
	ANLOFinwwIm =-54.029894948618318637506676075420213247*prefacTensDiff;

	A0zzRe = -0.86010579357833842705446467108391858030*prefacTensDiff*prefac3Lvs2L;
	A0zzIm = -0.072301488703818874120152045090322314188*prefacTensDiff*prefac3Lvs2L;
	// A1zzRe =-4.0679890718539717274276892827906667866*prefacTensDiff;
	// A1zzIm = 4.57200652570753543380317144864865114806*prefacTensDiff;
	// A2zzRe = 1.670588602147320175065870765034387981487*prefacTensDiff;
	// A2zzIm = 19.608054839232399454865778271034035073*prefacTensDiff;

	A0wwRe = -1.339616265073840926495167474486369107*prefacTensDiff*prefac3Lvs2L;
	A0wwIm = -0.28786909875208879804457356859082370126*prefacTensDiff*prefac3Lvs2L;
	// A1wwRe =-8.080953802515097255360021005850147672*prefacTensDiff;
	// A1wwIm = 5.5252881061016873196244439523929729823*prefacTensDiff;
	// A2wwRe =-8.0164430532805619353216514352189158038*prefacTensDiff;
	// A2wwIm = 31.4793419295010777612714575376112804875*prefacTensDiff;


	if (abs(massHiggs-mH)/massHiggs>allow_dev || abs(massW-mW)/massW>allow_dev || abs(massZ-mZ)/massZ>allow_dev){
		recomp=true;
	}
	if (recomp){
		throw std::invalid_argument( "A boson mass does not match within the allowed deviation of: "+ std::to_string(allow_dev)
		+"\n\tDeviation for Higgs-mass "+ std::to_string(abs(massHiggs-mH)/massHiggs)
		+"\n\tDeviation for W-mass "+ std::to_string(abs(massW-mW)/massW)
		+"\n\tDeviation for Z-mass "+ std::to_string(abs(massZ-mZ)/massZ));
	}
	if (abs(massHiggs-muR)/massHiggs>allow_dev){
		throw std::invalid_argument( "The renormalization scale does not match the higgs mass within the allowed deviation of: "+ std::to_string(allow_dev)
		+"\n\tDeviation for muR from Higgs-mass "+ std::to_string(abs(massHiggs-muR)/massHiggs));
		
	}
	// The arrays are [value_for_Z, value_for_W]

		ewTensorLORe[0]=A0zzRe;
		ewTensorLORe[1]=A0wwRe;
		ewTensorLOIm[0]=A0zzIm;
		ewTensorLOIm[1]=A0wwIm;
		

	// The arrays are [value_for_Z, value_for_W]
	// These are the NLO amplitudes renormailized in MSbar and catani subtracted
		ewTensorNLORe[0]=ANLOFinzzRe+prefacFKS*A0zzRe;
		ewTensorNLORe[1]= ANLOFinwwRe+prefacFKS*A0wwRe;
		ewTensorNLOIm[0]=ANLOFinzzIm+prefacFKS*A0zzIm;
		ewTensorNLOIm[1]=ANLOFinwwIm+prefacFKS*A0wwIm;
		




}
