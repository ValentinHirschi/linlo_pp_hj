# README #


### What is this repository for? ###

* The plugin in is intended to run ggHg as a standalone with MG5

### How do I get set up? ###

* install MadGraph5_aMC@NLO VERSION 2.7.3
* clone the repo in madgraphs /PLUGIN/ directory
* copy the file /TEMPLATES/aloha_functions.f into ../../aloha/template_files. It only extends the functionality of the gluon wave function to allow for additional polarization states
### Coupling orders and description ###
* GGGHQCD: effective coupling for LO QCD    
* GGGHEW: effective coupling for EW corrections (W and Z)    
* ZZ and WW (lower hierarchy): Z (resp. W) exchange only    

### How do I use the plugin ###
* use ./mg5_aMC --mode=higgsew 
* type:    
    > generate g g > H g GGGHQCD^2==2  
    > output standalone_ggHg EXPORTDIRNAME  
    > launch -f  
    > The benchmark from an analytic computation is: 1.1654775807795E-003  
    > Also see validate_default