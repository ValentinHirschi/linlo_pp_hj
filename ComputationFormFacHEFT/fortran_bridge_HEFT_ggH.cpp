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


extern"C" void %(C_prefix)sget_ggh_heft_coefs_fortran_(
		                const double &	massHiggs,
						const double &	muR,
						double *heftTensorRe,
						double *heftTensorIm
						)  {
	// 1/eps-pole
	double allow_dev,b0, Nf, Nc;
	bool recomp;

	recomp =false;
	Nc =3.0;
	Nf=5.0;
	allow_dev = 1.e-004;
	b0 = (11*Nc)/3. - (2*Nf)/3.;	

	if (abs(massHiggs-muR)/massHiggs>allow_dev){
		throw std::invalid_argument( "The renormalization scale does not match the higgs mass within the allowed deviation of: "+ std::to_string(allow_dev)
		+"\n\tDeviation for muR from Higgs-mass "+ std::to_string(abs(massHiggs-muR)/massHiggs));
		
	}


	// with renormalization of the wilson coefficient
					
	//1/eps^2
	heftTensorRe[0] = 0.0;
	heftTensorIm[0] = 0.0;
	//1/eps-pole
	heftTensorRe[1] = 0.0;
	heftTensorIm[1] = 0.0;
	//eps^0
	// This is the IR-subtracted and MSbar-renormalized finite piece. 
	// I also added the Nc*Pi^2 Mlo piece for matching to FKS
	// (see: FKS_vs_DIPOLE_implementation_notes.pdf)
	heftTensorRe[2] = 11.0/2.0+1/2.0*Nc*pow(M_PI,2);	
	heftTensorIm[2] = b0*M_PI/2.0;


}