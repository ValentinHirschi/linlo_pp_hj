      integer max_cache_size
	  parameter (max_cache_size=10)
      double precision cache_tolerance
	  parameter (cache_tolerance=1.0d-13)

	  integer curr_cache_size
	  double precision key_MA(max_cache_size)
	  double precision key_MB(max_cache_size)

	  double precision value_HEFTTensorRe(max_cache_size,2)
	  double precision value_HEFTTensorIm(max_cache_size,2)
	  
      data curr_cache_size/0/
      common/GGHGLOQCD/curr_cache_size,key_MA,key_MB
     & value_HEFTTensorRe,value_HEFTTensorIm
