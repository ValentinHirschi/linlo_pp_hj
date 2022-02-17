#!/bin/bash
echo Which mode should we use?
read usemode

#wolframscript gghg_coefs.wls 4372281 -39754486/175 1      125   0     174.05466381079322610 1      1     2         $usemode  3         0            5     0           1           0            1           0            0           0                    res.dat
#wolframscript gghg_coefs.wls -39754486/175 4372281 1      125   0     174.05466381079322610 1      1     2         $usemode  3         0           5     0           1           0            1           0            0           0                    res.dat
#wolframscript gghg_coefs.wls -39754486/175 4372281 1      -725372814/175   0     174.05466381079322610 1      1     2         $usemode  3         0           5     0           1           0            1           0            0           0                    res.dat

wolframscript gghg_coefs.wls   -1 4372281 -39754486/175 1      126   0     173 0      1     2         $usemode  3         0            5     0           1           0            1           0            0           0                    res.dat
wolframscript gghg_coefs.wls   -1 4372281 -39754486/175 1      126   4.2     173 1      1     2         $usemode  3         0            4     0           1           1            1           1            1           1                    res.dat
