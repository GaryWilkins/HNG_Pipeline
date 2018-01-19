include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

all:
	module load mricron ;\
	dcm2nii -4 y -g y $(SUBJECTS_DIR_RAW)/* ;\
	for j in $(shell ls -d $(SUBJECTS_DIR_RAW)/$(SUBJECTS_ITR) | rev | cut -d '/' -f1 | rev); do \
			mkdir -p $(SUBJECTS_DIR_PREPROCESSED)/$$j ;\
			cp $(SUBJECTS_DIR_RAW)/$$j/$(BASENAME) $(SUBJECTS_DIR_PREPROCESSED)/$$j ;\
			cp $(SUBJECTS_DIR_RAW)/$$j/*MPRAGE* $(SUBJECTS_DIR_PREPROCESSED)/$$j ;\
	done
