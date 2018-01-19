include $(PROJECT_HOME_local)/$(CONTROL_PANEL)
#--DARTEL Normalization

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SPM_DARTEL_TEMP_FILE = SPM_DARTEL_TEMP_FILE.txt
START = BEGIN_READ
STOP = STOP

all:
	module load matlab ;\
	module load spm ;\
	echo $(MATLAB_1) > $(STUDY)/$(MATLAB_INIT) ;\
	echo $(MATLAB_2) >> $(STUDY)/$(MATLAB_INIT) ;\
	echo $(START) > $(STUDY)/$(SPM_DARTEL_TEMP_FILE);\
	echo $(SUBJECTS_ARRAYS) >> $(STUDY)/$(SPM_DARTEL_TEMP_FILE);\
	echo $(STOP) >> $(STUDY)/$(SPM_DARTEL_TEMP_FILE);\
	echo $(DARTEL_OUTPUT) >> $(STUDY)/$(SPM_DARTEL_TEMP_FILE);\
	mkdir -p $(STUDY)/$(DARTEL_OUTPUT) ;\
	cd $(STUDY) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; createDARTELtemplate(pwd); quit()' ;\
	cd $(STUDY) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; DARTELnormalizeMNIspace(pwd); quit()' ;\
	rm *SPM_*txt* ;\
	rm $(MATLAB_INIT) ;\
