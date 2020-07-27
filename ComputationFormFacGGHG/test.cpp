#include <iostream>
#include <stdexcept>
#include <stdio.h>
#include <string>
#include <sstream>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>

using namespace std;

std::string exec(const char* cmd) {
    char buffer[128];
    std::string result = "";
    FILE* pipe = popen(cmd, "r");
    if (!pipe) throw std::runtime_error("popen() failed!");
    try {
        while (!feof(pipe)) {
            if (fgets(buffer, 128, pipe) != NULL)
                result += buffer;
        }
    } catch (...) {
        pclose(pipe);
        throw;
    }
    pclose(pipe);
    return result;
}

inline bool exists (const std::string& name) {
    return ( access( name.c_str(), F_OK ) != -1 );
}

//Fortran interface
  void get_gggh_tensor_coefs(const double *   pInput,
		                const double &   massTop,
						const double &   massHiggs,
						double *   oneLoopTensorRe,
						double *   oneLoopTensorIm
						)
  {
		int npart = 4;
	    double p[4][4];
		for (int i=0; i<npart*4; i=i+4) {
			for (int j=0; j<4; j++) {
				p[(i/4)][j]=pInput[i+j];
			}
		}

	  double s, t;
	  s =  (p[0][0]+p[1][0])*(p[0][0]+p[1][0]) - (p[0][1]+p[1][1])*(p[0][1]+p[1][1]) - (p[0][2]+p[1][2])*(p[0][2]+p[1][2]) - (p[0][3]+p[1][3])*(p[0][3]+p[1][3]);
      t =  (p[0][0]-p[2][0])*(p[0][0]-p[2][0]) - (p[0][1]-p[2][1])*(p[0][1]-p[2][1]) - (p[0][2]-p[2][2])*(p[0][2]-p[2][2]) - (p[0][3]-p[2][3])*(p[0][3]-p[2][3]);


    std::ostringstream ostr;
	ostr.precision(17);
	ostr<<scientific;


	if (exists("./mathematicaRoutines/evaluation_amp.wls")) {
		ostr<<"./mathematicaRoutines/evaluation_amp.wls ";
	} else  {
	   std::cerr<<"Could Not find 'evaluation_amp.wls'. Place it somewhere as defined in fortran_bridge_gggh.cpp"<<std::endl;
       exit (EXIT_FAILURE);
	}
	ostr<< s << " ";
    ostr<<t<<" ";
    ostr<<massHiggs<<" ";
    ostr<<massTop;

	std::string command = ostr.str();
	std::cout<<"About to call wrapper with: "<<command<<std::endl;
    std::string str_result = exec(command.c_str());
	std::cout<<"I got result="<<str_result<<std::endl;
    vector<std::string> result;
	std::istringstream iss(str_result);
	bool output_stream_on = false;
	for(std::string s; iss >> s; ) {
//		std::cout<<"s="<<s<<std::endl;
		if (s.compare("END_OUTPUT_STREAM")==0)
			output_stream_on = false;
		if (output_stream_on)
		  result.push_back(s);
		if (s.compare("START_OUTPUT_STREAM")==0)
			output_stream_on = true;
	}

	for(int i=0; i<4; i++) {
		oneLoopTensorRe[i]=std::stod(result[i]);
		std::cout<<"oneLoopTensorRe["<<i<<"]="<<oneLoopTensorRe[i]<<std::endl;
	}
	for(int i=4; i<8; i++) {
		oneLoopTensorIm[i-4]=std::stod(result[i]);
		std::cout<<"oneLoopTensorIm["<<i-4<<"]="<<oneLoopTensorIm[i-4]<<std::endl;
	}

  }

int main ()
{
	double pp[16]={
	0.500000000000000E+03,    0.000000000000000E+00,    0.000000000000000E+00,    0.500000000000000E+03,
	0.500000000000000E+03,    0.000000000000000E+00,    0.000000000000000E+00,   -0.500000000000000E+03,
	0.492187500000000E+03,   -0.109191092499398E+03,   -0.437880308402370E+03,    0.196434915400709E+03,
	0.507812500000000E+03,    0.109191092499398E+03,    0.437880308402370E+03,   -0.196434915400709E+03
		};
	double mmT=172.;
	double mmH=125.;
	double repart[4]={};
	double impart[4]={};
	get_gggh_tensor_coefs(pp,mmT,mmH,repart,impart);
	return 0;
}
