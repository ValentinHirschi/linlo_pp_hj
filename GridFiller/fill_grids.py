#!/usr/bin/env python3
import multiprocessing
import subprocess
import argparse
import random
import time
import os
import sys
import time
from pprint import pformat

n_zombies = multiprocessing.Value('i',0)
n_computed = multiprocessing.Value('i',0)
has_interrupted = multiprocessing.Event()

root_path = os.path.dirname(os.path.realpath( __file__ ))

def worker(worker_ID,job_queue,res_queue):
    if worker_ID != 0:
        time.sleep(30.0+(random.random()*2+1.0)*worker_ID)
    #print("I am worker #%d"%worker_ID)
    job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')    
    job_log.write('Waiting for new job...\n')
    job_log.close()
    job_ID, new_job = job_queue.get()
    while new_job != 'DONE':
       
        # Test if it is a dummy job
        split_job = new_job.split()
        if len(split_job)>18:
            if split_job[18].strip().upper() != 'NAN':
                # Then this entry is filled already and we should immediately return
                res_queue.put(tuple([job_ID,new_job+'\n']))
                job_ID, new_job = job_queue.get()
                continue
            else:
                new_job = ' '.join(split_job[:18])
#        job_result = "Job '%s@%d' done by worker %d."%(new_job,job_ID,worker_ID)
#        job_cmd = './grid_filler %s 2>&1 | tee -a ./logs/worker_%d.log'%(new_job,job_ID)

#        res_queue.put(tuple([job_ID,new_job+' 1337.0\n']))
#        job_ID, new_job = job_queue.get()
#        continue

        if has_interrupted.is_set():
            job_result = '%s %s'%(new_job, 'NaN\n')
            res_queue.put(tuple([job_ID,job_result]))
            job_ID, new_job = job_queue.get()
            continue

        attempt_number = 0
        MAX_ATTEMPTS = 3
        BASE_TIME = 700.0 # in seconds
        TIME_INCREMENT = 100.0 # in seconds
        SUCCESSFUL = False
        while (not SUCCESSFUL) and (attempt_number < MAX_ATTEMPTS):
            job_cmd = './grid_filler %s 2>&1 | tee -a ./logs/worker_%d.log > ./logs/worker_%d_current_res_attempt_%d.log'%(
                                                            new_job,worker_ID,worker_ID,attempt_number)

            job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
            if attempt_number == 0:
                job_log.write('Received job #%d:\n%s\n'%(job_ID,job_cmd))
            else:
                job_log.write('Rerunning job #%d (attempt #%d):\n%s\n'%(job_ID,attempt_number+1,job_cmd))
            job_log.close()


            #print("Now running : %s"%job_cmd) 
            job_start = time.time()
            #process = subprocess.Popen(job_cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            try:
                #process = subprocess.call(job_cmd, shell=True)
                proc = subprocess.run(job_cmd, shell=True, timeout=(BASE_TIME+TIME_INCREMENT*attempt_number))
            except subprocess.TimeoutExpired as e:
                attempt_number += 1
                n_zombies.value += 1
                job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
                job_log.write('Attempt #%d of job #%d timed out after %.1f s.\n'%(attempt_number,job_ID, time.time()-job_start))
                job_log.close()
                continue
            #print("Worker %d done with job #%d!"%(worker_ID,job_ID))
            SUCCESSFUL = True
        
        if not SUCCESSFUL:
            print('ERROR: Job #%d failed on worker #%d after %d attempts. Ignoring that point. Job was:\n%s\n'%(job_ID, worker_ID, attempt_number,new_job))
            job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
            job_log.write('Job #%d failed after %d attempts. Ignoring that point. Job was:\n%s\n'%(job_ID, attempt_number,new_job))
            job_log.close()
            job_result = '%s %s'%(new_job, 'NaN\n')
            res_queue.put(tuple([job_ID,job_result]))
            job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')        
            job_log.write('Waiting for new job...\n')
            job_log.close()
            job_ID, new_job = job_queue.get()
            continue

        if not os.path.isfile('./logs/worker_%d_current_res_attempt_%d.log'%(worker_ID,attempt_number)):
            print("ERROR: Could not find result of the job in: './logs/worker_%d_current_res_attempt_%d.log'"%(worker_ID,attempt_number))
            sys.exit(1)            
        
        job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
        job_log.write('Job #%d done in %.1f s.\n'%(job_ID, time.time()-job_start))
        job_log.close()

        stdout = open('./logs/worker_%d_current_res_attempt_%d.log'%(worker_ID,attempt_number),'r').read()
        stderr = "N/A"
#        stdout, stderr = process.communicate()
#        stdout = stdout.decode('utf-8')
#        stderr = stderr.decode('utf-8')
 
        ME_res = None
        take_next = False
        for line in stdout.split('\n'):
            if line.strip()=='BEGIN MG RESULT':
                take_next = True
            elif take_next:
                ME_res = line.strip()+'\n'
                break
        if ME_res is None:
            print("ERROR: could not get ME res for job #%d: %s.\nstdout:\n%s\nstderr:\n%s"%(
                 job_ID, job_cmd, stdout, stderr))
            job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
            job_log.write('Failed to get result for job #%d.'%job_ID)
            job_log.close()            
            job_result = '%s %s'%(new_job, 'NaN\n')
            res_queue.put(tuple([job_ID,job_result]))
            job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')        
            job_log.write('Waiting for new job...\n')
            job_log.close()
            job_ID, new_job = job_queue.get()
            continue
        #print("ME_res=",ME_res)

        job_result = '%s %s'%(new_job, ME_res)

        job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')
        job_log.write('Result for job #%d:\n%s\n'%(job_ID,job_result))
        job_log.close()

        # Fetch a new job
        n_computed.value += 1
        res_queue.put(tuple([job_ID,job_result]))
        job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')        
        job_log.write('Waiting for new job...\n')
        job_log.close()
        job_ID, new_job = job_queue.get()

    job_log = open('./logs/worker_%d_jobs.log'%worker_ID,'a')    
    job_log.write('DONE!\n')
    job_log.close()

