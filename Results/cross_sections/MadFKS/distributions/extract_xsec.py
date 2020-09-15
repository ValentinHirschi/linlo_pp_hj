#!/usr/bin/env python2
import os
import sys
import argparse
from pprint import pprint

_VALID_OBSERVABLES = ('ptj1','ptj2','ptj3','xsec')
_VALID_ORDERS = ['ALL','NLO','LO','pureNLO']

parser = argparse.ArgumentParser(description='Report inclusive cross-sections.')
requiredNamed = parser.add_argument_group('required named arguments')

# Required options
requiredNamed.add_argument('--HwU-path', '--HwU', type=str,
                    help='Path of the raw source of the differential distribution histograms.', required=True)

# Optional options
parser.add_argument('--MG5aMC-path', '--MGpath', type=str, default='/Users/valentin/Documents/MG5/2.6.6',
                    help='Path of your MadGraph5_aMC@NLO distribution.')
parser.add_argument('--perturbative-order', '--po', type=str, default=_VALID_ORDERS[0],choices=_VALID_ORDERS,
                    help='Perturbative order considered')

args = parser.parse_args()

# EDIT below the local path of your MadGraph5_aMC@NLO distribution
# Alternatively set the environment variable MG5AMC when running this script
MG5aMC_root_path = os.getenv('MG5AMC',args.MG5aMC_path)
sys.path.insert(0,MG5aMC_root_path)
try:
    import madgraph.various.histograms as HwU 
except ZeroDivisionError:
    print "WARNING: Could not import the histograms package from MadGraph5_aMC@NLO.\n"+\
          "Make sure that the specified root path of your MG5aMC installation is correct: %s\n"%MG5aMC_root_path+\
          "Note: you can specify this path either by editing this script or through the env. variable MG5AMC or with the option --MGpath."
    sys.exit(1)

# Find the histogram with the specified observable
all_histos = HwU.HwUList(args.HwU_path,raw_labels=True)
selected_histo = {'NLO':None,'LO':None,'pureNLO':None}
for histo in all_histos:
    #print "title: %s vs %s"%(histo.title, observable_to_histo_title[args.observable])
    if histo.title != 'total rate':
        continue
    #print "type: %s vs %s"%(histo.type, args.perturbative_order)    
    if histo.type.startswith('LO'):
        selected_histo['LO'] = histo
    elif histo.type.startswith('NLO'):
        selected_histo['NLO'] = histo
    elif histo.type.startswith('PURENLO'):
        selected_histo['pureNLO'] = histo
    else:
        continue

for key, value in selected_histo.items():
    if value is None:
        print "Could not find the histogram for the perturbative order '%s'."%(
            key
        )
        sys.exit(1)

# Now aggregate the results
xsec = {
    'NLO': {
        'central' : None,
        'error'   : None,
        'mu_min'  : None,
        'mu_max'  : None,
        'pdf_min' : None,
        'pdf_max' : None,        
    },
    'LO': {
        'central' : None,
        'error'   : None,
        'mu_min'  : None,
        'mu_max'  : None,
        'pdf_min' : None,
        'pdf_max' : None,        
    },
    'pureNLO': {
        'central' : None,
        'error'   : None,
        'mu_min'  : None,
        'mu_max'  : None,
        'pdf_min' : None,
        'pdf_max' : None,        
    },
}

for order, histo in selected_histo.items():
    repr_bin = histo.bins[0]
    #print("%s, %s"%(str(repr_bin.boundaries), str(repr_bin.wgts)))    
    xsec[order]['central'] = repr_bin.get_weight('central value')
    xsec[order]['error'] = repr_bin.get_weight('dy')
    xsec[order]['mu_min'] = repr_bin.get_weight('delta_mu_min 0 @aux')
    xsec[order]['mu_max'] = repr_bin.get_weight('delta_mu_max 0 @aux')
    xsec[order]['pdf_min'] = repr_bin.get_weight('delta_pdf_min PDF4LHC15_nlo_30 @aux')
    xsec[order]['pdf_max'] = repr_bin.get_weight('delta_pdf_max PDF4LHC15_nlo_30 @aux')

for order, values in xsec.items():
    if args.perturbative_order != 'ALL' and order!=args.perturbative_order:
        continue
    print("Result for order %s:\n"%order)
    PDF_down = ((values['central']-values['pdf_min'])/(values['central']))*100.0
    PDF_up = ((values['pdf_max']-values['central'])/(values['central']))*100.0
    mu_down = ((values['central']-values['mu_min'])/(values['central']))*100.0
    mu_up = ((values['mu_max']-values['central'])/(values['central']))*100.0
    res_human_readable = '%.5g +- %.2g MU: +%.1f%% -%.1f%% PDF: +%.1f%% -%.1f%%'%(
        values['central'],values['error'],mu_up,mu_down,PDF_up,PDF_down
    )
    res_latex = '%.5g^{\;+%.1f\%%\;+%.1f\%%}_{\;-%.1f\%%\;-%.1f\%%}'%(
        values['central'],mu_up,PDF_up,mu_down,PDF_down        
    )
    print('%s\n%s'%(res_human_readable,res_latex))
