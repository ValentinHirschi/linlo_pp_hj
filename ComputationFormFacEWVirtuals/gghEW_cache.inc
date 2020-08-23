      integer max_cache_size
	  parameter (max_cache_size=100)
      double precision cache_tolerance
	  parameter (cache_tolerance=1.0d-13)

	  integer curr_cache_size
	  ! MH, MZ, MW are provided from the param-card
	  ! they are not assumed to be changed on runtime
	  double precision key_MUR(max_cache_size)
	  double precision key_NLOOPSEW(max_cache_size)
	  double precision key_EPSEW(max_cache_size)
	  double precision value_EWLORe(max_cache_size,2)
	  double precision value_EWLOIm(max_cache_size,2)
	  double precision value_EWNLORe(max_cache_size,2)
	  double precision value_EWNLOIm(max_cache_size,2)


      data curr_cache_size/0/
      common/GGHEW/curr_cache_size,key_MUR,key_NLOOPSEW,key_EPSEW,
     & value_EWLORe,value_EWLOIm,value_EWNLORe,value_EWNLOIm
