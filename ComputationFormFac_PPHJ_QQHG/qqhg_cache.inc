      integer gghg_max_cache
	  parameter (gghg_max_cache=1000)
      double precision gghg_tol
	  parameter (gghg_tol=1.0d-13)

	  integer curr_cache_size
	  double precision key_P(gghg_max_cache,0:3,3)
	  double precision key_MA(gghg_max_cache)
	  double precision key_MB(gghg_max_cache)
	  integer key_id(gghg_max_cache)

	  double precision value_Im(gghg_max_cache,4)
	  double precision value_Re(gghg_max_cache,4)
	  
      data curr_cache_size/0/
      common/GGHG/curr_cache_size,key_P,key_MA,
     & key_MB,key_id,value_Im,value_Re
