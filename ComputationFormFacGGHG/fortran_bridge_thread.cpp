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

extern "C" {
//Fortran interface
  void get_gggh_tensor_coefs_thread_(const double *   pInput,
		                const double &   massTop,
						const double &   massHiggs,
						double *   oneLoopTensorRe,
						double *   oneLoopTensorIm,
						)
  {
	  
	  double s, t;
	  s =  (p[0][0]+p[1][0])*(p[0][0]+p[1][0]) - (p[0][1]+p[1][1])*(p[0][1]+p[1][1]) - (p[0][2]+p[1][2])*(p[0][2]+p[1][2]) - (p[0][3]+p[1][3])*(p[0][3]+p[1][3]);
      t =  (p[0][0]-p[2][0])*(p[0][0]-p[2][0]) - (p[0][1]-p[2][1])*(p[0][1]-p[2][1]) - (p[0][2]-p[2][2])*(p[0][2]-p[2][2]) - (p[0][3]-p[2][3])*(p[0][3]-p[2][3]);


    std::ostringstream ostr;
	ostr.precision(17);
	ostr<<scientific;


	if (exists("../../../Source/ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"../../../Source/ggvvamp-1.0/ggvvamp_wrapper ";
	} else if (exists("../../Source/ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"../../Source/ggvvamp-1.0/ggvvamp_wrapper ";		
	} else if (exists("/Users/valentin/Documents/MG5/LINLO_experiment/ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"/Users/valentin/Documents/MG5/LINLO_experiment/ggvvamp-1.0/ggvvamp_wrapper ";
	} else if (exists("../Source/ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"../Source/ggvvamp-1.0/ggvvamp_wrapper ";		
	} else if (exists("./Source/ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"./Source/ggvvamp-1.0/ggvvamp_wrapper ";		
	} else if (exists("./ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"./ggvvamp-1.0/ggvvamp_wrapper ";		
	} else if (exists("./ggvvamp-1.0/ggvvamp_wrapper")) {
		ostr<<"./ggvvamp-1.0/ggvvamp_wrapper ";		
	} else if (exists("./ggvvamp_wrapper")) {
		ostr<<"./ggvvamp_wrapper ";		
	} else if (exists("../ggvvamp_wrapper")) {
		ostr<<"../ggvvamp_wrapper ";		
	} else if (exists("../../ggvvamp_wrapper")) {
		ostr<<"../../ggvvamp_wrapper ";		
	} else if (exists("../../../ggvvamp_wrapper")) {
		ostr<<"../../../ggvvamp_wrapper ";		
	} else {
	   std::cerr<<"Could Not find 'ggvvamp_wrapper. Place it somewhere as defined in fortran_bridge_thread.cpp"<<std::endl;
       exit (EXIT_FAILURE);
	}

    for (int i = 0; i < 3; ++i) {
		ostr<<pInput[i]<<" ";
	}
    ostr<<mass3<<" ";
    ostr<<mass4<<" ";
    ostr<<requiredAccuracy<<" ";
    ostr<<Nf;

	std::string command = ostr.str();
//	std::cout<<"About to call wrapper with: "<<command<<std::endl;	
    std::string str_result = exec(command.c_str());
//	std::cout<<"I got result="<<str_result<<std::endl;
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

	for(int i=0; i<20; i++) {
		oneLoopTensorRe[i]=std::stod(result[i]);
//		std::cout<<"oneLoopTensorRe["<<i<<"]="<<oneLoopTensorRe[i]<<std::endl;		
	}
	for(int i=20; i<40; i++) {
		oneLoopTensorIm[i-20]=std::stod(result[i]);		
//		std::cout<<"oneLoopTensorIm["<<i-20<<"]="<<oneLoopTensorIm[i-20]<<std::endl;				
	}
	for(int i=40; i<60; i++) {
		twoLoopTensorRe[i-40]=std::stod(result[i]);		
//		std::cout<<"twoLoopTensorRe["<<i-40<<"]="<<twoLoopTensorRe[i-40]<<std::endl;				
	}
	for(int i=60; i<80; i++) {
		twoLoopTensorIm[i-60]=std::stod(result[i]);		
//		std::cout<<"twoLoopTensorIm["<<i-60<<"]="<<twoLoopTensorIm[i-60]<<std::endl;				
	}

  }
}
