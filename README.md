# README #


### What is this repository for? ###

* The plugin in is intended to run ggHg as a standalone with MG5

### How do I get set up? ###

* install MadGraph5_aMC@NLO VERSION 2.7.3
* clone the repo in madgraphs /PLUGIN/ directory
* copy the file /TEMPLATES/aloha_functions.f into ../../aloha/template_files. It only extends the functionality of the gluon wave function to allow for additional polarization states


### How do I use the plugin ###
* use ./mg5_aMC
* type:  
    > import model PATH_TO/PLUGIN/higgsew/UFO_model_gggH/  
    > generate g g > g H GGGH^2==2  
    > output standalone_ggHg EXPORTDIRNAME  
    > launch -f
