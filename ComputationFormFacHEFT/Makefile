CC = g++
CF = gfortran
CFLAGS  = -c -Wall
FFLAGS  = -fbounds-check -lstdc++ -g 
CL = ar rcs
RM = rm -rf
# default: libggHgLOQCD.a
# libggHgLOQCD.a: ggHgLOQCD_fortran_bridge_ggHg_QCD_ggHg_QCD.o set_coefficient_ggHg_QCD.o
# 	$(BUILDLIB) libggHgLOQCD.a ggHgLOQCD_fortran_bridge_ggHg_QCD_ggHg_QCD.o set_coefficient_ggHg_QCD.o
all: fortran_bri
	$(CL)  libggHgLOQCD_fortran_bridge_ggHg_QCD.a ggHgLOQCD_fortran_bridge_ggHg_QCD.o
fortran_bri: ggHgLOQCD_fortran_bridge_ggHg_QCD.cpp
	$(CC) $(CFLAGS) ggHgLOQCD_fortran_bridge_ggHg_QCD.cpp

# fortran_eval:  ggHgLOQCD_set_coefficient_ggHg_QCD.f
# 	$(CF) $(CFLAGS) ggHgLOQCD_set_coefficient_ggHg_QCD.f

clean: 
	$(RM) count *.o *.out *.a