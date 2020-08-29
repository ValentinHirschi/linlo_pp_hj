      integer max_cache_size
	  parameter (max_cache_size=1000)
      double precision cache_tolerance
	  parameter (cache_tolerance=1.0d-13)

	  integer curr_cache_size
	  double precision key_P(max_cache_size,0:3,3)
	  double precision key_MA(max_cache_size)
	  double precision key_MB(max_cache_size)

	  double precision value_oneLoopTensorRe(max_cache_size,4)
	  double precision value_oneLoopTensorIm(max_cache_size,4)
	  
      data curr_cache_size/0/
      common/GGHGLOQCD/curr_cache_size,key_P,key_MA,key_MB,
     & value_oneLoopTensorRe,value_oneLoopTensorIm
