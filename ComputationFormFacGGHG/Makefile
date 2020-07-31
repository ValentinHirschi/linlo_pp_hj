#
# This is an example Makefile for a countwords program.  This
# program uses both the scanner module and a counter module.
# Typing 'make' or 'make count' will create the executable file.
#

# define some Makefile variables for the compiler and compiler flags
# to use Makefile variables later in the Makefile: $()
#
#  -g    adds debugging information to the executable file
#  -Wall turns on most, but not all, compiler warnings
#
# for C++ define  CC = g++
CC = g++
CF = gfortran
CFLAGS  = -c -Wall
FFLAGS  = -fbounds-check -lstdc++ -g 
RM = rm -rf
default: testEvaluation
testEvaluation: fortran_bridge_test.o  set_coefficient_test.o
	$(CF) fortran_bridge_test.o  set_coefficient_test.o $(FFLAGS) -o testEvaluation 
fortran_bridge_test.o:  fortran_bridge_test.cpp 
	$(CC) $(CFLAGS) fortran_bridge_test.cpp

set_coefficient_test.o:  set_coefficient_test.f
	$(CF) -c set_coefficient_test.f

clean: 
	$(RM) count *.o *.out