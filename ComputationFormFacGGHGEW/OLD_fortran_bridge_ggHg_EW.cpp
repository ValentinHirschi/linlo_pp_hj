#include <iostream>
#include <stdexcept>
#include <stdio.h>
#include <string>
#include <sstream>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>

using namespace std;

const bool PIPE_TO_STDOUT = true;

std::string %(C_prefix)sexec_ew(const char* cmd) {
    char buffer[128];
    std::string result = "";
    FILE* pipe = popen(cmd, "r");
    if (!pipe) throw std::runtime_error("popen() failed!");
    try {
        while (!feof(pipe)) {
            if (fgets(buffer, 128, pipe) != NULL)
                result += buffer;
			    if (PIPE_TO_STDOUT) std::cout<<buffer<<std::flush;
        }
    } catch (...) {
        pclose(pipe);
        throw;
    }
    pclose(pipe);
    return result;
}

inline bool exists_ew (const std::string& name) {
    return ( access( name.c_str(), F_OK ) != -1 );
}



extern"C" void %(C_prefix)sget_gggh_tensor_coefs_ew_(const double *pInput,
		                const double &	massHiggs,
						const double &	massBoson,
						double *oneLoopTensorRe,
						double *oneLoopTensorIm
						)  {
		int npart = 3;
	    double p[3][4];
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


	if (exists_ew("%(path_prefix)s/mathematicaRoutines/expew.wls")) {
		ostr<<"%(path_prefix)s/mathematicaRoutines/expew.wls ";
	} else  {
	   std::cerr<<"Could Not find 'expew.wls'. Place it somewhere as defined in fortran_bridge_ggHg_EW.cpp"<<std::endl;
       exit (EXIT_FAILURE);
	}

	// Check if the PS-point is physical
	if ((s*t*(massHiggs*massHiggs-s-t))<0){
		std::cerr<<"The condition s*t*u>0 for:"<<std::endl;
		std::cerr<<"s: "<<s<<std::endl;
		std::cerr<<"t: "<<t<<std::endl;
		std::cerr<<"u: "<<(massHiggs*massHiggs-s-t)<<std::endl;
		std::cerr<<"is not fulfilled!"<<std::endl;
       	exit (EXIT_FAILURE);
	}


	ostr<< s << " ";
    ostr<<t<<" ";
    ostr<<massHiggs<<" ";
    ostr<<massBoson;
	
	std::string command = ostr.str();
	std::cout<<"About to call wrapper with: "<<command<<std::endl;
    std::string str_result = %(C_prefix)sexec_ew(command.c_str());
	// std::cout<<"I got result="<<str_result<<std::endl;
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
		if (s.compare("NaN")==0 && output_stream_on) {
			std::cerr<<"Encountered Mathematica Error NaN:"<<std::endl;
			exit (EXIT_FAILURE);
		}
	}

	for(int i=0; i<4; i++) {
		oneLoopTensorRe[i]=std::stod(result[i]);
		// std::cout<<"oneLoopTensorRe["<<i<<"]="<<oneLoopTensorRe[i]<<std::endl;
	}
	for(int i=4; i<8; i++) {
		oneLoopTensorIm[i-4]=std::stod(result[i]);
		// std::cout<<"oneLoopTensorIm["<<i-4<<"]="<<oneLoopTensorIm[i-4]<<std::endl;
	}

}
