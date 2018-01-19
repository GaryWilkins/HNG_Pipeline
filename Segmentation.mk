include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SUBJECTS_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.nii.gz)
SUBJECTS_RO_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.ro.nii.gz)
SUBJECTS_BET_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.bet.nii.gz*)

SPM_TEMP_FILE=SPM_TEMP_FILE.txt
START=BEGIN_READ
all:
	echo "Segmenting Data" ;\
	echo "Segmenting Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	module load fsl ;\
	if [ $(FT_SWITCH) == YES ]; then \
			if [ $(FSLSPM_FT_SWITCH) == FSL ]; then \
					if [ $(SS_SWITCH) == YES ]; then \
							for i in $(basename $(basename $(basename $(SUBJECTS_BET_MPRAGEs)))); do \
									fast $(addsuffix .bet.nii.gz, $$i) $(SEG_OPT);\
									echo $(addsuffix .bet.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
									slices $(addsuffix .bet_pve_0.nii.gz, $$i) -o $(addsuffix .bet_pve_0.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .bet.nii.gz, $$i) >> $(addsuffix .bet_pve_0.apng.txt, $$i) ;\
									slices $(addsuffix .bet_pve_1.nii.gz, $$i) -o $(addsuffix .bet_pve_1.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .bet.nii.gz, $$i) >> $(addsuffix .bet_pve_1.apng.txt, $$i) ;\
									slices $(addsuffix .bet_pve_2.nii.gz, $$i) -o $(addsuffix .bet_pve_2.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .bet.nii.gz, $$i) >> $(addsuffix .bet_pve_2.apng.txt, $$i) ;\
							done;\
					fi;\
					if [ $(SS_SWITCH) == NO ]; then \
							if [ $(RO_SWITCH) == YES ]; then \
									for i in $(basename $(basename $(basename $(SUBJECTS_MPRAGEs)))); do \
											fast $(addsuffix .ro.nii.gz, $$i) $(SEG_OPT);\
											echo $(addsuffix .ro.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											slices $(addsuffix .ro_pve_0.nii.gz, $$i) -o $(addsuffix .ro_pve_0.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .ro.nii.gz, $$i) >> $(addsuffix .ro_pve_0.apng.txt, $$i) ;\
											slices $(addsuffix .ro_pve_1.nii.gz, $$i) -o $(addsuffix .ro_pve_1.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .ro.nii.gz, $$i) >> $(addsuffix .ro_pve_1.apng.txt, $$i) ;\
											slices $(addsuffix .ro_pve_2.nii.gz, $$i) -o $(addsuffix .ro_pve_2.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .ro.nii.gz, $$i) >> $(addsuffix .ro_pve_2.apng.txt, $$i) ;\
									done;\
							fi;\
							if [ $(RO_SWITCH) == NO ]; then \
									for i in $(basename $(basename $(SUBJECTS_MPRAGEs))); do \
											fast $(addsuffix .nii.gz, $$i) $(SEG_OPT);\
											echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											slices $(addsuffix _pve_0.nii.gz, $$i) -o $(addsuffix _pve_0.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix _pve_0.ang.txt, $$i) ;\
											slices $(addsuffix _pve_1.nii.gz, $$i) -o $(addsuffix _pve_1.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix _pve_1.apng.txt, $$i) ;\
											slices $(addsuffix _pve_2.nii.gz, $$i) -o $(addsuffix _pve_2.png, $$i) ;\
											echo "Segmentation QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix _pve_2.apng.txt, $$i) ;\
									done;\
							fi;\
					fi;\
			fi;\
			if [ $(FSLSPM_FT_SWITCH) == SPM ]; then \
					module load matlab ;\
					module load spm ;\
					if [ $(RO_SWITCH) == YES ]; then \
							echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
							for i in $(SUBJECTS_RO_MPRAGEs); do \
									echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
									echo $$i >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; segment(pwd); quit()' ;\
							for i in $(basename $(basename $(SUBJECTS_RO_MPRAGEs))); do \
									slices $(addsuffix .c1.nii.gz, $$i) -o $(addsuffix .c1.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c1.nii.gz, $$i) >> $(addsuffix .c1.apng.txt, $$i) ;\
									slices $(addsuffix .c2.nii.gz, $$i) -o $(addsuffix .c2.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c2.nii.gz, $$i) >> $(addsuffix .c2.apng.txt, $$i) ;\
									slices $(addsuffix .c3.nii.gz, $$i) -o $(addsuffix .c3.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c3.nii.gz, $$i) >> $(addsuffix .c3.apng.txt, $$i) ;\
							done;\
					fi;\
					if [ $(RO_SWITCH) == NO ]; then \
							echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
							for i in $(SUBJECTS_MPRAGEs); do \
									echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
									echo $$i >> $(DIR_INTEREST)/$(Report_Filename) ;\
							done;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; segment(pwd); quit()' ;\
							for i in $(basename $(basename $(SUBJECTS_MPRAGEs))); do \
									slices $(addsuffix .c1.nii.gz, $$i) -o $(addsuffix .c1.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c1.nii.gz, $$i) >> $(addsuffix .c1.apng.txt, $$i) ;\
									slices $(addsuffix .c2.nii.gz, $$i) -o $(addsuffix .c2.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c2.nii.gz, $$i) >> $(addsuffix .c2.apng.txt, $$i) ;\
									slices $(addsuffix .c3.nii.gz, $$i) -o $(addsuffix .c3.png, $$i) ;\
									echo "Segmentation QA for" $(addsuffix .c3.nii.gz, $$i) >> $(addsuffix .c3.apng.txt, $$i) ;\
							done;\
					fi;\
					rm $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
					rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			fi;\
	fi;\
