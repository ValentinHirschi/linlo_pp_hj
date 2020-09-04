import os
import shutil
import timeit


input_grid = "to_process_fm_grid_15k_test.dat"
output_grid = "processed_fm_grid_15k_test.dat"
cores = 15




def create_fortan(out_grid):
    ff = open("grid_filler_princess_tmp.f",'r') 
    file_source = ff.read()
    ff.close()
    file_source = file_source%{"grid_file":out_grid}
    with open('grid_filler_princess.f','w') as outfile:
        outfile.write(file_source)
    os.system('make clean')
    os.system('make grid_filler_princess')

def grid_length(fname):
        with open(fname) as f:
                for i, l in enumerate(f):
                        pass
        return i


shutil.copyfile(input_grid,output_grid)            
create_fortan(output_grid)
ps_points = grid_length(output_grid)

cmd = "parallel -j " + str(cores) + " ./grid_filler_princess -- $(seq 1 "+str(ps_points)+")"
print("About to call:\n" + cmd)
start_time = timeit.timeit()
os.system(cmd)
end_time = timeit.timeit()
print("The grid with "+ str(ps_points)+" took "+ str(end_time -start_time) +"s")
print("The average eval time per core is"+ str((end_time -start_time)/ps_points/cores))
