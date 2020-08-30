#####################################################
#                                                   #
#  Source file of the ggHg MG5aMC plugin.           #
#  Use only with consent of its author.             #
#                                                   #
#                                                   #
#  shamelessly copied from Valentin Hirschi         #
#                                                   #
#####################################################

import os
import logging
import itertools
import sys
import shutil
import re
import json
import madgraph

from madgraph import MadGraph5Error, InvalidCmd, MG5DIR
import madgraph.interface.extended_cmd as cmd
import madgraph.interface.madgraph_interface as madgraph_interface
import madgraph.various.misc as misc
from madgraph.iolibs.files import cp, ln, mv
import madgraph.interface.master_interface as master_interface
import datetime

logger = logging.getLogger('GGHG.Interface')
_plugin_path = os.path.dirname(os.path.realpath( __file__ ))
pjoin = os.path.join
template_dir = pjoin(_plugin_path, 'Templates')


class GGHGInterfaceError(MadGraph5Error):
    """ Error of the Exporter of the PY8MEs interface. """

class GGHGInvalidCmd(InvalidCmd):
    """ Invalid command issued to the PY8MEs interface. """

class GGHGInterface(master_interface.MasterCmd, cmd.CmdShell):
    def __init__(self, *args, **opts):
        with open(pjoin(_plugin_path,'process_information.json')) as json_file:
            self.available_processes = json.load(json_file)
            self.prompt = 'GGHG >'
        super(GGHGInterface,self).__init__(*args, **opts)

    def check_file_integrity(self, *args, **opts):
        """ Validate if files defined in process_information exist."""
        procs = self.available_processes
        for proc in list(procs):
            print "Validate file integrity for "+ str(proc)
            for (key,value) in (procs[proc]).items():               
                if key=="fortran_bridge" or key=="fortran_evaluation":
                    if os.path.exists(pjoin(_plugin_path,procs[proc]['directory'],value)):
                        logger.info(value + " exists")
                    else:
                        err =pjoin(_plugin_path,procs[proc]['directory'],value) + " does not exist. \n Verify entries in " + pjoin(_plugin_path,'process_information.json')
                        raise MadGraph5Error(err) 


    def validate_model(self, *args, **opts):
        """ Wrap validate model so that it doesn't create problems when an interface of type
        LoopInterface is loaded first as a plugin since in this case no model is assigned yet."""
        if self._curr_model is None:
            self.do_import('loop_sm')
        super(GGHGInterface, self).validate_model(*args, **opts)

    def do_validate_default(self,*args, **opts):
        EXPORTDIRNAME = 'validate_gggh_QCD_LO'+(str(datetime.datetime.now())).replace(" ","")
        logger.info('validate default card for GGHGQCD^2==2')
        self.exec_cmd('generate g g > H g GGGHQCD^2==2')
        self.exec_cmd('output standalone_ggHg ' + EXPORTDIRNAME )
        self.exec_cmd('launch -f')
        logger.info('The default should be: 1.1654775807795E-003')

    def do_individualizes_distribution_prefixes(self, line):
        """ Adds a unique prefix to all common block and subroutine names that are not already prefixed by a unique name."""
    
        args = line.split()
        restore = False
        if '--restore' in args:
            restore = True
            args.remove('--restore')
        verbose = False 
        if '--verbose' in args:
            verbose = True
            args.remove('--verbose')

        root_path = args[0]
        prefix = None
        for arg in args[1:]:
            try:
                key, value = arg.split('=')
            except ValueError:
                key = arg
                value = None
            if key.startswith('--'):
                key = key[2:]
            if key == 'prefix':
                prefix = value
            else:
                raise GGHGInvalidCmd("Cannot recognize option '%s' for command '%s'."%(
                    key, 'individualizes_distribution_prefixes'))
        if prefix is None:
            raise GGHGInvalidCmd("Command 'individualizes_distribution_prefixes' requires the option --prefix=<chosen_prefix> to be specified.")

        logger.info("Making all common blocks and subroutine names unique in '%s' with prefix '%s'."%(root_path, prefix))
    

        def get_source_files():
            files_list = []
            targets = []
            targets += misc.glob(pjoin(root_path,'Source','DHELAS','*.f'))
            targets += misc.glob(pjoin(root_path,'Source','DHELAS','*.inc'))
            targets += misc.glob(pjoin(root_path,'Source','MODEL','*.f'))
            targets += misc.glob(pjoin(root_path,'Source','MODEL','*.inc'))
            targets += misc.glob(pjoin(root_path,'SubProcesses','*.f'))
            targets += misc.glob(pjoin(root_path,'SubProcesses','*.inc'))
            targets += misc.glob(pjoin(root_path,'SubProcesses','P*','*.f'))
            targets += misc.glob(pjoin(root_path,'SubProcesses','P*','*.inc'))
            for afile in targets:
                if os.path.islink(afile) or '__BackUp' in os.path.basename(afile):
                    continue
                BackUp_path = pjoin(os.path.dirname(afile),'%s__BackUp'%os.path.basename(afile))
                if not os.path.isfile(BackUp_path):
                    shutil.copy(afile,BackUp_path)
                files_list.append((afile,BackUp_path))
            return files_list

        target_files = get_source_files()

        if restore:
            for targetFile, sourceFile in target_files:
                shutil.copy(sourceFile,targetFile)
                os.remove(sourceFile)
            return

        # Subs and common block with prefix to ignore
        veto_prefixed = re.compile(r"^(MP_)?ML5_\d*_.*")
        
        # First scan subroutines and common blocks
        identified_subroutines = []
        sub_identifier_re = re.compile(r"^(?P<routine_before>\s*subroutine\s+)(?P<routine_name>\w+)\((?P<rest_of_line>.*)",re.IGNORECASE)
        sub_suspicious_re = re.compile(r"^(?P<routine_before>\s*subroutine\s+).*",re.IGNORECASE)
        common_identifier_re = re.compile(r"^(?P<common_before>\s*common\s*/\s*)(?P<common_name>\w+)\s*/(?P<rest_of_line>.*)",re.IGNORECASE)
        common_suspicious_re = re.compile(r"^(?P<common_before>\s*common\s*/\s*).*",re.IGNORECASE)
        for targetFile, sourceFile in target_files:
            new_lines = []
            for line in open(sourceFile,'r').readlines():
                sub_identifier = re.match(sub_identifier_re,line)
                common_identifier = re.match(common_identifier_re,line)        
                if not sub_identifier is None:
                    # Make sure it was not already prefixed with ML5_
                    sub_name = sub_identifier.group('routine_name')
                    if not re.match(veto_prefixed,sub_name) is None:
                        new_lines.append(line)
                        continue
                    identified_subroutines.append(sub_name.lower())
                    new_lines.append('%s%s%s(%s\n'%(sub_identifier.group('routine_before'),
                                             prefix,
                                             sub_name,
                                             sub_identifier.group('rest_of_line')))
                elif not common_identifier is None:
                    # Make sure it was not already prefixed with ML5_
                    common_name = common_identifier.group('common_name')
                    if not re.match(veto_prefixed,common_name) is None:
                        new_lines.append(line)
                        continue
                    # Renaming those in check_sa is problematic.
                    # It doesn't matter anyway since they aren't exported symbols in any library
                    # Also prevent the prefix of the common block for the initialization of the one-loop reduction
                    # dependencies which should only be initialized once across all MadLoop libraries.
                    if common_name in ['RASET1','RASET2', 'REDUCTIONCODEINIT']:
                        new_lines.append(line)
                        continue
                    new_lines.append('%s%s%s/%s\n'%(common_identifier.group('common_before'),
                                             prefix,
                                             common_name,
                                             common_identifier.group('rest_of_line')))
                else:
                    if re.match(sub_suspicious_re,line) or re.match(common_suspicious_re,line):
                        if verbose: logger.warning("Warning: Suspicious subroutine/common definition without delimiter! Probably a line break.")
                        if verbose: logger.warning("Found in file '%s', line is:\n%s"%(targetFile,line))
                    new_lines.append(line)
            open(targetFile,'w').writelines(new_lines)
        
        # Now we can also substitute the corresponding matching 'CALL'
        call_identifier_re = re.compile(r"^(?P<call_before>\s*\d*\s*call\s+)(?P<routine_name>\w+)\((?P<rest_of_line>.*)",re.IGNORECASE)
        call_suspicious_re = re.compile(r"^(?P<call_before>\s*\d*\s*call\s+).*",re.IGNORECASE)
        endSub_identifier_re = re.compile(r"^(?P<endSub_before>\s*end\s+subroutine\s+)(?P<routine_name>\w+)",re.IGNORECASE)
        
        for targetFile, sourceFile in target_files:
            new_lines = []
            for line in open(targetFile,'r').readlines():
                call_identifier = re.match(call_identifier_re,line)
                endSub_identifier = re.match(endSub_identifier_re,line)
                
                if not call_identifier is None:
                    # Make sure it was not already prefixed with ML5_
                    routine_name = call_identifier.group('routine_name')
                    if not re.match(veto_prefixed,routine_name) is None:
                        new_lines.append(line)
                        continue
                    if routine_name.lower() not in identified_subroutines:
                        if verbose: logger.warning("Skipping subroutine call to '%s' since apparently not taken from here."%routine_name)
                        new_lines.append(line)
                        continue
                    new_lines.append('%s%s%s(%s\n'%(call_identifier.group('call_before'),
                                             prefix,
                                             routine_name,
                                             call_identifier.group('rest_of_line')))
                elif not endSub_identifier is None:
                    # Make sure it was not already prefixed with ML5_
                    routine_name = endSub_identifier.group('routine_name')
                    if not re.match(veto_prefixed,routine_name) is None:
                        new_lines.append(line)
                        continue
                    if routine_name.lower() not in identified_subroutines:
                        if verbose: logger.warning("Skipping subroutine call to '%s' since apparently not taken from here."%routine_name)
                        new_lines.append(line)
                        continue
                    new_lines.append('%s%s%s\n'%(endSub_identifier.group('endSub_before'),
                                             prefix,
                                             routine_name))
                else:
                    if re.match(call_suspicious_re,line):
                        if verbose: logger.warning("Warning: Suspicious subroutine call without delimiter! Probably a line break.")
                        if verbose: logger.warning("Found in file '%s', line is:\n%s"%(targetFile,line))
                    new_lines.append(line)
            open(targetFile,'w').writelines(new_lines)

        # And now recompile the MODEL, DHELAS and the SubProcesses
        logger.info('Recompiling MODEL...')
        misc.compile(arg=[],cwd=pjoin(root_path,'Source','MODEL'))
        logger.info('Recompiling DHELAS...')        
        misc.compile(arg=[],cwd=pjoin(root_path,'Source','DHELAS'))
        all_subproc_dirs = []
        for subproc in misc.glob(pjoin(root_path,'SubProcesses','P*')):
            if os.path.isdir(subproc) and os.path.isfile(pjoin(subproc,'loop_matrix.f')):
                all_subproc_dirs.append(subproc)
        for subproc in all_subproc_dirs:
            logger.info("Recompiling SubProcess '%s' ..."%subproc)
            misc.compile(arg=['check'],cwd=subproc)

        # Finally recompile the global library
        logger.info('Recompiling the global library...')
        misc.compile(arg=['LIBNAME=%s'%os.path.basename(root_path)],cwd=pjoin(root_path,'lib'))

    def preloop(self, *args, **opts):
        """only change the prompt after calling  the mother preloop command"""

        # The colored prompt screws up the terminal for some reason.
        if madgraph.ReadWrite: # prevent on read-only disk
            self.do_install('update --mode=mg5_start')

        # By default, load the UFO Standard Model

        
        logger.info("Loading default model for GGHG: PLUGIN/higgsew/UFO_model_gggH")
        self.check_file_integrity()
        self.exec_cmd('import model ' + pjoin(_plugin_path,'UFO_model_gggH'), printcmd=False, precmd=True)
        logger.info("PLUGIN INFORMATION:")
        logger.info("----------------------------------")
        logger.info("----------------------------------")
        logger.info("Massive QCD-Background:")
        logger.info("----------------------------------")
        logger.info("To get the massive g g > H g run: ")
        logger.info("   generate g g > H g  GGGHQCD^2==2")
        logger.info("----------------------------------")
        logger.info("----------------------------------")
        logger.info("HEFT QCD-Background:")
        logger.info("----------------------------------")
        logger.info("For LO: ")
        logger.info("   generate g g > H    GGHEFT^2==2  QCD^2==4")
        logger.info("   generate g g > H g  GGGHEFT^2==2 ")
        logger.info("For NLO-virtuals: ")
        logger.info("   generate g g > H g  GGHEFT^2==2  QCD^2==6")
        logger.info("To adjust eps-order change parameter: eps_order_HEFT ")
        logger.info("----------------------------------")
        logger.info("----------------------------------")
        logger.info("Massive Mixed EW:")
        logger.info("----------------------------------")
        logger.info("For LO: ")
        logger.info("   generate g g > H    GGHEFT^2==1  GGHEW^2==1   QCD^2==4")
        logger.info("   generate g g > H g  GGGHEFT^2==1 GGGHEW^2==1  QCD^2==6")
        logger.info("For NLO-virtuals: ")
        logger.info("   generate g g > H    GGHEFT^2==1  GGHEW^2==1   QCD^2==6")
        logger.info("Customization Options: ")
        logger.info("WW^2==1 (ZZ^2==1): Contributions from WW(ZZ)-exchange only")
        logger.info("Param. n_loops_EW=99,2,3: 2- and 3-loop, 2-loop only, 3-loop only")
        logger.info("----------------------------------")
        logger.info("----------------------------------")
        logger.info("OUTPUT")
        logger.info("----------------------------------")
        logger.info("use: output standalone_ggHg OUTPUTDIR")
        self.prompt ="GGHG >"
        # preloop mother
        madgraph_interface.CmdExtended.preloop(self)
        




