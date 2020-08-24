      integer max_cache_ggH_heft
	  parameter (max_cache_ggH_heft=100)
      double precision cache_tol_ggH_heft
	  parameter (cache_tol_ggH_heft=1.0d-13)

	  integer curr_cache_size
	  double precision key_MA_GGH(max_cache_ggH_heft)
	  double precision key_MB_GGH(max_cache_ggH_heft)
	  double precision key_NLOOPS(max_cache_ggH_heft)
	  double precision key_EPS(max_cache_ggH_heft)
	  double precision value_HEFTLO(max_cache_ggH_heft)
	  double precision value_HEFTNLORe(max_cache_ggH_heft,3)
	  double precision value_HEFTNLOIm(max_cache_ggH_heft,3)


      data curr_cache_size/0/
      common/GGHHEFT/curr_cache_size,key_MA_GGH,key_MB_GGH,
     & key_NLOOPS,key_EPS,value_HEFTLO,value_HEFTNLORe,value_HEFTNLOIm
