      integer max_cache_ewvirt
	  parameter (max_cache_ewvirt=100)
      double precision tol_ewvirt
	  parameter (tol_ewvirt=1.0d-13)

	  integer curr_size_ewvirt
	  ! MH, MZ, MW are provided from the param-card
	  ! they are not assumed to be changed on runtime
	  double precision key_NLOOPSEW(max_cache_ewvirt)
	  double precision value_EWLORe(max_cache_ewvirt,2)
	  double precision value_EWLOIm(max_cache_ewvirt,2)
	  double precision value_EWNLORe(max_cache_ewvirt,2)
	  double precision value_EWNLOIm(max_cache_ewvirt,2)


      data curr_size_ewvirt/0/
      common/GGHEW/curr_size_ewvirt,key_NLOOPSEW,
     & value_EWLORe,value_EWLOIm,value_EWNLORe,value_EWNLOIm
