include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SUBJECTS_SM_PRIMES=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.bet.nii.gz)
SUBJECTS_SM_SECONDARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.cr.nii.gz)
SUBJECTS_SM_TERTIARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.no.nii.gz)

SPM_TEMP_FILE=SPM_TEMP_FILE.txt
SPM_MINOR_TEMP_FILE=SPM_MINOR_TEMP_FILE.txt
START=BEGIN_READ
all:
	echo "Smoothing Data" ;\
	echo "Smoothing Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(SM_SWITCH) == YES ]; then \
			if [ $(FSLSPM_SM_SWITCH) == FSL ]; then \
					module load fsl ;\
					if [ $(ORDER_OPS_1) == SM ]; then \
							for i in $(basename $(basename $(SUBJECTS_SM_PRIMES))); do \
									susan $(addsuffix .nii.gz, $$i) -1.0 $(FWHM) 3 1 0 $(addsuffix .sm.nii.gz, $$i) $(SMOOTH_OPT) ;\
									echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
					fi;\
					if [ $(ORDER_OPS_2) == SM ]; then \
							for i in $(basename $(basename $(SUBJECTS_SM_SECONDARY))); do \
									susan $(addsuffix .nii.gz, $$i) -1.0 $(FWHM) 3 1 0 $(addsuffix .sm.nii.gz, $$i) $(SMOOTH_OPT) ;\
									echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
					fi;\
					if [ $(ORDER_OPS_3) == SM ]; then  \
							for i in $(basename $(basename $(SUBJECTS_SM_TERTIARY))); do \
									susan $(addsuffix .nii.gz, $$i) -1.0 $(FWHM) 3 1 0 $(addsuffix .sm.nii.gz, $$i) $(SMOOTH_OPT) ;\
									echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
					fi;\
			fi;\
			if [ $(FSLSPM_SM_SWITCH) == SPM ]; then \
					module load matlab ;\
					module load spm ;\
					echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
					echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
					echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
					if [ $(ORDER_OPS_1) == SM ]; then \
							for i in $(SUBJECTS_SM_PRIMES); do \
									echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									echo $$i >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
							echo $(FWHM) >> $(DIR_INTEREST)/$(SPM_MINOR_TEMP_FILE) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; smoothing(pwd); quit()' ;\
					fi;\
					if [ $(ORDER_OPS_2) == SM ]; then \
							for i in $(SUBJECTS_SM_SECONDARY); do \
									echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									echo $$i >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
							echo $(FWHM) >> $(DIR_INTEREST)/$(SPM_MINOR_TEMP_FILE) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; smoothing(pwd); quit()' ;\
					fi;\
					if [ $(ORDER_OPS_3) == SM ]; then  \
							for i in $(SUBJECTS_SM_TERTIARY); do \
									echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									echo $$i >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
							echo $(FWHM) >> $(DIR_INTEREST)/$(SPM_MINOR_TEMP_FILE) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; smoothing(pwd); quit()' ;\
					fi;\
					rm $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
					rm $(DIR_INTEREST)/$(SPM_MINOR_TEMP_FILE);\
					rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			fi;\
	fi;\
