include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

SUBJECTS_FUNCS=$(shell ls -d $(DIR_INTEREST)/$(BASENAME)*.nii.gz)
SUBJECTS_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*)
SUBJECTS_STRUCTs=$(shell ls -d $(DIR_INTEREST)/*struct*)

all:
	module load fsl ;\
	echo "Begin reorientation" ;\
	echo "Begin reorientation" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	echo "Subject Functional Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	for j in $(basename $(basename $(SUBJECTS_FUNCS))); do \
			fslreorient2std $(addsuffix .nii.gz, $$j) $(addsuffix .ro.nii.gz, $$j) ;\
			echo $(addsuffix .nii.gz, $$j) >> $(DIR_INTEREST)/$(Report_Filename) ;\
	done;\
	echo "Subject Structural (MPRAGE) Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	for j in $(basename $(basename $(SUBJECTS_MPRAGEs))); do \
			fslreorient2std $(addsuffix .nii.gz, $$j) $(addsuffix .ro.nii.gz, $$j) ;\
			echo $(addsuffix .nii.gz, $$j) >> $(DIR_INTEREST)/$(Report_Filename) ;\
	done;\
	echo "Subject Structural (secondary) Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	for j in $(basename $(basename $(SUBJECTS_STRUCTs))); do \
			fslreorient2std $(addsuffix .nii.gz, $$j) $(addsuffix .ro.nii.gz, $$j) ;\
			echo $(addsuffix .nii.gz, $$j) >> $(DIR_INTEREST)/$(Report_Filename) ;\
	done;\
