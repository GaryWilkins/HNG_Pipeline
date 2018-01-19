include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

SUBJECTS_COREGISTERED=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.cr.nii.gz)

SUBJECTS_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.nii.gz)
SUBJECTS_RO_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.ro.nii.gz)
SUBJECTS_BET_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.bet.nii.gz*)

all:
	module load r ;\
	module load fsl ;\
	echo "Component Based Noise Correction Method (CompCor)" ;\
	echo "Component Based Noise Correction Method (CompCor)" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(FT_SWITCH) == YES ]; then \
			if [ $(SS_SWITCH) == YES ]; then \
					fslmerge -a $(DIR_INTEREST)/MPRAGE_mask.nii.gz $(DIR_INTEREST)/*pve_0.nii.gz $(DIR_INTEREST)/*pve_2.nii.gz ;\
					for i in $(basename $(basename $(SUBJECTS_COREGISTERED))); do \
							fslmaths $(addsuffix .nii.gz, $$i) -mas $(DIR_INTEREST)/MPRAGE_mask.nii.gz $(addsuffix .masked.nii.gz, $$i) ;\
							$(Rpath)/Rscript $(PIPELINE_HOME)/aCompCor.R $(addsuffix .masked.nii.gz, $$i) $(NPC) $(PCTVAR) ;\
							echo $(addsuffix .nii.gz, $$i) "processed" >> $(DIR_INTEREST)/$(Report_Filename) ;\
					done;\
			fi;\
			if [ $(SS_SWITCH) == NO ]; then \
					fslmerge -a $(DIR_INTEREST)/MPRAGE_mask.nii.gz $(DIR_INTEREST)/*MPRAGE*c2*.nii* $(DIR_INTEREST)/*MPRAGE*c3*.nii* ;\
					for i in $(basename $(basename $(SUBJECTS_COREGISTERED))); do \
							fslmaths $(addsuffix .nii.gz, $$i) -mas $(DIR_INTEREST)/MPRAGE_mask.nii.gz $(addsuffix .masked.nii.gz, $$i) ;\
							$(Rpath)/Rscript $(PIPELINE_HOME)/aCompCor.R $(addsuffix .masked.nii.gz, $$i) $(NPC) $(PCTVAR) ;\
							echo $(addsuffix .nii.gz, $$i) "processed" >> $(DIR_INTEREST)/$(Report_Filename) ;\
					done;\
			fi;\
	fi;\
