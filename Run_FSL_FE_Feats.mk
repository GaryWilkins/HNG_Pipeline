include $(PROJECT_HOME_local)/$(CONTROL_PANEL)
#--Run FSL Feats--

FSL_FE_FSF_files = $(shell ls -d $(SUBJECTS_DIR_1STLEVELANALYSIS)/*_FE*.fsf)

all:
	module load fsl ;\
	for i in $(FSL_FE_FSF_files); do \
			sbatch -t $(SLURM_time) -n $(SLURM_cores) --mem=$(SLURM_mem) -o $(SLURM_output_dir)/$(SLURM_name_patt)_%A.out $(PIPELINE_HOME)/Run_Feats.sh $$i ;\
	done;\
