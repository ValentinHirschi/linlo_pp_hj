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



extern"C" void get_ggh_ew_coefs_fortran_(
		                const double &	massHiggs,
						const double & massW,
						const double & massZ,
						const double &	muR,
						const int & n_loops_EW,
						const int & eps_EW,
						double *ewTensorLORe,
						double *ewTensorLOIm,
						double *ewTensorNLORe,
						double *ewTensorNLOIm
						)  {

	double allow_dev, mZ, mW, mH;
	double A0wwRe, A1wwRe, A2wwRe, ANLOFinwwRe;
	double A0wwIm, A1wwIm, A2wwIm, ANLOFinwwIm;
	double A0zzRe, A1zzRe, A2zzRe, ANLOFinzzRe;
	double A0zzIm, A1zzIm, A2zzIm, ANLOFinzzIm;
	double CA, beta0, nf, prefac3Lvs2L, prefacTensDiff;
	double prefaceps1Re,prefaceps1Im,prefaceps2Re,prefaceps2Im;
	double prefacI1EpsM2,prefacI1EpsM1Re,prefacI1EpsM1Im,prefacI1Eps0Re,prefacI1Eps0Im;
	double mg5PrefacEps, mg5PrefacEps2;
	bool recomp;
	int i;
	// euler_gamma -- The Euler Mascheroni Constant
    const double euler_gamma = 0.5772156649015328606065;
	// allow for variation of the masses
	allow_dev = 1.e-003;
	// values used for computation
	mH=125.09;
	mW=80.385;
	mZ = 91.1876;
	CA = 3.;
	nf = 5.;
	beta0 = 11./6.*CA-2./3.*1./2.*nf;

	// The 3Loop is differently normalized than the 2loop
	prefac3Lvs2L = 1./8.;
	// I have a different tensor structure then given in the
	// papers on the virtuals
	prefacTensDiff =-1./pow(mH,2);

	//The prefactors from the normalization of the 2L: E^(2 I eps \[Pi]) (4 \[Pi])^(2 eps) Gamma[1+eps]^2
	prefaceps1Re = -2*euler_gamma + 2*log(4*M_PI);
	prefaceps1Im = 2*M_PI;
	prefaceps2Re = (-11*pow(M_PI,2))/6. + 2*pow(euler_gamma - log(4*M_PI),2);
	prefaceps2Im = 4*M_PI*(-euler_gamma + log(4*M_PI));

	// catani (E^(eps (euler_gamma+I \[M_PI])) (CA+beta0 eps))/(eps^3 Gamma[-eps])
	prefacI1EpsM2 = -CA;
	prefacI1EpsM1Re= -beta0;
	prefacI1EpsM1Im= -CA*M_PI;
	prefacI1Eps0Re= (7*CA*pow(M_PI,2))/12.;
	prefacI1Eps0Im= -beta0;

	// mg5 prefac: (4 \[M_PI])^-eps Gamma[1-eps]
	mg5PrefacEps =euler_gamma - log(4*M_PI);
	mg5PrefacEps2=(6*pow(euler_gamma,2) + pow(M_PI,2) - 12*euler_gamma*log(4*M_PI) + 6*pow(log(4*M_PI),2))/12.;

	recomp =false;


	ANLOFinzzRe =-2.97580125634092878835130586898977665654*prefacTensDiff*prefac3Lvs2L;
	ANLOFinzzIm =-41.19509385404224724165178749439486111*prefacTensDiff*prefac3Lvs2L;
	ANLOFinwwRe =-11.315570583184121341121574935828846867*prefacTensDiff*prefac3Lvs2L;
	ANLOFinwwIm =-54.029894948618318637506676075420213247*prefacTensDiff*prefac3Lvs2L;

	A0zzRe = -0.86010579357833842705446467108391858030*prefacTensDiff;
	A0zzIm = -0.072301488703818874120152045090322314188*prefacTensDiff;
	A1zzRe =-4.0679890718539717274276892827906667866*prefacTensDiff;
	A1zzIm = 4.57200652570753543380317144864865114806*prefacTensDiff;
	A2zzRe = 1.670588602147320175065870765034387981487*prefacTensDiff;
	A2zzIm = 19.608054839232399454865778271034035073*prefacTensDiff;

	A0wwRe = -1.339616265073840926495167474486369107*prefacTensDiff;
	A0wwIm = -0.28786909875208879804457356859082370126*prefacTensDiff;
	A1wwRe =-8.080953802515097255360021005850147672*prefacTensDiff;
	A1wwIm = 5.5252881061016873196244439523929729823*prefacTensDiff;
	A2wwRe =-8.0164430532805619353216514352189158038*prefacTensDiff;
	A2wwIm = 31.4793419295010777612714575376112804875*prefacTensDiff;


	if (abs(massHiggs-mH)/massHiggs>allow_dev || abs(massW-mW)/massW>allow_dev || abs(massZ-mZ)/massZ>allow_dev){
		recomp=true;
	}
	if (recomp){
		throw std::invalid_argument( "A boson mass does not match within the allowed deviation of: "+ std::to_string(allow_dev)
		+"\n\tDeviation for Higgs-mass "+ std::to_string(abs(massHiggs-mH)/massHiggs)
		+"\n\tDeviation for Z-mass "+ std::to_string(abs(massW-mW)/massW)
		+"\n\tDeviation for W-mass "+ std::to_string(abs(massZ-mZ)/massZ));
	}
	// The arrays are [value_for_Z, value_for_W]
	if (n_loops_EW==2){

		for (i=0;i<2;i=i+1){
			ewTensorNLORe[i]=0.;
			ewTensorNLOIm[i]=0.;
		}
		if (eps_EW==0){
			ewTensorLORe[0]=A0zzRe;
			ewTensorLORe[1]=A0wwRe;
			ewTensorLOIm[0]=A0zzIm;
			ewTensorLOIm[1]=A0wwIm;
		}
		else if (eps_EW==1){
			ewTensorLORe[0]=A1zzRe - A0zzIm*prefaceps1Im + A0zzRe*prefaceps1Re;
			ewTensorLORe[1]=A1wwRe - A0wwIm*prefaceps1Im + A0wwRe*prefaceps1Re;
			ewTensorLOIm[0]=A1zzIm + A0zzRe*prefaceps1Im + A0zzIm*prefaceps1Re;
			ewTensorLOIm[1]=A1wwIm + A0wwRe*prefaceps1Im + A0wwIm*prefaceps1Re;

		}
		else if (eps_EW==2){
			ewTensorLORe[0]=A2zzRe - A1zzIm*prefaceps1Im + A1zzRe*prefaceps1Re - A0zzIm*prefaceps2Im + A0zzRe*prefaceps2Re;
			ewTensorLORe[1]=A2wwRe - A1wwIm*prefaceps1Im + A1wwRe*prefaceps1Re - A0wwIm*prefaceps2Im + A0wwRe*prefaceps2Re;
			ewTensorLOIm[0]=A2zzIm + A1zzRe*prefaceps1Im + A1zzIm*prefaceps1Re + A0zzRe*prefaceps2Im + A0zzIm*prefaceps2Re;
			ewTensorLOIm[1]=A2wwIm + A1wwRe*prefaceps1Im + A1wwIm*prefaceps1Re + A0wwRe*prefaceps2Im + A0wwIm*prefaceps2Re;

		}
		else {
			throw std::invalid_argument( "eps^"+ std::to_string(eps_EW)+" at "+std::to_string(n_loops_EW)+"-loop is not implemented");
		}

	}

// The arrays are [value_for_Z, value_for_W]
	if (n_loops_EW==3){

		for (i=0;i<2;i=i+1){
			ewTensorLORe[i]=0.;
			ewTensorLOIm[i]=0.;
		}
		if (eps_EW==-2){
			ewTensorNLORe[0]=A0zzRe*prefacI1EpsM2;
			ewTensorNLORe[1]=A0wwRe*prefacI1EpsM2;
			ewTensorNLOIm[0]=A0zzIm*prefacI1EpsM2;
			ewTensorNLOIm[1]=A0wwIm*prefacI1EpsM2;

		}
		else if (eps_EW==-1){
			ewTensorNLORe[0]=A1zzRe*prefacI1EpsM2 - A0zzIm*(prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM2) + A0zzRe*(prefacI1EpsM1Re + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM2);
			ewTensorNLORe[1]=A1wwRe*prefacI1EpsM2 - A0wwIm*(prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM2) + A0wwRe*(prefacI1EpsM1Re + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM2);
			ewTensorNLOIm[0]=A1zzIm*prefacI1EpsM2 + A0zzRe*(prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM2) + A0zzIm*(prefacI1EpsM1Re + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM2);
			ewTensorNLOIm[1]=A1wwIm*prefacI1EpsM2 + A0wwRe*(prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM2) + A0wwIm*(prefacI1EpsM1Re + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM2);

		}
		else if (eps_EW==0){
			ewTensorNLORe[0]=-(A1zzIm*prefacI1EpsM1Im) + A1zzRe*prefacI1EpsM1Re + (A2zzRe - A1zzIm*prefaceps1Im + A1zzRe*(mg5PrefacEps + prefaceps1Re))*prefacI1EpsM2 - A0zzIm*(prefacI1Eps0Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM1Re + (mg5PrefacEps*prefaceps1Im + prefaceps2Im)*prefacI1EpsM2) + A0zzRe*(prefacI1Eps0Re - prefaceps1Im*prefacI1EpsM1Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Re + (mg5PrefacEps2 + mg5PrefacEps*prefaceps1Re + prefaceps2Re)*prefacI1EpsM2);
			ewTensorNLORe[1]=-(A1wwIm*prefacI1EpsM1Im) + A1wwRe*prefacI1EpsM1Re + (A2wwRe - A1wwIm*prefaceps1Im + A1wwRe*(mg5PrefacEps + prefaceps1Re))*prefacI1EpsM2 - A0wwIm*(prefacI1Eps0Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM1Re + (mg5PrefacEps*prefaceps1Im + prefaceps2Im)*prefacI1EpsM2) + A0wwRe*(prefacI1Eps0Re - prefaceps1Im*prefacI1EpsM1Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Re + (mg5PrefacEps2 + mg5PrefacEps*prefaceps1Re + prefaceps2Re)*prefacI1EpsM2);
			ewTensorNLOIm[0]=A1zzRe*prefacI1EpsM1Im + A1zzIm*prefacI1EpsM1Re + (A2zzIm + A1zzRe*prefaceps1Im + A1zzIm*(mg5PrefacEps + prefaceps1Re))*prefacI1EpsM2 + A0zzRe*(prefacI1Eps0Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM1Re + (mg5PrefacEps*prefaceps1Im + prefaceps2Im)*prefacI1EpsM2) + A0zzIm*(prefacI1Eps0Re - prefaceps1Im*prefacI1EpsM1Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Re + (mg5PrefacEps2 + mg5PrefacEps*prefaceps1Re + prefaceps2Re)*prefacI1EpsM2);
			ewTensorNLOIm[1]=A1wwRe*prefacI1EpsM1Im + A1wwIm*prefacI1EpsM1Re + (A2wwIm + A1wwRe*prefaceps1Im + A1wwIm*(mg5PrefacEps + prefaceps1Re))*prefacI1EpsM2 + A0wwRe*(prefacI1Eps0Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Im + prefaceps1Im*prefacI1EpsM1Re + (mg5PrefacEps*prefaceps1Im + prefaceps2Im)*prefacI1EpsM2) + A0wwIm*(prefacI1Eps0Re - prefaceps1Im*prefacI1EpsM1Im + (mg5PrefacEps + prefaceps1Re)*prefacI1EpsM1Re + (mg5PrefacEps2 + mg5PrefacEps*prefaceps1Re + prefaceps2Re)*prefacI1EpsM2);

		}
		else {
			throw std::invalid_argument( "eps^"+ std::to_string(eps_EW)+" at "+std::to_string(n_loops_EW)+"-loop is not implemented");
		}

	}




}
