include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SPM_TEMP_SWITCH=SPM_TEMP_SWITCH.txt
SPM_TEMP_FILE_PAR=SPM_TEMP_FILE_PAR.txt
SPM_TEMP_FILE_MOD=SPM_TEMP_FILE_MOD.txt
SPM_TEMP_FILE_ACOMPCOR=SPM_TEMP_FILE_ACOMPCOR.txt
START=BEGIN_READ

#We now want to grab ahold of files of which there should be only 1, for
#purposes of simplicity, i.e. we only want to end up with one .par file for each
#functional

RUNS=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.mc.nii.gz)

all:
	echo "Generating Nuissance Regressors" ;\
	echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
	echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
	module load matlab ;\
	echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE_PAR) ;\
	echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_SWITCH) ;\
	if [ $(ART_SWITCH) == YES ]; then \
			echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE_MOD) ;\
			echo $(ART_SWITCH) >> $(DIR_INTEREST)/$(SPM_TEMP_SWITCH) ;\
	fi;\
	if [ $(ART_SWITCH) == NO ]; then \
			echo $(ART_SWITCH) >> $(DIR_INTEREST)/$(SPM_TEMP_SWITCH) ;\
	fi;\
	if [ $(ACOMPCOR_SWITCH) == YES ]; then \
			echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE_ACOMPCOR) ;\
			echo $(ACOMPCOR_SWITCH) >> $(DIR_INTEREST)/$(SPM_TEMP_SWITCH) ;\
	fi;\
	if [ $(ACOMPCOR_SWITCH) == NO ]; then \
			echo $(ACOMPCOR_SWITCH) >> $(DIR_INTEREST)/$(SPM_TEMP_SWITCH) ;\
	fi;\
	echo "Nuissance Regressors generated for" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	for i in $(basename $(basename $(basename $(RUNS)))); do \
			echo $(addsuffix .PAR.par, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE_PAR) ;\
			if [ $(ART_SWITCH) == YES ]; then \
					echo $(addsuffix .MODregs.txt, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE_MOD) ;\
			fi;\
			if [ $(ACOMPCOR_SWITCH) == YES ]; then \
					if [ $(SS_SWITCH) == YES ]; then \
							echo $(addsuffix .mc.bet.cr.masked.ACOMPCORregs.txt, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE_ACOMPCOR) ;\
					fi;\
					if [ $(SS_SWITCH) == NO ]; then \
							echo $(addsuffix .mc.cr.masked.ACOMPCORregs.txt, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE_ACOMPCOR) ;\
					fi;\
			fi;\
			echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
	done;\
	cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; nuissance_regressors(pwd); quit()' ;\
	#rm $(DIR_INTEREST)/*SPM_TEMP*
	#rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
