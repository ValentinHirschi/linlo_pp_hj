grid_filler: grid_filler.f LI_at_NLO_proc
	gfortran -o grid_filler grid_filler.f -L./LI_at_NLO_proc/lib/ -lPROC_2 -lstdc++
grid_filler_princess: grid_filler_princess.f LI_at_NLO_proc
	gfortran -o grid_filler_princess grid_filler_princess.f -L./LI_at_NLO_proc/lib/ -lPROC_2 -lstdc++
clean:
	rm -f *.o grid_filler
