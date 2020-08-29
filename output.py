import madgraph.iolibs.export_v4 as export_v4
import madgraph.iolibs.file_writers as writers
import logging
import os as os
import madgraph.core.helas_objects as helas_objects
from functools import wraps
import itertools
import json as json
import copy
import shutil
import madgraph.various.misc as misc
from madgraph.iolibs.files import cp, ln, mv
import madgraph.iolibs.files as files
from madgraph import MadGraph5Error, InvalidCmd, MG5DIR



pjoin = os.path.join

_file_path = os.path.split(os.path.dirname(os.path.realpath(__file__)))[0] + '/higgsew/'
_iolibpath= os.path.normpath(pjoin(os.path.dirname(__file__), '../../madgraph/iolibs/'))+'/'
_plugin_path = os.path.split(os.path.dirname(os.path.realpath(__file__)))[0] + '/higgsew'
_tmp_dir = 'Templates'

logger = logging.getLogger('madgraph.export_v4')

default_compiler= {'fortran': 'gfortran',
                       'f2py': 'f2py',
                       'cpp':'g++'}

###############################################################################################
### ADD FUNCTIONALITY FOR LONGITUDINAL GLUON POLARIZATIONS TO madgraph.core.helas_objects
###############################################################################################
# obtains the helicity matrix including longitudinal polarizations
def get_helicity_matrix_longitudinal(self,allow_reverse=True):
    """Gives the helicity matrix for external wavefunctions for the polarization sum g^{mu,nu}"""

    if not self.get('processes'):
        return None

    process = self.get('processes')[0]
    model = process.get('model')
    hel_per_part = []
    gluon_count = 0
    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') ==21:
            gluon_count +=1

    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') != 21 or gluon_count<3: 
            hel_per_part+= [model.get('particle_dict')[\
                                wf.get('pdg_code')].get_helicity_states(allow_reverse)]
        else:
            hel_per_part += [[-1,1,66,77]]
    # hel_per_part = [ wf.get('polarization') if wf.get('polarization') 
    #             else model.get('particle_dict')[\
    #                         wf.get('pdg_code')].get_helicity_states(allow_reverse)
    # for wf in self.get_external_wavefunctions()]

    return apply(itertools.product, hel_per_part)

# obtains the helicity matrix includin longitudinal polarizations
def get_helicity_combinations_longitudinal(self):
    """Gives the number of helicity combinations for external
    wavefunctions"""

    if not self.get('processes'):
        return None
    gluon_count=0
    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') ==21:
            gluon_count +=1

    model = self.get('processes')[0].get('model')
    hel_per_part = []
    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') != 21 or gluon_count<3: 
            hel_per_part+= [len(model.get('particle_dict')[\
                                wf.get('pdg_code')].get_helicity_states())]
        else:
            hel_per_part += [4]
    return reduce(lambda x, y: x * y,
                    hel_per_part)


    

# add longitudinal helicity matrix and combinations
setattr(helas_objects.HelasMatrixElement,'get_helicity_matrix_longitudinal',get_helicity_matrix_longitudinal)
setattr(helas_objects.HelasMatrixElement,'get_helicity_combinations_longitudinal',get_helicity_combinations_longitudinal)


