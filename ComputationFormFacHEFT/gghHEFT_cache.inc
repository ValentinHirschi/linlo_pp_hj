      integer max_cache_size
	  parameter (max_cache_size=100)
      double precision cache_tolerance
	  parameter (cache_tolerance=1.0d-13)

	  integer curr_cache_size
	  double precision key_MA(max_cache_size)
	  double precision key_MB(max_cache_size)
	  double precision key_NLOOPS(max_cache_size)
	  double precision key_EPS(max_cache_size)
	  double precision value_HEFTLO(max_cache_size)
	  double precision value_HEFTTensorRe(max_cache_size,3)
	  double precision value_HEFTTensorIm(max_cache_size,3)


      data curr_cache_size/0/
      common/GGHHEFT/curr_cache_size,key_MA,key_MB,
     & key_NLOOPS,key_EPS,value_HEFTLO,value_HEFTTensorRe,value_HEFTTensorIm
