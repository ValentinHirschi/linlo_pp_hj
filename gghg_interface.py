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

plugin_path = os.path.dirname(os.path.realpath( __file__ ))
import madgraph

from madgraph import MadGraph5Error, InvalidCmd, MG5DIR
import madgraph.interface.extended_cmd as cmd
import madgraph.interface.madgraph_interface as madgraph_interface
import madgraph.various.misc as misc
from madgraph.iolibs.files import cp, ln, mv
import madgraph.interface.master_interface as master_interface
import datetime

logger = logging.getLogger('GGHG.Interface')

pjoin = os.path.join
template_dir = pjoin(plugin_path, 'Templates')

class GGHGInterfaceError(MadGraph5Error):
    """ Error of the Exporter of the PY8MEs interface. """

class GGHGInvalidCmd(InvalidCmd):
    """ Invalid command issued to the PY8MEs interface. """

class GGHGInterface(master_interface.MasterCmd, cmd.CmdShell):

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
        self.exec_cmd('import model PLUGIN/higgsew/UFO_model_gggH', printcmd=False, precmd=True)
        logger.info("The LO-QCD process has the effective coupling GGGHQCD")
        logger.info("Run e.g.: ")
        logger.info("   generate g g > H g GGGHQCD^2==2")
        logger.info("   output standalone_ggHg EXPORTDIRNAME")
        logger.info("   launch -f")
        # preloop mother
        madgraph_interface.CmdExtended.preloop(self)
        self.prompt = 'GGHG >'
    


