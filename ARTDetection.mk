include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

SUBJECTS_FUNCS_RO=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*ro.nii.gz)
SUBJECTS_FUNCS=$(shell ls -d $(DIR_INTEREST)/$(BASENAME)*.nii.gz)

all:
	module load fsl ;\
	echo "Motion Outlier (ART) Detection" ;\
	echo "Motion Outlier (ART) Detection" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(RO_SWITCH) == YES ]; then \
			for i in $(basename $(basename $(SUBJECTS_FUNCS_RO))); do \
					fsl_motion_outliers -i $(addsuffix .nii.gz, $$i) -o $(addsuffix .MODregs.txt, $$i) $(ART_OPT) ;\
					echo $(addsuffix .nii.gz, $$i) "processed" >> $(DIR_INTEREST)/$(Report_Filename) ;\
			done;\
	fi;\
	if [ $(RO_SWITCH) == NO ]; then \
			for i in $(basename $(basename $(SUBJECTS_FUNCS))); do \
					fsl_motion_outliers -i $(addsuffix .nii.gz, $$i) -o $(addsuffix .MODregs.txt, $$i) $(ART_OPT);\
					echo $(addsuffix .nii.gz, $$i) "processed" >> $(DIR_INTEREST)/$(Report_Filename) ;\
			done;\
	fi;\
