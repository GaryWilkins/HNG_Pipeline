include $(PROJECT_HOME_local)/$(CONTROL_PANEL)


SUBJECTS=$(shell ls -d $(SUBJECTS_DIR_RAW)/$(SUBJECTS_ITR) | rev | cut -d '/' -f1 | rev)

.PHONY: all

all:
	if [ $(GROUP_SWITCH) == OFF ]; then \
			for i in $(SUBJECTS); do \
					echo $(Report_Title) > $(SUBJECTS_DIR_RAW)/$$i/$(Report_Filename) ;\
					echo $(Report_Date) >> $(SUBJECTS_DIR_RAW)/$$i/$(Report_Filename) ;\
					mkdir -p $(SLURM_output_dir)/$$i ;\
					sbatch -t $(SLURM_time) -n $(SLURM_cores) --mem=$(SLURM_mem) -o $(SLURM_output_dir)/$$i/$(SLURM_name_patt)_%A.out --wrap="$(MAKE) -f $(PROJECT_HOME_local)/Top_Level.mk CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(SUBJECTS_DIR_PREPROCESSED)/$$i";\
			done;\
	fi;\
  if [ $(GROUP_SWITCH) == ON ]; then \
			echo $(Report_Title) > $(STUDY)/$(Report_Filename) ;\
			mkdir -p $(SLURM_output_dir) ;\
			sbatch -t $(SLURM_time) -n $(SLURM_cores) -o $(SLURM_output_dir)/$(SLURM_name_patt)_%A.out --wrap="$(MAKE) -f $(PROJECT_HOME_local)/Top_Level.mk CONTROL_PANEL=$(CONTROL_PANEL)";\
	fi;\
