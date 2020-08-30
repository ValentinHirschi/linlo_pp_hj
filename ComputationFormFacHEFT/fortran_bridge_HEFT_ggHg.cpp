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





extern"C" void %(C_prefix)sget_gggh_heft_coefs_fortran_(const double *pInput,
		                const double &	massHiggs,
						double *gghgHEFTTensor
						)  {
		int npart = 3;
	    double p[3][4];
		double mmH;

		mmH = pow(massHiggs,2);
		for (int i=0; i<npart*4; i=i+4) {
			for (int j=0; j<4; j++) {
				p[(i/4)][j]=pInput[i+j];
			}
		}

	  double s, t;
	  s =  (p[0][0]+p[1][0])*(p[0][0]+p[1][0]) - (p[0][1]+p[1][1])*(p[0][1]+p[1][1]) - (p[0][2]+p[1][2])*(p[0][2]+p[1][2]) - (p[0][3]+p[1][3])*(p[0][3]+p[1][3]);
      t =  (p[0][0]-p[2][0])*(p[0][0]-p[2][0]) - (p[0][1]-p[2][1])*(p[0][1]-p[2][1]) - (p[0][2]-p[2][2])*(p[0][2]-p[2][2]) - (p[0][3]-p[2][3])*(p[0][3]-p[2][3]);


    

	gghgHEFTTensor[0]=-4/t;
	gghgHEFTTensor[1]=4/s;
	gghgHEFTTensor[2]=-4/s;
	gghgHEFTTensor[3]=(-4*(pow(s,2) + s*t + pow(t,2) - mmH*(s + t)))/(s*t*(-mmH + s + t));

}