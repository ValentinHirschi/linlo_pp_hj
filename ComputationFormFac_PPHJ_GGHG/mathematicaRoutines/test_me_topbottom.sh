#!/bin/bash
echo Which mode should we use?
read usemode

wolframscript gghg_coefs.wls 24336 -5560.8307142857142857 3      125   4.2     173.05466381079322610 1      1     1         $usemode     3      0            4     0           1           0            1           0            0           0                    res.dat

wolframscript gghg_coefs.wls 24336 -5560.8307142857142857 3      125   4.2     173.05466381079322610 1      1     2         $usemode     3      0            4     0           1           0            1           0            0           0                    res.dat
