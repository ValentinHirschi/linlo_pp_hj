echo Which mode should we use?
read usemode
echo Which channel should we compute?
read usechannel
      
echo "24336 -5560.8307142857142857 3      125   0     173.05466381079322610 1      1     2         $usemode   $usechannel          0            5     0           1           0            1           0            0           0           /home/martijn/MG5_aMC_v2_7_3/PLUGIN/linlo/ComputationFormFac_PPHJ_GGHG/mathematicaRoutines/38a2a450-9e24-4cd1-a1c1-5fdc6e09fa07_tmp.fifo" > mathematica_input.fifo