###############################################################################################
### MODIFY EXPORTER TO ACCOUNT FOR POLARIZATION SUM -g^\mu\nu
###############################################################################################
class My_ggHg_Exporter(export_v4.ProcessExporterFortranSA):


    matrix_template = "Templates/matrix_standalone_v4_mod_hel_sum.inc"    
    
    # for muli-process defintion
    # load process definitions:
    def __init__(self, *args, **opts):
        with open(pjoin(_plugin_path,'process_information.json')) as json_file:
            self.available_processes = json.load(json_file)
        self.relevant_processes = {}
        self.fortran_routines = []
        self.tensor_strucs = []
        self.coupl_update =[]
        self.add_libraries = ['lstdc++']          
        super(My_ggHg_Exporter,self).__init__(*args, **opts)
        
    def copy_template(self, model):
        """Additional actions needed for setup of Template
        """

        #First copy the full template tree if dir_path doesn't exit
        if os.path.isdir(self.dir_path):
            return
        
        logger.info('initialize a new standalone directory: %s' % \
                        os.path.basename(self.dir_path))
        temp_dir = pjoin(self.mgme_dir, 'Template/LO')
        
        # Create the directory structure
        os.mkdir(self.dir_path)
        os.mkdir(pjoin(self.dir_path, 'Source'))
        os.mkdir(pjoin(self.dir_path, 'Source', 'MODEL'))
        os.mkdir(pjoin(self.dir_path, 'Source', 'DHELAS'))
        os.mkdir(pjoin(self.dir_path, 'SubProcesses'))
        os.mkdir(pjoin(self.dir_path, 'bin'))
        os.mkdir(pjoin(self.dir_path, 'bin', 'internal'))
        os.mkdir(pjoin(self.dir_path, 'lib'))
        os.mkdir(pjoin(self.dir_path, 'Cards'))
        
        # Information at top-level
        #Write version info
        shutil.copy(pjoin(temp_dir, 'TemplateVersion.txt'), self.dir_path)
        try:
            shutil.copy(pjoin(self.mgme_dir, 'MGMEVersion.txt'), self.dir_path)
        except IOError:
            MG5_version = misc.get_pkg_info()
            open(pjoin(self.dir_path, 'MGMEVersion.txt'), 'w').write( \
                "5." + MG5_version['version'])
        
        
        # Add file in SubProcesses
        shutil.copy(pjoin(self.mgme_dir, 'madgraph', 'iolibs', 'template_files', 'makefile_sa_f_sp'), 
                    pjoin(self.dir_path, 'SubProcesses', 'makefileP'))
        
        if self.format == 'standalone':
            shutil.copy(pjoin(self.mgme_dir, 'madgraph', 'iolibs', 'template_files', 'check_sa.f'), 
                    pjoin(self.dir_path, 'SubProcesses', 'check_sa.f'))
                        
        # Add file in Source
        shutil.copy(pjoin(temp_dir, 'Source', 'make_opts'), 
                    pjoin(self.dir_path, 'Source'))        
        # add the makefile 
        filename = pjoin(self.dir_path,'Source','makefile')
        self.write_source_makefile(writers.FileWriter(filename))    
    
    def create_lib(self,target_dir, repl_dict):
        """write the makefile to compile the relevant process in a standalone. Copy and link the .f and .a routines

        Args:
            target_dir (location): process location
            repl_dict (dictionary): replace routines my names having a unique prefix
        """
        with open(pjoin(_plugin_path,_tmp_dir, 'Makefile_TEMP' ), 'r') as file:
            makefile = file.read()
        # generate the makefile to compile the .cpp routines
        new_lib = 'libfortran_bridge.a'
        for key,value in repl_dict.items():
            makefile = makefile.replace(str(key),str(value).replace(".cpp",""))
            new_lib=new_lib.replace(str(key),str(value).replace(".cpp",""))
        self.add_libraries += [new_lib.replace('lib','l').replace('.a','')]

        export = open(pjoin(target_dir,'Makefile'),'w')
        export.write(makefile)
        export.close()

        # compile into a static library
        #misc.compile(arg=['clean'],cwd = target_dir)
        misc.compile(arg=[],cwd = target_dir)
        # Link to library into EXPORTDIR/libs/
        libtolink = pjoin(target_dir,new_lib)
        ln(file_pos=libtolink,starting_dir=pjoin(self.dir_path, 'lib') )
        # copy coupling redefintion into EXPORTDIR/Source/MODEL/
        cp(path1=pjoin(target_dir,repl_dict['fortran_evaluation']),path2=pjoin(self.dir_path, 'Source','MODEL'))
        # copy cache file
        cp(path1=pjoin(target_dir,repl_dict['fortran_cache']),path2=pjoin(self.dir_path, 'Source','MODEL'))       
        self.fortran_routines +=[repl_dict['fortran_evaluation'].replace('.f','.o')]


    def copy_and_compile_process_files(self,matrix_element):
        """create copies of the evaluation functions and compile
        """
        needed_procs ={}
        possible_procs = self.available_processes
        involved_couplings = matrix_element.get(
            'processes')[0].get('split_orders')
        print involved_couplings
        for proc in self.available_processes:
            write = True
            if set(possible_procs[proc]['associated_coupling'])<=set(involved_couplings):
                # we do that for the coupling splitting of the EW corrections
                for otherproc in self.available_processes:
                    if set(possible_procs[otherproc]['associated_coupling'])<=set(involved_couplings) and set(possible_procs[otherproc]['associated_coupling']) > set(possible_procs[proc]['associated_coupling']):
                        write = False
                       
                if write == True:        
                    prefix = str(proc)
                    needed_procs[prefix] = copy.deepcopy(possible_procs[proc])
                    #handle the fortran bridge
                    old_file = pjoin(_plugin_path,possible_procs[proc]['directory'],possible_procs[proc]['fortran_bridge'])
                    # make relativ path absolute, so that we dont have to copy the mathematica folders
                    file = open(old_file,'r') 
                    file_source = file.read()
                    file.close()
                    file_source = file_source.replace('PATHTOC',pjoin(_plugin_path,possible_procs[proc]['directory']))              
                    new_file = prefix+"_"+ possible_procs[proc]['fortran_bridge']
                    with open(pjoin(_plugin_path,possible_procs[proc]['directory'],new_file),'w') as file:
                        file.write(file_source)
                    needed_procs[prefix]['fortran_bridge'] = new_file
                    # handle the fortran evaluation
                    old_file = pjoin(_plugin_path,possible_procs[proc]['directory'],possible_procs[proc]['fortran_evaluation'])
                    new_file = prefix+"_"+ possible_procs[proc]['fortran_evaluation']
                    shutil.copyfile(old_file,pjoin(_plugin_path,possible_procs[proc]['directory'],new_file))
                    needed_procs[prefix]['fortran_evaluation'] = new_file
                    self.relevant_processes.update(copy.deepcopy(needed_procs))
                    self.create_lib(pjoin(_plugin_path, possible_procs[proc]['directory']),needed_procs[prefix])
                

    
    def get_helicity_lines(self, matrix_element,array_name='NHEL'):
        """Return the Helicity matrix definition lines for this matrix element"""

        helicity_line_list = []
        i = 0
        for helicities in matrix_element.get_helicity_matrix_longitudinal():
            i = i + 1
            int_list = [i, len(helicities)]
            int_list.extend(helicities)
            helicity_line_list.append(\
                ("DATA ("+array_name+"(I,%4r),I=1,%d) /" + \
                 ",".join(['%2r'] * len(helicities)) + "/") % tuple(int_list))

        return "\n".join(helicity_line_list)


    def write_matrix_element_v4(self, writer, matrix_element, fortran_model,
                                write=True, proc_prefix=''):
        """Export a matrix element to a matrix.f file in MG4 standalone format
            if write is on False, just return the replace_dict and not write anything."""


        if not matrix_element.get('processes') or \
                not matrix_element.get('diagrams'):
            return 
        if writer:
            if not isinstance(writer, writers.FortranWriter):
                raise writers.FortranWriter.FortranWriterError(
                    "writer not FortranWriter but %s" % type(writer))
            # Set lowercase/uppercase Fortran code
            writers.FortranWriter.downcase = False

        if not self.opt.has_key('sa_symmetry'):
            self.opt['sa_symmetry'] = False
        
        self.copy_and_compile_process_files(matrix_element)
        # The proc_id is for MadEvent grouping which is never used in SA.
        replace_dict = {'global_variable': '', 'amp2_lines': '',
                        'proc_prefix': proc_prefix, 'proc_id': ''}

        # Extract helas calls
        helas_calls = fortran_model.get_matrix_element_calls(
            matrix_element)

        replace_dict['helas_calls'] = "\n".join(helas_calls)

        # Extract version number and date from VERSION file
        info_lines = self.get_mg5_info_lines()
        replace_dict['info_lines'] = info_lines

        # Extract process info lines
        process_lines = self.get_process_info_lines(matrix_element)
        replace_dict['process_lines'] = process_lines

        # Extract number of external particles
        (nexternal, ninitial) = matrix_element.get_nexternal_ninitial()
        replace_dict['nexternal'] = nexternal
        replace_dict['nincoming'] = ninitial

        # Extract ncomb
        ncomb = matrix_element.get_helicity_combinations_longitudinal()
        replace_dict['ncomb'] = ncomb

        # Extract helicity lines
        helicity_lines = self.get_helicity_lines(matrix_element)
        replace_dict['helicity_lines'] = helicity_lines

        # Extract overall denominator
        # Averaging initial state color, spin, and identical FS particles
        replace_dict['den_factor_line'] = self.get_den_factor_line(
            matrix_element)

        # Extract ngraphs
        ngraphs = matrix_element.get_number_of_amplitudes()
        replace_dict['ngraphs'] = ngraphs

        # Extract nwavefuncs
        nwavefuncs = matrix_element.get_number_of_wavefunctions()
        replace_dict['nwavefuncs'] = nwavefuncs

        # Extract ncolor
        ncolor = max(1, len(matrix_element.get('color_basis')))
        replace_dict['ncolor'] = ncolor
        # We still average only over physical polarizations
        replace_dict['hel_avg_factor'] = matrix_element.get_hel_avg_factor()
        replace_dict['beamone_helavgfactor'], replace_dict['beamtwo_helavgfactor'] =\
            matrix_element.get_beams_hel_avg_factor()

        # Extract color data lines
        color_data_lines = self.get_color_data_lines(matrix_element)
        replace_dict['color_data_lines'] = "\n".join(color_data_lines)

        if self.opt['export_format'] == 'standalone_msP':
            # For MadSpin need to return the AMP2
            amp2_lines = self.get_amp2_lines(matrix_element, [])
            replace_dict['amp2_lines'] = '\n'.join(amp2_lines)
            replace_dict['global_variable'] = \
                "       Double Precision amp2(NGRAPHS)\n       common/to_amps/  amp2\n"

        # JAMP definition, depends on the number of independent split orders
        split_orders = matrix_element.get(
            'processes')[0].get('split_orders')

        if len(split_orders) == 0:
            replace_dict['nSplitOrders'] = ''
            # Extract JAMP lines
            jamp_lines = self.get_JAMP_lines(matrix_element)
            # Consider the output of a dummy order 'ALL_ORDERS' for which we
            # set all amplitude order to weight 1 and only one squared order
            # contribution which is of course ALL_ORDERS=2.
            squared_orders = [(2,), ]
            amp_orders = [((1,), tuple(range(1, ngraphs+1)))]
            replace_dict['chosen_so_configs'] = '.TRUE.'
            replace_dict['nSqAmpSplitOrders'] = 1
            replace_dict['split_order_str_list'] = ''
        else:
            squared_orders, amp_orders = matrix_element.get_split_orders_mapping()
            replace_dict['nAmpSplitOrders'] = len(amp_orders)
            replace_dict['nSqAmpSplitOrders'] = len(squared_orders)
            replace_dict['nSplitOrders'] = len(split_orders)
            replace_dict['split_order_str_list'] = str(split_orders)
            amp_so = self.get_split_orders_lines(
                [amp_order[0] for amp_order in amp_orders], 'AMPSPLITORDERS')
            sqamp_so = self.get_split_orders_lines(
                squared_orders, 'SQSPLITORDERS')
            replace_dict['ampsplitorders'] = '\n'.join(amp_so)
            replace_dict['sqsplitorders'] = '\n'.join(sqamp_so)
            jamp_lines = self.get_JAMP_lines_split_order(
                matrix_element, amp_orders, split_order_names=split_orders)

            # Now setup the array specifying what squared split order is chosen
            replace_dict['chosen_so_configs'] = self.set_chosen_SO_index(
                matrix_element.get('processes')[0], squared_orders)

            # For convenience we also write the driver check_sa_splitOrders.f
            # that explicitely writes out the contribution from each squared order.
            # The original driver still works and is compiled with 'make' while
            # the splitOrders one is compiled with 'make check_sa_born_splitOrders'
            check_sa_writer = writers.FortranWriter(
                'check_sa_born_splitOrders.f')
            self.write_check_sa_splitOrders(squared_orders, split_orders,
                                            nexternal, ninitial, proc_prefix, check_sa_writer)

        if write:
            writers.FortranWriter('nsqso_born.inc').writelines(
                """INTEGER NSQSO_BORN
                PARAMETER (NSQSO_BORN=%d)""" % replace_dict['nSqAmpSplitOrders'])

        replace_dict['jamp_lines'] = '\n'.join(jamp_lines)

        matrix_template = self.matrix_template
        if self.opt['export_format'] == 'standalone_msP':
            raise SystemExit(
                'Error: matrix_standalone_msP_v4.inc does not account for longitudinal polarizations.')
            matrix_template = 'matrix_standalone_msP_v4.inc'
        elif self.opt['export_format'] == 'standalone_msF':
            raise SystemExit(
                'Error: matrix_standalone_msP_v4.inc does not account for longitudinal polarizations.')
            matrix_template = 'matrix_standalone_msF_v4.inc'
        elif self.opt['export_format'] == 'matchbox':
            replace_dict["proc_prefix"] = 'MG5_%i_' % matrix_element.get('processes')[
                0].get('id')
            replace_dict["color_information"] = self.get_color_string_lines(
                matrix_element)

        if len(split_orders) > 0:
            if self.opt['export_format'] in ['standalone_msP', 'standalone_msF']:
                logger.debug("Warning: The export format %s is not " +
                             " available for individual ME evaluation of given coupl. orders." +
                             " Only the total ME will be computed.", self.opt['export_format'])
            elif self.opt['export_format'] in ['madloop_matchbox']:
                replace_dict["color_information"] = self.get_color_string_lines(
                    matrix_element)
                matrix_template = "matrix_standalone_splitOrders_v4_mod_hel_sum.inc"
            else:
                matrix_template = "matrix_standalone_splitOrders_v4_mod_hel_sum.inc"
        if not matrix_template=="matrix_standalone_splitOrders_v4_mod_hel_sum.inc":
            raise SystemExit(
                'Error: ' + matrix_element +' does not account for longitudinal polarizations.')

        replace_dict['template_file'] = pjoin(
            _file_path, 'Templates', matrix_template)
        replace_dict['template_file2'] = _iolibpath+'template_files/split_orders_helping_functions.inc'
        # pjoin(_file_path,
        #                                       'iolibs/template_files/split_orders_helping_functions.inc')
        if write and writer:
            path = replace_dict['template_file']
            content = open(path).read()
            content = content % replace_dict
            # Write the file
            writer.writelines(content)
            # Add the helper functions.
            if len(split_orders) > 0:
                content = '\n' + open(replace_dict['template_file2'])\
                    .read() % replace_dict
                writer.writelines(content)
            return len(filter(lambda call: call.find('#') != 0, helas_calls))
        else:
            replace_dict['return_value'] = len(
                filter(lambda call: call.find('#') != 0, helas_calls))
            return replace_dict  # for subclass update
    def finalize(self, matrix_elements, history, mg5options, flaglist):
        for ff in self.fortran_routines:
            with open(pjoin(self.dir_path, 'Source','MODEL','makeinc.inc'),'a') as file:
                file.write(' ' + ff)
        # I am not sure, but I think -lstdc++ should be a the end
        new_libs = ' '        
        for ff in reversed(self.add_libraries):
            new_libs += '-'+ff + ' '
        # change makefile in SUBPROCESSES
        with open(pjoin(self.dir_path, 'SubProcesses','makefileP'), 'r+') as f: #r+ does the work of rw
            lines = f.readlines()
            for i, line in enumerate(lines):
                if line.startswith('LINKLIBS'):
                    lines[i] = lines[i].strip() + new_libs + '\n'
            f.seek(0)
            for line in lines:
                f.write(line)
        # fix helas code for inclusion of coupling updates:
        _helas_dir = pjoin(self.dir_path, 'Source','DHELAS')
        _template_dir = pjoin(_plugin_path,'Templates')
        for proc in self.relevant_processes.values():
            if proc['gluon_number'] == 2:
                # with open(pjoin(_template_dir,'gg_coupling_update.f'),'r') as file:
                helas_def ='\n      double precision mH, muR'
                helas_string = '\n'#file.read()
            if proc['gluon_number'] == 3:
                with open(pjoin(_template_dir,'ggg_coupling_update.f'),'r') as file:
                    helas_def ='\n      double precision pg(0:3,3)'
                    helas_string = file.read()
            helas_string_update =''
            for coup_update in proc["coupling_update_function"]:
                if proc['gluon_number'] == 3:
                    helas_string_update +='      call SETCOEFFFUNC(pg)'.replace('SETCOEFFFUNC',coup_update)+'\n'
                if proc['gluon_number'] == 2:
                    helas_string_update +='      call SETCOEFFFUNC(mH,muR)'.replace('SETCOEFFFUNC',coup_update)+'\n'
            # now edit the tensor structures in the helas functions
            for tens in proc["tensor_structures"]:
                tensfile = pjoin(_helas_dir,tens+'_0.f')
                if os.path.exists(tensfile):
                    new_routine = []
                    appended1 = False
                    appended2 = False
                    appended3 = False
                    if 'pg(0:3,3)' in open(tensfile,'r').read() or 'muR' in open(tensfile,'r').read():
                        appended3=True

                    for line in open(tensfile,'r').read().split('\n'):
                        if line.strip().startswith('P1(0)') and appended1==False and appended3==False:
                            appended1 = True
                            new_routine.append(helas_def)
                        if line.strip().startswith('TMP') and appended2==False:
                            appended2 = True
                            if appended3==False:
                                new_routine.append(helas_string)
                            new_routine.append(helas_string_update)
                        new_routine.append(line)
                    open(tensfile,'w').write('\n'.join(new_routine))                            
                else:
                    err= 'Tensor structure '+tensfile+' not found!'
                    print MadGraph5Error(err)
        # compile helas DIR
        misc.compile(arg=[],cwd = _helas_dir)
        # FIX 2>1 kinematics
        with open(pjoin(_plugin_path,_tmp_dir,'fix_2_to_1_kinematics.f'),'r') as file:
            fix_check_sa = file.read()
        with open(pjoin(self.dir_path, 'SubProcesses','check_sa.f'),'r+') as file:
            lines = file.readlines()
            for i, line in enumerate(lines):
                if line.strip().startswith('CALL GET_MOMENTA(SQRTS,PMASS,P)'):
                    lines[i] = fix_check_sa + '\n'
            file.seek(0)
            for line in lines:
                file.write(line)



        super(My_ggHg_Exporter,self).finalize(matrix_elements, history, mg5options, flaglist)
           