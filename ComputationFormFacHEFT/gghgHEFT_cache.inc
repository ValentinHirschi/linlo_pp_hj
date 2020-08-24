      integer max_cache_gghg
	  parameter (max_cache_gghg=1000)
      double precision tol_gghg
	  parameter (tol_gghg=1.0d-13)

	  integer curr_cache_gghg
	  double precision key_Pgghg(max_cache_gghg,0:3,3)
	  double precision key_Mgghg(max_cache_gghg)

	  double precision value_gghgHEFTTensor(max_cache_gghg,4)

	  
      data curr_cache_gghg/0/
      common/GGHGHEFT/curr_cache_gghg,key_Pgghg,key_Mgghg,
     & value_gghgHEFTTensor
