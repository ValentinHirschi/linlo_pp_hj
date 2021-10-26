#!/bin/bash
# Ask the user for their name
echo Which mode should we use?
read usemode
echo Which channel should we compute?
read usechannel

wolframscript qqhg_coefs.wls 24336 -5560.8307142857142857 3      125   0     173.05466381079322610 1      1     2         $usemode     $usechannel       0            5     0           1           0            1           0            0           0                    res.dat
