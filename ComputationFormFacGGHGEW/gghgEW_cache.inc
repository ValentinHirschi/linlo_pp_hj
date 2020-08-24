      integer max_cache_EWREALs
	  parameter (max_cache_EWREALs=1000)
      double precision tol_EWREALS
	  parameter (tol_EWREALS=1.0d-13)

	  integer curr_cache_size
	  double precision key_Pewreals(max_cache_EWREALs,0:3,3)
	  double precision key_MAewreals(max_cache_EWREALs)
	  double precision key_MBewreals(max_cache_EWREALs)

	  double precision value_ewrealsIm(max_cache_EWREALs,4)
	  double precision value_ewrealsRe(max_cache_EWREALs,4)
	  
      data curr_cache_size/0/
      common/GGHGEW/curr_cache_size,key_Pewreals,key_MAewreals,
     & key_MBewreals,value_ewrealsRe,value_ewrealsIm