def fifo_worker(wolfram_script_exe_path, fifo_path):
    while True:
        time.sleep(random.random())
        # Reboot listener every 30 min in case they got stuck
        subprocess.run('%s %s'%(wolfram_script_exe_path, fifo_path), shell=True, 
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=1800.0)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=""" Calls grid filler in parallel to compute real-emission 2-loop MEs.""")
    requiredNamed = parser.add_argument_group('required named arguments')

    # Required options
    requiredNamed.add_argument('--grid_in', '-i', type=str,
                    help='Path of the grid to process', required=True)

    # Optional options
    parser.add_argument('--cores', '-c', default=multiprocessing.cpu_count(), type=int,
                    help='Number of CPUs to run on')
    parser.add_argument('--fifo', '-f', default=0, type=int,
                    help='Number of mathematica fifo listeners to initiate. If negative, then it is set equal to number of cores.')
    parser.add_argument('--grid_out', '-o', type=str, default='./processed_grid.dat',
                    help='Path of the grid to output')
    parser.add_argument('--proc', '-p', type=str, default='./LI_at_NLO_proc',
                    help='Path of the standalone process to use to run the points.')

    args = parser.parse_args()
 
    if os.path.exists(args.grid_out):
        print("Error: target output grid path '%s' already exists. Remove it before running this script."%args.grid_out)
        sys.exit(1)
    
    if args.proc == './LI_at_NLO_proc':
        if not os.path.exists('./LI_at_NLO_proc'):
            print("ERROR: When specifying './LI_at_NLO_proc' as a process to run, you must manually place the soft link.")
            sys.exit(1)
    else:
        if os.path.exists('./LI_at_NLO_proc'):
            os.remove('./LI_at_NLO_proc')
        subprocess.call(['ln -s %s ./LI_at_NLO_proc'%args.proc], shell=True)
    
    subprocess.call(['rm -f stop ./logs/worker_*.log'], shell=True)
    
    subprocess.call(['make clean'], shell=True)
    subprocess.call(['make'], shell=True)
    
    if args.fifo < 0:
        # Add five extra listener for safety to make sure the fifo pipe is always listened to
        args.fifo = args.cores+5
    
    fifo_pool = None
    if args.fifo > 0:
        # Start fifo listeners
        fifo_exe_path = os.path.abspath(os.path.join(root_path,os.path.pardir,
                            'ComputationFormFacGGHGEW','mathematicaRoutines','expew_fifo.wls'))
        fifo_path = os.path.abspath(os.path.join(root_path,os.path.pardir,
                            'ComputationFormFacGGHGEW','mathematicaRoutines','mathematica_input.fifo'))
        if not os.path.isfile(fifo_exe_path):
            print("ERROR: Could not find the wolframscript listener file at:\n%s"%fifo_exe_path)
            sys.exit(1)
        if not os.path.exists(fifo_path):
            print("ERROR: Could not find the input fifo pipe. Create it at:\n%s"%fifo_path)
            sys.exit(1)
        print("Starting %d concurrent fifo mathematica listeners."%args.fifo)
        fifo_pool = multiprocessing.Pool(args.fifo)
        fifo_pool.starmap_async(fifo_worker, [(fifo_exe_path, fifo_path) for wid in range(args.fifo)])     
        print("Waiting 10 seconds for the mathematica listener to properly load.")
        time.sleep(10.0)

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
        
        start_time = time.time()
        issued_completion_printout = False

        has_interrupted_already = False

        while n_received<max_jobs:

            if (not issued_completion_printout) and (n_job_placed == min( (n_received+args.cores*2), max_jobs)):
                issued_completion_printout = True
                print("All jobs have now been sent!")
            while n_job_placed < min( (n_received+args.cores*2), max_jobs):
                new_job = input_grid.readline().strip()
                #print("Placing new job #%d :\n%s"%(n_job_placed,new_job))

                job_queue.put((n_job_placed,new_job))
                n_job_placed +=1

            # Test if we must abort
            if not has_interrupted.is_set() and os.path.exists(os.path.join(root_path,'stop')):
                print("WARNING: Order received of cleanly stopping all jobs.")
                has_interrupted.set()

            result_ID, new_result = res_queue.get()

            #print("Received new result #%d: %s"%(result_ID,new_result))
            n_received+=1
            job_results_to_add[result_ID] = new_result
            # Now place the result of all jobs we can place
            while next_job_to_add in job_results_to_add:
                #print("Added result #%d"%next_job_to_add)
    #                ordered_job_results.append(job_results_to_add.pop(next_job_to_add))
                output_grid.write(job_results_to_add.pop(next_job_to_add)) 
                next_job_to_add += 1

            print("ME evaluation # %d / %d (%.2f%%) (%d computed,  %.2f pts/min) (n written out so far: %d) (n zombies: %s)\r"%(
                n_received, max_jobs, 100.0*float(n_received)/float(max_jobs),
                n_computed.value,
                (float(n_computed.value)/(time.time()-start_time))*60.0,next_job_to_add,
                n_zombies.value
            ), end="")


        print("All done, now terminating wokers!")
        for wid in range(args.cores):
            job_queue.put((-1,"DONE"))
        
#        print("Final results:\n%s"%str(ordered_job_results))
        r.wait()

        input_grid.close()
        output_grid.close()
