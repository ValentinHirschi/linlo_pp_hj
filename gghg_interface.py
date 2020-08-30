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
        logger.info("   generate g g > H    GGHEFT^2==2  QCD^2==6")
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
        




