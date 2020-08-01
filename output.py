import madgraph.iolibs.export_v4 as export_v4
import madgraph.iolibs.file_writers as writers
import logging
import os
import madgraph.core.helas_objects as helas_objects
from functools import wraps
import itertools

pjoin = os.path.join

_file_path = os.path.split(os.path.dirname(os.path.realpath(__file__)))[0] + '/higgsew/'
_iolibpath= os.path.normpath(pjoin(os.path.dirname(__file__), '../../madgraph/iolibs/'))+'/'
print dir(helas_objects.HelasMatrixElement)

logger = logging.getLogger('madgraph.export_v4')

default_compiler= {'fortran': 'gfortran',
                       'f2py': 'f2py',
                       'cpp':'g++'}

###############################################################################################
### ADD FUNCTIONALITY FOR LONGITUDINAL GLUON POLARIZATIONS TO madgraph.core.helas_objects
###############################################################################################
# obtains the helicity matrix including longitudinal polarizations
def get_helicity_matrix_longitudinal(self,allow_reverse=True):
    """Gives the helicity matrix for external wavefunctions"""

    if not self.get('processes'):
        return None

    process = self.get('processes')[0]
    model = process.get('model')
    hel_per_part = []
    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') != 21: 
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

    model = self.get('processes')[0].get('model')
    hel_per_part = []
    for wf in self.get_external_wavefunctions():
        if wf.get('pdg_code') != 21: 
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
            return 0

        if writer:
            if not isinstance(writer, writers.FortranWriter):
                raise writers.FortranWriter.FortranWriterError(
                    "writer not FortranWriter but %s" % type(writer))
            # Set lowercase/uppercase Fortran code
            writers.FortranWriter.downcase = False

        if not self.opt.has_key('sa_symmetry'):
            self.opt['sa_symmetry'] = False

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
    
    def do_fix_lib_directory(self, lib_dir):
        """ Performs the following changes in the lib directory directory:
            -> Add soft links to the static or dynamic libraries of
               GGVVamp and its dependencies
        """

        logger.info("Post-processing of the lib directory in '%s'"%lib_dir)

        # First clean up duties
        lib_names = ['gmp','cln','ginac','ggvvamp']
        for lib_name in lib_names:
            lib_exts = ['a','so','dylib']
            for lib_ext in lib_exts:
                if os.path.exists(pjoin(lib_dir,'lib%s.%s'%(lib_name,lib_ext))):
                    os.remove(pjoin(lib_dir,'lib%s.%s'%(lib_name,lib_ext)))

        lib_extension = '.a'
        if self._linking_mode == 'dynamic':
            lib_extension = self._dylib_ext


        # def ln(file_pos, starting_dir='.', name='', log=True, cwd=None, abspath=False):
        ln(pjoin(self._gmp_prefix,'lib','libgmp.%s'%lib_extension),
           starting_dir = lib_dir,
           abspath = True)
        ln(pjoin(self._cln_prefix,'lib','libcln.%s'%lib_extension),
           starting_dir = lib_dir,
           abspath = True)
        ln(pjoin(self._ginac_prefix,'lib','libginac.%s'%lib_extension),
           starting_dir = lib_dir,
           abspath = True)
        # For ggvvamp, the dynamic library extension is always so
        ln(pjoin(self._ggvv_prefix,'libggvvamp.%s'%('so' if self._linking_mode == 'dynamic' else 'a')),
           name = 'libggvvamp.%s'%lib_extension,
           starting_dir = lib_dir,
           abspath = True)
