include $(PROJECT_HOME_local)/$(CONTROL_PANEL)
#--Run FSL Feats--

FSL_FSF_files = $(shell ls -d $(SUBJECTS_DIR_1STLEVELANALYSIS)/*.fsf)

all:
	module load fsl ;\
	for i in $(FSL_FSF_files); do \
			sbatch $(PIPELINE_HOME)/Run_Feats.sh $$i ;\
	done;\
