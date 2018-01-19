include $(PROJECT_HOME_local)/Control_Panel.mk
#--Fixed Effects--
#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

FSL_TEMP_FILE = FSL_TEMP_FILE.txt

SUBJECTS=$(shell ls -d $(SUBJECTS_DIR_1STLEVELANALYSIS)/$(SUBJECTS_ITR)/R*feat)

all:
	module load fsl ;\
	module load matlab ;\
	echo $(MATLAB_1) > $(MATLAB_INIT) ;\
	echo $(MATLAB_2) >> $(MATLAB_INIT) ;\
	echo $(INIT_FE_FSF) > $(FSL_TEMP_FILE) ;\
	echo $(SubREPLACE) >> $(FSL_TEMP_FILE) ;\
	echo $(SUBJECTS_DIR_1STLEVELANALYSIS) >> $(FSL_TEMP_FILE) ;\
	echo $(FSFPrefix) >> $(FSL_TEMP_FILE) ;\
	cd $(PROJECT_HOME_local) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; FSL_FE_FSF_Swap(pwd); quit()' ;\
	rm $(MATLAB_INIT) ;\
	rm $(FSL_TEMP_FILE) ;\
	for i in $(SUBJECTS); do \
			cp -r $(PIPELINE_HOME)/reg $$i/ ;\
	done;\
	$(MAKE) -f $(PIPELINE_HOME)/Run_FSL_FE_Feats.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) ;\
