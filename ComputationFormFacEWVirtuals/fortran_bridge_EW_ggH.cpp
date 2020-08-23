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
	bool recomp;
	int i;
	// allow for variation of the masses
	allow_dev = 1.e-003;
	// values used for computation
	mH=125.09; 
	mW=80.385; 
	mZ = 91.1876;
	recomp =false;

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
			ewTensorLORe[0]=-0.86010579357833842705446467108391858030;
			ewTensorLORe[1]=0.072301488703818874120152045090322314188;
			ewTensorLOIm[0]=-1.339616265073840926495167474486369107;
			ewTensorLOIm[1]= 0.28786909875208879804457356859082370126;


		}
		else if (eps_EW==1){
			ewTensorLORe[0]=-4.0679890718539717274276892827906667866;
			ewTensorLORe[1]=4.57200652570753543380317144864865114806;
			ewTensorLOIm[0]=-8.080953802515097255360021005850147672;
			ewTensorLOIm[1]=5.5252881061016873196244439523929729823;

		}
		else if (eps_EW==2){
			ewTensorLORe[0]=1.670588602147320175065870765034387981487;
			ewTensorLORe[1]=19.608054839232399454865778271034035073;
			ewTensorLOIm[0]=-8.0164430532805619353216514352189158038;
			ewTensorLOIm[1]= 31.4793419295010777612714575376112804875;

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
			ewTensorNLORe[0]=1.;
			ewTensorNLORe[1]=2.;
			ewTensorNLOIm[0]=3.;
			ewTensorNLOIm[1]=4.;

		}
		else if (eps_EW==-1){
			ewTensorNLORe[0]=1.;
			ewTensorNLORe[1]=2.;
			ewTensorNLOIm[0]=3.;
			ewTensorNLOIm[1]=4.;

		}
		else if (eps_EW==0){
			ewTensorNLORe[0]=1.;
			ewTensorNLORe[1]=2.;
			ewTensorNLOIm[0]=3.;
			ewTensorNLOIm[1]=4.;

		}
		else {
			throw std::invalid_argument( "eps^"+ std::to_string(eps_EW)+" at "+std::to_string(n_loops_EW)+"-loop is not implemented");
		}		

	}




}