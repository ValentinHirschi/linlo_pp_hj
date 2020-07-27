#include <iostream>
#include <iomanip>
#include <cmath>
#include <cstdio>
#include <ginac/ginac.h>
#include "ggvvamp.h"
#include "ggvvampprec.h"

using namespace std;
using namespace GiNaC;


extern "C" {
//Fortran interface
  void get_ggvv_tensor_coefs_no_thread_(const double *   pInput,
		                const double &   mass3,
						const double &   mass4,
						const double &   requiredAccuracy,
						const int & Nf,
						double *   oneLoopTensorRe,
						double *   oneLoopTensorIm,
						double *   twoLoopTensorRe,
						double *   twoLoopTensorIm
						)
  {

  int npart = 4;
//  ggvvampprec amp(Nf, IRschemeCatani);
  ggvvampprec amp(Nf, IRschemeQt);
  amp.maxrel = requiredAccuracy;

// alternatively use fixed precision evaluation:
//  typedef quadtype T;
//  typedef cln::cl_F T;
//  typedef double T;
//  GiNaC::Digits = 32;
//  ggvvamp<T> amp(Nf, IRschemeQt);

  double p[4][4];
  for (int i=0; i<npart*4; i=i+4) {
	for (int j=0; j<4; j++) {
	  p[(i/4)][j]=pInput[i+j];		  
	}
  }

  // Compute invariants
  double s, t, ma2, mb2;
  ma2 = mass3*mass3;
  mb2 = mass4*mass4;
  s =  (p[0][0]+p[1][0])*(p[0][0]+p[1][0]) - (p[0][1]+p[1][1])*(p[0][1]+p[1][1]) - (p[0][2]+p[1][2])*(p[0][2]+p[1][2]) - (p[0][3]+p[1][3])*(p[0][3]+p[1][3]);
  t =  (p[0][0]-p[2][0])*(p[0][0]-p[2][0]) - (p[0][1]-p[2][1])*(p[0][1]-p[2][1]) - (p[0][2]-p[2][2])*(p[0][2]-p[2][2]) - (p[0][3]-p[2][3])*(p[0][3]-p[2][3]);

// Benchmark point
//  s = 15625.;
//  t = -2384.89727896833;
//  ma2 = 6467.215561;
//  mb2 = 625.;
/*
  std::cout << setprecision(15);
  cout<<"Checker3"<<endl;
  cout<<"ma2="<<ma2<<endl;
  cout<<"mb2="<<mb2<<endl;

  cout<<"s="<<s<<endl;
  cout<<"t="<<t<<endl;  
  cout<<"p[0][*]="<<p[0][0]<<","<<p[0][1]<<","<<p[0][2]<<","<<p[0][3]<<","<<endl;
  cout<<"p[1][*]="<<p[1][0]<<","<<p[1][1]<<","<<p[1][2]<<","<<p[1][3]<<","<<endl;
  cout<<"p[2][*]="<<p[2][0]<<","<<p[2][1]<<","<<p[2][2]<<","<<p[2][3]<<","<<endl;
  cout<<"p[3][*]="<<p[3][0]<<","<<p[3][1]<<","<<p[3][2]<<","<<p[3][3]<<","<<endl;
*/

  // for checks on crossings
  //swap(ma2,mb2); // crossing x12x34
  //t = ma2 + mb2 - s - t; // crossing x12
//  std::cout<<"DOING IT NOW: START"<<std::endl;
//  std::cout<<"s="<<s<<std::endl;
//  std::cout<<"t="<<t<<std::endl;
//  std::cout<<"ma2="<<ma2<<std::endl;
//  std::cout<<"mb2="<<mb2<<std::endl;
// Benchmark point
//  s = 15625.;
//  t = -2384.89727896833;
//  ma2 = 6467.215561;
//  mb2 = 625.;
// Slow leaky point
//  s=1e+06;
//  t=-687891.;
//  ma2=8315.25;
//  mb2=8315.25;
  amp.compute(s,t,ma2,mb2);
//  std::cout<<"DOING IT NOW: END"<<std::endl;

  for (int i = 1; i <= nAcoeff; ++i) {
    oneLoopTensorRe[i-1] = amp.A[i][0][0];
    oneLoopTensorIm[i-1] = amp.A[i][0][1];
    twoLoopTensorRe[i-1] = amp.A[i][1][0];
    twoLoopTensorIm[i-1] = amp.A[i][1][1];
  }

/*
  std::cout << setprecision(15);  
  cout << "E[Helicity][EcoeffID][loopNumber]([0=Re,1=Im]) ::" << endl;
  for (int l = 0 ; l < nloop; ++l) {
    for (int i = 0 ; i < nEhel; ++i) {
      for (int j = 1 ; j <= nEcoeff; ++j) {
        cout << i << " \t" << j << " \t" << l;
        cout << " \t" << amp.E[i][j][l][0];
        cout << " \t" << amp.E[i][j][l][1];
        cout << "\n";
      }
    }
  }
  cout << "A[EcoeffID][loopNumber]([0=Re,1=Im]) ::" << endl;
  for (int l = 0 ; l < nloop; ++l) {
    for (int i = 1; i <= nAcoeff; ++i) {
      cout << i << " \t" << l ;
      cout << " \t" << amp.A[i][l][0];
      cout << " \t" << amp.A[i][l][1];
      cout << "\n";
	}
  }
  cout << endl;
*/

  }
}
