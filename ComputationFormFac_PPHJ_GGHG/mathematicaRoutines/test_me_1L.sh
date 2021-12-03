#!/bin/bash
echo Which mode should we use?
read usemode

wolframscript gghg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  3         0            5     0           1           0            1           0            0           0                    res.dat
#wolframscript gghg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  3         1           5     0           1           0            1           0            0           0                    res.dat
#wolframscript gghg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  3         2           5     0           1           0            1           0            0           0                    res.dat
