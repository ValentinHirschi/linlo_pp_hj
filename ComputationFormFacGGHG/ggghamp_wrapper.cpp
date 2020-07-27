#include <iostream>
#include <iomanip>
#include <cmath>
#include <cstdio>
#include <sstream>
#include <ginac/ginac.h>
#include "ggvvamp.h"
#include "ggvvampprec.h"

using namespace std;
using namespace GiNaC;

int main(int argc, char* argv[])
{

    if (argc < 2) {
        // Tell the user how to run the program
        std::cerr << "Usage: " << argv[0] << " pInput(16 floats) mass3(float) mass4(float) requiredAccuracy(float) Nf(int)" << std::endl;
		std::cerr << "Ouptut: " << " oneLoopTensorRe(20 floats) oneLoopTensorIm(20 floats) twoLoopTensorRe(20 floats) twoLoopTensorIm(20 floats) "<<endl;
        return 1;
    }

    double pInput[16];
    double mass3;
	double mass4;
	double requiredAccuracy;
	int Nf;
	double oneLoopTensorRe[nAcoeff];
	double oneLoopTensorIm[nAcoeff];
	double twoLoopTensorRe[nAcoeff];
	double twoLoopTensorIm[nAcoeff];

	for (int i=1; i<17; i++) {
	  pInput[i-1] = std::stod(argv[i]);
	}
	mass3 = std::stod(argv[17]);
	mass4 = std::stod(argv[18]);
	requiredAccuracy = std::stod(argv[19]);
	Nf = std::stoi(argv[20]);

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
  std::cerr << setprecision(15);
  cerr<<"Checker3"<<endl;
  cerr<<"ma2="<<ma2<<endl;
  cerr<<"mb2="<<mb2<<endl;

  cerr<<"s="<<s<<endl;
  cerr<<"t="<<t<<endl;  
  cerr<<"p[0][*]="<<p[0][0]<<","<<p[0][1]<<","<<p[0][2]<<","<<p[0][3]<<","<<endl;
  cerr<<"p[1][*]="<<p[1][0]<<","<<p[1][1]<<","<<p[1][2]<<","<<p[1][3]<<","<<endl;
  cerr<<"p[2][*]="<<p[2][0]<<","<<p[2][1]<<","<<p[2][2]<<","<<p[2][3]<<","<<endl;
  cerr<<"p[3][*]="<<p[3][0]<<","<<p[3][1]<<","<<p[3][2]<<","<<p[3][3]<<","<<endl;
*/

  // for checks on crossings
  //swap(ma2,mb2); // crossing x12x34
  //t = ma2 + mb2 - s - t; // crossing x12

  amp.compute(s,t,ma2,mb2);

  for (int i = 1; i <= nAcoeff; ++i) {
    oneLoopTensorRe[i-1] = amp.A[i][0][0];
    oneLoopTensorIm[i-1] = amp.A[i][0][1];
    twoLoopTensorRe[i-1] = amp.A[i][1][0];
    twoLoopTensorIm[i-1] = amp.A[i][1][1];
  }

/*
  std::cerr << setprecision(15);  
  cerr << "E[Helicity][EcoeffID][loopNumber]([0=Re,1=Im]) ::" << endl;
  for (int l = 0 ; l < nloop; ++l) {
    for (int i = 0 ; i < nEhel; ++i) {
      for (int j = 1 ; j <= nEcoeff; ++j) {
        cerr << i << " \t" << j << " \t" << l;
        cerr << " \t" << amp.E[i][j][l][0];
        cerr << " \t" << amp.E[i][j][l][1];
        cerr << "\n";
      }
    }
  }
  cerr << "A[EcoeffID][loopNumber]([0=Re,1=Im]) ::" << endl;
  for (int l = 0 ; l < nloop; ++l) {
    for (int i = 1; i <= nAcoeff; ++i) {
      cerr << i << " \t" << l ;
      cerr << " \t" << amp.A[i][l][0];
      cerr << " \t" << amp.A[i][l][1];
      cerr << "\n";
	}
  }
  cerr << endl;
*/
    
    std::ostringstream ostr;
	ostr.precision(17);
	ostr<<scientific;
	ostr<<"START_OUTPUT_STREAM ";
    for (int i = 1; i <= nAcoeff; ++i) {
		ostr<<oneLoopTensorRe[i-1]<<" ";
	}
    for (int i = 1; i <= nAcoeff; ++i) {
		ostr<<oneLoopTensorIm[i-1]<<" ";
	}
    for (int i = 1; i <= nAcoeff; ++i) {
		ostr<<twoLoopTensorRe[i-1]<<" ";
	}
    for (int i = 1; i <= nAcoeff; ++i) {
		ostr<<twoLoopTensorIm[i-1]<<" ";			
	}
	ostr<<"END_OUTPUT_STREAM ";	
    std::cout << ostr.str();
}
