include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SUBJECTS_CR_PRIMES=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.bet.nii.gz)
SUBJECTS_CR_SECONDARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.no.nii.gz)
SUBJECTS_CR_TERTIARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.sm.nii.gz)

SUBJECTS_CR_BET_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.bet.nii.gz*)
SUBJECTS_CR_WHOLEHEAD_MPRAGES=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.nii.gz)
SUBJECTS_CR_WHITE_MATTER_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*bet_pve_2.nii.gz)

SUBJECTS_CR_SPM_PRIMES=$(shell ls -d $(DIR_INTEREST)/*mc.nii.gz)
SUBJECTS_CR_PRIME_STRUCT=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.nii.gz)
SUBJECTS_CR_RO_PRIME_STRUCT=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.ro.nii.gz)

SPM_TEMP_FILE=SPM_TEMP_FILE.txt
SPM_TEMP_FILE2=SPM_TEMP_FILE2.txt
START=BEGIN_READ
all:
	echo "Coregistering Data" ;\
	echo "Coregistering Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(CR_SWITCH) == YES ]; then \
			module load fsl ;\
			if [ $(FSLSPM_CR_SWITCH) == FSL ]; then \
					if [ $(CR_STEP) == ONEPASS ]; then \
							if [ $(ORDER_OPS_1) == CR ]; then \
									for i in $(basename $(basename $(SUBJECTS_CR_PRIMES))); do \
											epi_reg --epi=$(addsuffix .nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
							if [ $(ORDER_OPS_2) == CR ]; then \
									for i in $(basename $(basename $(SUBJECTS_CR_SECONDARY))); do \
											epi_reg --epi=$(addsuffix .nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
							if [ $(ORDER_OPS_3) == CR ]; then  \
									for i in $(basename $(basename $(SUBJECTS_CR_TERTIARY))); do \
											epi_reg --epi=$(addsuffix .sm.nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
					fi;\
					if [ $(CR_STEP) == TWOPASS ]; then \
							module load matlab ;\
							echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
							echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
							echo "Secondary Coregistrations" >> $(DIR_INTEREST)/$(Report_Filename) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; coregister_secondary(pwd); quit()' ;\
							$(MAKE) -f $(DIR_INTEREST)/TEMP_MAKEFILE.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) ;\
							if [ $(ORDER_OPS_1) == CR ]; then \
									for i in $(basename $(basename $(SUBJECTS_CR_PRIMES))); do \
											epi_reg --epi=$(addsuffix .cr2.nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .cr2.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .cr2.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
							if [ $(ORDER_OPS_2) == CR ]; then \
									for i in $(basename $(basename $(SUBJECTS_CR_SECONDARY))); do \
											epi_reg --epi=$(addsuffix .cr2.nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .cr2.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .cr2.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
							if [ $(ORDER_OPS_3) == CR ]; then  \
									for i in $(basename $(basename $(SUBJECTS_CR_TERTIARY))); do \
											epi_reg --epi=$(addsuffix .cr2.nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\
											echo $(addsuffix .cr2.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											for k in {050..180}; do \
													slicer $(SUBJECTS_CR_BET_MPRAGEs) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
											done;\
											montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
											rm $(DIR_INTEREST)/*.acrQA.png ;\
											echo "Coregistration QA for" $(addsuffix .cr2.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
									done;\
							fi;\
							rm $(DIR_INTEREST)/TEMP_MAKEFILE.mk ;\
					fi;\
			fi;\
			if [ $(FSLSPM_CR_SWITCH) == SPM ]; then \
					module load matlab ;\
					module load spm ;\
					echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
					echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
					if [ $(CR_STEP) == ONEPASS ]; then \
							if [ $(ORDER_OPS_1) == CR ]; then \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_SPM_PRIMES); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_SPM_PRIMES))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
							if [ $(ORDER_OPS_2) == CR ]; then \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_SECONDARY); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_SECONDARY))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
							if [ $(ORDER_OPS_3) == CR ]; then  \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_TERTIARY); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_TERTIARY))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.apng, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
					fi;\
					if [ $(CR_STEP) == TWOPASS ]; then \
							echo "Secondary Coregistrations" >> $(DIR_INTEREST)/$(Report_Filename) ;\
							if [ $(ORDER_OPS_1) == CR ]; then \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_SPM_PRIMES); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_SPM_PRIMES))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
							if [ $(ORDER_OPS_2) == CR ]; then \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_SECONDARY); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_SECONDARY))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
							if [ $(ORDER_OPS_3) == CR ]; then  \
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									for i in $(SUBJECTS_CR_TERTIARY); do \
											echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
									done;\
									echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									if [ $(RO_SWITCH) == YES ]; then \
											echo $(SUBJECTS_CR_RO_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									if [ $(RO_SWITCH) == NO ]; then \
											echo $(SUBJECTS_CR_PRIME_STRUCT) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
									fi;\
									cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; coregister(pwd); quit()' ;\
									for i in $(basename $(basename $(SUBJECTS_CR_TERTIARY))); do \
											if [ $(RO_SWITCH) == YES ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_RO_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
											if [ $(RO_SWITCH) == NO ]; then \
													for k in {050..180}; do \
															slicer $(SUBJECTS_CR_PRIME_STRUCT) $(addsuffix .cr.nii.gz, $$i) -L -z -$$k $(addsuffix .$$k.acrQA.png, $$i) ;\
													done;\
													montage $(DIR_INTEREST)/*.acrQA.png $(addsuffix .crQA.png, $$i) ;\
													rm $(DIR_INTEREST)/*.acrQA.png ;\
													echo "Coregistration QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .crQA.apng.txt, $$i) ;\
													echo $(addsuffix .cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
											fi;\
									done;\
							fi;\
					fi;\
					rm $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
					rm $(DIR_INTEREST)/$(SPM_TEMP_FILE2);\
					rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			fi;\
	fi;\
