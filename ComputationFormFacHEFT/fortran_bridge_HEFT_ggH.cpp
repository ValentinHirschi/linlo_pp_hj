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


extern"C" void get_ggh_heft_coefs_fortran_(
		                const double &	massHiggs,
						const double &	muR,
						double *heftTensorRe,
						double *heftTensorIm
						)  {
	// 1/eps-pole
	double b0, Nf, Nc;
	Nc =3.0;
	Nf=5.0;


	// with renormalization of the wilson coefficient
	b0 = (11*Nc)/3. - (2*Nf)/3.;						
	//1/eps^2
	heftTensorRe[0] = -2*Nc;
	heftTensorIm[0] = 0.0;
	//1/eps-pole
	heftTensorRe[1] = -b0 + 2*Nc*log(pow(massHiggs,2)/pow(muR,2));
	heftTensorIm[1] = -2*Nc*M_PI;
	//eps^0
	heftTensorRe[2] = 11 + Nc*pow(M_PI,2) - Nc*pow(log(pow(massHiggs,2)/pow(muR,2)),2);
	// loop asMSBAR 11 + (7*Nc*pow(M_PI,2))/6. - Nc*pow(log(pow(massHiggs,2)/pow(muR,2)),2);
	
	heftTensorIm[2] = 2*Nc*M_PI*log(pow(massHiggs,2)/pow(muR,2));


}