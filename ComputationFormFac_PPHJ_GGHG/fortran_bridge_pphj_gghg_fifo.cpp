#include <iostream>
#include <stdexcept>
#include <string>
#include <sstream>
#include <vector>
#include <sys/stat.h>
#include <unistd.h>
#include <fstream>

#include <cstdio>
#include <memory>
#include <array>

using namespace std;

const bool PIPE_TO_STDOUT = false;

#include <random>
#include <sstream>

#include <stdio.h> 
#include <string.h> 
#include <fcntl.h> 
#include <sys/types.h> 

namespace %(C_prefix)spphj_gghg_uuid {
    static std::random_device              rd;
    static std::mt19937                    gen(rd());
    static std::uniform_int_distribution<> dis(0, 15);
    static std::uniform_int_distribution<> dis2(8, 11);

    std::string %(C_prefix)sgenerate_uuid_v4() {
        std::stringstream ss;
        int i;
        ss << std::hex;
        for (i = 0; i < 8; i++) {
            ss << dis(gen);
        }
        ss << "-";
        for (i = 0; i < 4; i++) {
            ss << dis(gen);
        }
        ss << "-4";
        for (i = 0; i < 3; i++) {
            ss << dis(gen);
        }
        ss << "-";
        ss << dis2(gen);
        for (i = 0; i < 3; i++) {
            ss << dis(gen);
        }
        ss << "-";
        for (i = 0; i < 12; i++) {
            ss << dis(gen);
        };
        return ss.str();
    }
}

/*
std::string %(C_prefix)spphj_gghg_exec(const char* cmd) {
    char buffer[128];
    std::string result = "";
    FILE* pipe = popen(cmd, "r");
	if (PIPE_TO_STDOUT) std::cout<<"\nStart MM call"<<std::endl;
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
	if (PIPE_TO_STDOUT) std::cout<<"\nDone with the MM call"<<std::endl;	
    return result;
}
*/

/*
std::string %(C_prefix)spphj_gghg_exec(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result("");
	std::string target_start("START_OUTPUT_STREAM");	
	std::string target_end("END_OUTPUT_STREAM");
	if (PIPE_TO_STDOUT) std::cout<<"\nStart MM call"<<std::endl;
    std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
	std::size_t found;
	bool must_read = false;
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
		std::string buffer_str(buffer.data());
		found = buffer_str.find(target_start);
		if (found!=std::string::npos && !must_read) {
			must_read = true;
		}
		if (must_read) {
			result += buffer_str;
		}
		if (PIPE_TO_STDOUT) {
			std::cout<<buffer_str<<std::flush;
		}
		found = buffer_str.find(target_end);
		if (found!=std::string::npos) {
			break;
		}
    }
	if (PIPE_TO_STDOUT) std::cout<<"\nWe are done with MM call"<<std::endl;
    return result;
}
*/

std::string %(C_prefix)spphj_gghg_exec(const char* cmd) {
    const int bufsize=128;
	std::string output;
    std::array<char, bufsize> buffer;

    auto pipe = popen(cmd, "r");
	if (PIPE_TO_STDOUT) std::cout<<"\nStart MM call"<<std::endl;

    if (!pipe) throw std::runtime_error("popen() failed!");

    size_t count;
    do {
        if ((count = fread(buffer.data(), 1, bufsize, pipe)) > 0) {
			std::string one_elem;
            one_elem.insert(one_elem.end(), std::begin(buffer), std::next(std::begin(buffer), count));
			if (PIPE_TO_STDOUT) {
				std::cout<<one_elem<<std::flush;
			}			
			output = output+one_elem;
            //output.insert(output.end(), std::begin(buffer), std::next(std::begin(buffer), count));
        }
    } while(count > 0);

	if (PIPE_TO_STDOUT) std::cout<<"\nWe are done with MM call"<<std::endl;
    int ret_code = pclose(pipe);
	if (PIPE_TO_STDOUT) std::cout<<"\nWe closed MM"<<std::endl;
	return output;
}

inline bool %(C_prefix)spphj_gghg_exists(const std::string& name) {
    return ( access( name.c_str(), F_OK ) != -1 );
}

