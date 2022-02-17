#!/bin/bash
echo Which mode should we use?
read usemode

wolframscript gghg_coefs.wls  -1 4372281 -39754486/175 1      126   4.2     173 1      1     1         $usemode  3         0            5     0           1           0            1           0            0           0                    res.dat

pause 0.1

wolframscript gghg_coefs.wls  -1  -39754486/175 4372281 1      126   4.2     173 1      1     1         $usemode  3         0            5     0           1           0            1           0            0           0                    res.dat
