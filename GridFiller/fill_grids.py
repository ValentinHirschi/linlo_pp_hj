#!/usr/bin/env python3
import multiprocessing
import subprocess
import argparse
import random
import time
import os
import sys
from pprint import pformat

def worker(worker_ID,job_queue,res_queue):
    time.sleep(1.0*random.random())
    #print("I am worker #%d"%worker_ID)
    job_ID, new_job = job_queue.get()
    while new_job != 'DONE':
        #print("Worker %d :: Got job: %s@%d"%(worker_ID, new_job, job_ID))
#        time.sleep(1.0*random.random())
        
#        job_result = "Job '%s@%d' done by worker %d."%(new_job,job_ID,worker_ID)
        res = subprocess.run(['./grid_filler %s'%new_job], shell=True, check=True, capture_output=True)
        ME_res = res.stdout.decode('utf-8')
        job_result = '%s %s'%(new_job, ME_res)

        # Fetch a new job
        res_queue.put(tuple([job_ID,job_result]))
        job_ID, new_job = job_queue.get()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=""" Calls grid filler in parallel to compute real-emission 2-loop MEs.""")
    requiredNamed = parser.add_argument_group('required named arguments')

    # Required options
    requiredNamed.add_argument('--grid_in', '-i', type=str,
                    help='Path of the grid to process', required=True)

    # Optional options
    parser.add_argument('--cores', '-c', default=multiprocessing.cpu_count(), type=int,
                    help='Number of CPUs to run on')
    parser.add_argument('--grid_out', '-o', type=str, default='./processed_grid.dat',
                    help='Path of the grid to output')
    parser.add_argument('--proc', '-p', type=str, default='./LI_at_NLO_proc',
                    help='Path of the standalone process to use to run the points.')

    args = parser.parse_args()
  
    if args.proc == './LI_at_NLO_proc':
        if not os.path.exists('./LI_at_NLO_proc'):
            print("ERROR: When specifying './LI_at_NLO_proc' as a process to run, you must manually place the soft link.")
            sys.exit(1)
    else:
        subprocess.call(['ln -s %s ./LI_at_NLO_proc'%args.proc], shell=True)

    subprocess.call(['make clean'], shell=True)
    subprocess.call(['make'], shell=True)

    manager = multiprocessing.Manager()
    job_queue = manager.Queue()
    res_queue = manager.Queue()

    res = subprocess.run(['cat %s | wc -l'%args.grid_in], shell=True, check=True, capture_output=True)
    n_entries = int(res.stdout.decode('utf-8'))-1

    input_grid = open(args.grid_in,'r')
    n_entries_read = int(input_grid.readline().strip())
    if n_entries_read!=n_entries:
        print("Error: grid file announces a total of %d entries but the file only lists %d points."%(n_entries_read,n_entries))
        sys.exit(1)

    print("About to process grid file with %d entries on %d cores:"%(n_entries,args.cores))
    with multiprocessing.Pool(args.cores) as pool:
        
        r = pool.starmap_async(worker, [(wid,job_queue,res_queue) for wid in range(args.cores)])


        max_jobs = n_entries
        n_job_placed = 0
        n_received = 0
        
        ordered_job_results = []

        next_job_to_add = 0
        job_results_to_add = {}

        output_grid = open(args.grid_out,'w')
        output_grid.write('%d\n'%n_entries)

        while n_received<max_jobs:

            while n_job_placed < min( (n_received+args.cores*2), max_jobs):
                #print("Placing new job #%d"%n_job_placed)
#                new_job = "Job #%d"%n_job_placed
                new_job = input_grid.readline().strip()

                job_queue.put((n_job_placed,new_job))
                n_job_placed +=1

            result_ID, new_result = res_queue.get()
            #print("Received new result #%d: %s"%(result_ID,new_result))
            n_received+=1
            job_results_to_add[result_ID] = new_result
            # Now place the result of all jobs we can place
            while next_job_to_add in job_results_to_add:
                #print("Added result #%d"%next_job_to_add)
#                ordered_job_results.append(job_results_to_add.pop(next_job_to_add))
                output_grid.write(job_results_to_add.pop(next_job_to_add)) 
                print("ME evaluation # %d / %d (%.2f%%)\r"%(
                    next_job_to_add+1, max_jobs, 100.0*float(next_job_to_add+1)/float(max_jobs)
                ), end="")
                next_job_to_add += 1

        print("All done, now terminating wokers!")
        for wid in range(args.cores):
            job_queue.put((-1,"DONE"))
        
#        print("Final results:\n%s"%str(ordered_job_results))
        r.wait()

        input_grid.close()
        output_grid.close()
