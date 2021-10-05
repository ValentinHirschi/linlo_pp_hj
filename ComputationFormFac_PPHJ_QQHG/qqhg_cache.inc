      integer qqhg_max_cache
	  parameter (qqhg_max_cache=1000)
      double precision qqhg_tol
	  parameter (qqhg_tol=1.0d-13)

	  integer curr_cache_size
	  double precision key_P(qqhg_max_cache,0:3,3)
	  double precision key_MA(qqhg_max_cache)
	  double precision key_MB(qqhg_max_cache)
	  double precision key_MUR(qqhg_max_cache)
	  integer key_id(qqhg_max_cache)

	  double precision value_Im(qqhg_max_cache,4)
	  double precision value_Re(qqhg_max_cache,4)
	  
      data curr_cache_size/0/
      common/QQHG/curr_cache_size,key_P,key_MA,
     & key_MB,key_MUR,key_id,value_Im,value_Re