extern"C" void %(C_prefix)sget_pphj_gghg_tensor_coefs_(
		                const bool & HEFT_selected,
						const int & pphj_eps_order,
						const int & nloop,
						const int & nf,
						const bool & inc_ytqcd,
						const bool & inc_ytmb,
						const bool & inc_ytmt,
						const bool & inc_ybqcd,
						const bool & inc_ybmb,
						const bool & inc_ybmt,
		                const double *pInput,						
						const double &	mb,
						const double &	mt,
						const double &	massHiggs,
						const double &	mu_r,
						const double &	yb,
						const double &	yt,
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

	std::string mathematica_input_file("%(path_prefix)s/mathematicaRoutines/mathematica_input.fifo");

	if (!%(C_prefix)spphj_gghg_exists(mathematica_input_file)) {
	   std::cerr<<"Could Not find 'mathematica_input.fifo'. Place it somewhere as defined in fortran_bridge_pphj_gghg_fifo.cpp"<<std::endl;
       exit (EXIT_FAILURE);
	}

	string tmp_file = "%(path_prefix)s/mathematicaRoutines/"+%(C_prefix)spphj_gghg_uuid::%(C_prefix)sgenerate_uuid_v4()+"_tmp.fifo";

	// Create the output fifo file
	//std::string mkfifo("mkfifo "+tmp_file);
	//system(mkfifo.c_str());
	mkfifo(tmp_file.c_str(), 0666); 


	// Check if the PS-point is physical
	if ((s*t*(massHiggs*massHiggs-s-t))<0){
		std::cerr<<"The condition s*t*u>0 for:"<<std::endl;
		std::cerr<<"s: "<<s<<std::endl;
		std::cerr<<"t: "<<t<<std::endl;
		std::cerr<<"u: "<<(massHiggs*massHiggs-s-t)<<std::endl;
		std::cerr<<"is not fulfilled!"<<std::endl;
       	exit (EXIT_FAILURE);
	}

	ostr<<s<< " ";
    ostr<<t<<" ";
	ostr<<mu_r<<" ";
    ostr<<massHiggs<<" ";
    ostr<<((mb > 1.0e-16) ? mb : 0.)<<" ";
    ostr<<mt<<" ";
    ostr<<((yb > 1.0e-16) ? yb : 0.)<<" ";
    ostr<<yt<<" ";
    ostr<<nloop<<" ";
	ostr<<pphj_eps_order<<" ";
	ostr<<nf<<" ";
	ostr<<HEFT_selected<<" ";
    ostr<<inc_ytqcd<<" ";
    ostr<<inc_ytmb<<" ";
    ostr<<inc_ytmt<<" ";
    ostr<<inc_ybqcd<<" ";
    ostr<<inc_ybmb<<" ";
    ostr<<inc_ybmt<<" ";
	
	ostr<<" "<<tmp_file;

	std::string command = ostr.str();
	std::cout<<"About to call wrapper with: "<<command<<std::endl<< std::flush;
	int fd;
	fd = open(mathematica_input_file.c_str(), O_WRONLY); 
	write(fd, command.c_str(), strlen(command.c_str())); 
    close(fd);
	std::cout<<"Mathematica command sent and waiting for output."<<std::endl<<std::flush;

	// Now read the result in a blocking fashion
	char char_res[10000];
	fd = open(tmp_file.c_str(), O_RDONLY);
	read(fd, char_res, sizeof(char_res)); 
	std::string str_result(char_res);
	close(fd);

	remove(tmp_file.c_str());


	if (PIPE_TO_STDOUT) std::cout<<"\nI got the following result from MM=\n"<<str_result<<std::endl;
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
		if (PIPE_TO_STDOUT) std::cout<<"oneLoopTensorRe["<<i<<"]="<<oneLoopTensorRe[i]<<std::endl;
	}
	for(int i=4; i<8; i++) {
		oneLoopTensorIm[i-4]=std::stod(result[i]);
		if (PIPE_TO_STDOUT) std::cout<<"oneLoopTensorIm["<<i-4<<"]="<<oneLoopTensorIm[i-4]<<std::endl;
	}

}
