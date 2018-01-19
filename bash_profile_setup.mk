# purpose of this makefile is to prompt for user inputs
home_dir ?= $(shell bash -c 'read -p "Please type the preferred home directory " pwd; echo $$pwd')

#The purpose of this script is provide groups with a consistent bash_profile across users with the exception possibly being the PI

all:
	echo "umask 007" > ~/.bash_profile ;\
	echo "# FSL Setup" >> ~/.bash_profile ;\
	echo "module load fsl" >> ~/.bash_profile ;\
	echo "# DCM2NII setup" >> ~/.bash_profile ;\
	echo "module load mricron" >> ~/.bash_profile ;\
	echo "# ANTS environment" >> ~/.bash_profile ;\
	echo "export ANTSPATH=/nas/longleaf/apps/ants/2.2.0/src/build/bin" >> ~/.bash_profile ;\
	echo "# Freesurfer environment" >> ~/.bash_profile ;\
	echo "export FREESURFER_HOME=/nas/longleaf/apps/freesurfer/6.0.0/freesurfer" >> ~/.bash_profile ;\
	echo "source $(FREESURFER_HOME)/SetUpFreeSurfer.sh" >> ~/.bash_profile ;\
	echo "alias firefox=~/firefox/firefox" >> ~/.bash_profile ;\
	echo "cd $(home_dir)" >> ~/.bash_profile ;\
