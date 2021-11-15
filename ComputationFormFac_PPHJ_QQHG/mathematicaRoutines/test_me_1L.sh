#!/bin/bash
echo Which mode should we use?
read usemode
echo Which channel should we compute?
read usechannel

wolframscript qqhg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  $usechannel         0            5     0           1           0            1           0            0           0                    res.dat
wolframscript qqhg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  $usechannel         1           5     0           1           0            1           0            0           0                    res.dat
wolframscript qqhg_coefs.wls 4372281 -39754486/175 1      125   0     173.05466381079322610 1      1     1         $usemode  $usechannel         2           5     0           1           0            1           0            0           0                    res.dat
