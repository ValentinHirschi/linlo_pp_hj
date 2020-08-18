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
	Nc =3;
	Nf=5;
	b0 = (11*Nc)/3. - (2*Nf)/3.;						
	// 1/eps-pole
	heftTensorRe[0] = -b0 + 2*Nc*log(pow(massHiggs,2)/pow(muR,2));
	heftTensorIm[0] = -2*Nc*M_PI;
	// eps^0
	heftTensorRe[1] = 11 + (7*Nc*pow(M_PI,2))/6. - Nc*pow(Log(pow(massHiggs,2)/pow(muR,2)),2);
	heftTensorIm[1] = 2*Nc*M_PI*log(pow(massHiggs,2)/pow(muR,2));


}