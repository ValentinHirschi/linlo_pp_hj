import utils as utils
import gghg_interface as interface
import madgraph.various.misc as misc

import aloha.create_aloha as create_aloha
create_aloha.AbstractALOHAModel.IS_PATCHED = False

original_compute_subset = create_aloha.AbstractALOHAModel.compute_subset
def force_aloha_to_loop_mode(restore=False):
    import aloha.create_aloha as create_aloha
    if restore:
        interface.logger.info("%sPatch of 'create_aloha.AbstractALOHAModel.compute_subset' reverted.%s"%(utils.bcolors.GREEN, utils.bcolors.ENDC))
        create_aloha.AbstractALOHAModel.compute_subset = original_compute_subset
        create_aloha.AbstractALOHAModel.IS_PATCHED = False
        return
    create_aloha.AbstractALOHAModel.IS_PATCHED = True
    interface.logger.warning("%salphaLoop temporarily dynamically patched 'create_aloha.AbstractALOHAModel.compute_subset' so as to force it to use the loop mode in all cases.%s"%(
    utils.bcolors.RED, utils.bcolors.ENDC))
    # Force aloha to store momenta in the first four and not two components of HELAS wavefunctions
    # For this we must force aloha.loop_mode to be set to True even in the absence of loops
    import aloha
    import aloha.create_aloha as create_aloha
    from aloha.create_aloha import AbstractRoutineBuilder, CombineRoutineBuilder
    import logging
    import time
    import operator
    logger = logging.getLogger('PATCHED_ALOHA')

    def patched_compute_subset(self, data):
        """ create the requested ALOHA routine. 
        data should be a list of tuple (lorentz, tag, outgoing)
        tag should be the list of special tag (like conjugation on pair)
        to apply on the object """

        # Search identical particles in the vertices in order to avoid
        #to compute identical contribution
        self.look_for_symmetries()
        # reorganize the data (in order to use optimization for a given lorentz
        #structure
        # MODIF BELOW:
        #aloha.loop_mode = False 
        aloha.loop_mode = True
        # self.explicit_combine = False
        request = {}

        for list_l_name, tag, outgoing in data:
            #allow tag to have integer for retro-compatibility
            all_tag = tag[:]
            conjugate = [i for i in tag if isinstance(i, int)]
            
            tag =  [i for i in tag if isinstance(i, str) and not i.startswith('P')]
            tag = tag + ['C%s'%i for i in conjugate]             
            tag = tag + [i for i in all_tag if isinstance(i, str) and  i.startswith('P')] 
            
            conjugate = tuple([int(c[1:]) for c in tag if c.startswith('C')])
            loop = any((t.startswith('L') for t in tag))
            if loop:
                aloha.loop_mode = True
                self.explicit_combine = True
                       
            for l_name in list_l_name:
                try:
                    request[l_name][conjugate].append((outgoing,tag))
                except Exception:
                    try:
                        request[l_name][conjugate] = [(outgoing,tag)]
                    except Exception:
                        request[l_name] = {conjugate: [(outgoing,tag)]}
                           
        # Loop on the structure to build exactly what is request
        for l_name in request:
            lorentz = eval('self.model.lorentz.%s' % l_name)
            if lorentz.structure == 'external':
                for tmp in request[l_name]:
                    for outgoing, tag in request[l_name][tmp]:
                        name = aloha_writers.get_routine_name(lorentz.name,outgoing=outgoing,tag=tag)
                        if name not in self.external_routines:
                            self.external_routines.append(name)
                continue
            
            builder = AbstractRoutineBuilder(lorentz, self.model)

            
            for conjg in request[l_name]:
                #ensure that routines are in rising order (for symetries)
                def sorting(a,b):
                    if a[0] < b[0]: return -1
                    else: return 1
                routines = request[l_name][conjg]
                routines.sort(sorting)
                if not conjg:
                    # No need to conjugate -> compute directly
                    self.compute_aloha(builder, routines=routines)
                else:
                    # Define the high level conjugate routine
                    conjg_builder = builder.define_conjugate_builder(conjg)
                    # Compute routines
                    self.compute_aloha(conjg_builder, symmetry=lorentz.name,
                                         routines=routines)
            
        
        # Build mutiple lorentz call
        for list_l_name, tag, outgoing in data:
            if len(list_l_name) ==1:
                continue
            #allow tag to have integer for retrocompatibility
            conjugate = [i for i in tag if isinstance(i, int)]
            all_tag = tag[:]
            tag =  [i for i in tag if isinstance(i, str) and not i.startswith('P')]
            tag = tag + ['C%s'%i for i in conjugate] 
            tag = tag + [i for i in all_tag if isinstance(i, str) and  i.startswith('P')] 
            
            if not self.explicit_combine:
                lorentzname = list_l_name[0]
                lorentzname += ''.join(tag)
                if self.has_key((lorentzname, outgoing)):
                    self[(lorentzname, outgoing)].add_combine(list_l_name[1:])
                else:
                    lorentz = eval('self.model.lorentz.%s' % list_l_name[0])
                    assert lorentz.structure == 'external'
            else:
                l_lorentz = []
                for l_name in list_l_name: 
                    l_lorentz.append(eval('self.model.lorentz.%s' % l_name))
                builder = CombineRoutineBuilder(l_lorentz)
                               
                for conjg in request[list_l_name[0]]:
                    #ensure that routines are in rising order (for symetries)
                    def sorting(a,b):
                        if a[0] < b[0]: return -1
                        else: return 1
                    routines = request[list_l_name[0]][conjg]
                    routines.sort(sorting)
                    if not conjg:
                        # No need to conjugate -> compute directly
                        self.compute_aloha(builder, routines=routines)
                    else:
                        # Define the high level conjugate routine
                        conjg_builder = builder.define_conjugate_builder(conjg)
                        # Compute routines
                        self.compute_aloha(conjg_builder, symmetry=lorentz.name,
                                        routines=routines)

    create_aloha.AbstractALOHAModel.compute_subset = patched_compute_subset

