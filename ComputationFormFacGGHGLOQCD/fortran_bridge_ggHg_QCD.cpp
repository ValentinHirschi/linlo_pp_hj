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



extern"C" void get_gggh_tensor_coefs_fortran_(const double *pInput,
		                const double &	massHiggs,
						const double &	massTop,
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


	if (exists("PATHTOC/mathematicaRoutines/HJ1L/exphj1l.wls")) {
		ostr<<"PATHTOC/mathematicaRoutines/HJ1L/exphj1l.wls ";
	} else  {
	   std::cerr<<"Could Not find 'exphj1l.wls'. Place it somewhere as defined in fortran_bridge_ggHg_QCD.cpp"<<std::endl;
       exit (EXIT_FAILURE);
	}
	ostr<< s << " ";
    ostr<<t<<" ";
    ostr<<massHiggs<<" ";
    ostr<<massTop;
	
	std::string command = ostr.str();
	std::cout<<"About to call wrapper with: "<<command<<std::endl;
    std::string str_result = exec(command.c_str());
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