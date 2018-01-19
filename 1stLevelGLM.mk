include $(PROJECT_HOME_local)/$(CONTROL_PANEL)
#--1st Level Analysis--

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

FSL_TEMP_FILE = FSL_TEMP_FILE.txt
FSFs_LIST = $(shell ls -d $(dir $(FSF_MASTER_FILE)))
SUBJECTS_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*.nii.gz)

SUBJECTS=$(shell ls -d $(SUBJECTS_DIR_RAW)/$(SUBJECTS_ITR) | rev | cut -d '/' -f1 | rev)
SPM_TEMP_FILE=SPM_1stLEVELANALYSIS_FILE.txt
FACT_DESIGN_FILE=SPM_FACTORIAL_DESIGN_FILE.txt
BASIS_FUNCTION_FILE=SPM_BASIS_FUNCTION_FILE.txt
MASK_FILE=SPM_MASK_FILE.txt

START=BEGIN_READ

all:
	module load matlab ;\
	if [ $(FSLSPM_GLM_SWITCH) == FSL ]; then \
			echo $(MATLAB_1) > $(MATLAB_INIT) ;\
			echo $(MATLAB_2) >> $(MATLAB_INIT) ;\
			mkdir -p $(SUBJECTS_DIR_1STLEVELANALYSIS) ;\
			echo $(FSF_MASTER_FILE) > $(FSL_TEMP_FILE) ;\
			echo $(SubREPLACE) >> $(FSL_TEMP_FILE) ;\
			echo $(RunREPLACE) >> $(FSL_TEMP_FILE) ;\
			echo $(SUBJECTS_DIR_1STLEVELANALYSIS) >> $(FSL_TEMP_FILE) ;\
			echo $(FSFPrefix) >> $(FSL_TEMP_FILE) ;\
			cd $(PROJECT_HOME_local) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; FSL_FSFswap(pwd); quit()' ;\
			rm $(MATLAB_INIT) ;\
			rm $(FSL_TEMP_FILE) ;\
			$(MAKE) -f $(PIPELINE_HOME)/Run_FSL_Feats.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) ;\
	fi;\
	if [ $(FSLSPM_GLM_SWITCH) == SPM ]; then \
	    module load spm ;\
	    for i in $(SUBJECTS); do \
	        mkdir -p $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i ;\
	        echo $(MATLAB_1) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(MATLAB_INIT) ;\
	        echo $(MATLAB_2) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(MATLAB_INIT) ;\
	        echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE);\
	        echo $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(TIMING_UNIT) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(TR) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(Microtime_Resolution) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(Microtime_Onset) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(UserSpecFile_DIR) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(Subjects_Onset_DIR) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					if [ $(Factorial_Design_SWITCH) == YES ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(FACT_DESIGN_FILE) ;\
	            echo $(Factorial_Design_Name) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(FACT_DESIGN_FILE) ;\
	            echo $(Factorial_Number_Levels) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(FACT_DESIGN_FILE) ;\
	        fi;\
	        if [ $(BASIS_FUNCTION) == CHRF ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BASIS_FUNCTION) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(MODEL_DERIVATIVE) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	        fi;\
	        if [ $(BASIS_FUNCTION) == FS ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BASIS_FUNCTION) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(WINDOW) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BF_ORDER) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(BASIS_FUNCTION_FILE) ;\
	        fi;\
	        if [ $(BASIS_FUNCTION) == FSH ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BASIS_FUNCTION) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(WINDOW) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BF_ORDER) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(BASIS_FUNCTION_FILE) ;\
	        fi;\
	        if [ $(BASIS_FUNCTION) == GF ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BASIS_FUNCTION) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(WINDOW) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BF_ORDER) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(BASIS_FUNCTION_FILE) ;\
	        fi;\
	        if [ $(BASIS_FUNCTION) == FIR ]; then \
	            echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BASIS_FUNCTION) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(WINDOW) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(BASIS_FUNCTION_FILE) ;\
	            echo $(BF_ORDER) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)$$i/$(BASIS_FUNCTION_FILE) ;\
	        fi;\
					echo $(Volterra_Model) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(Global_Norm) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(MThreshold) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        if [ $(Mask_SWITCH) == YES ]; then \
							echo $(START) > $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(MASK_FILE) ;\
	            echo $(Mask) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(MASK_FILE) ;\
	        fi;\
	        echo $(SerialCorr) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(SUBJECTS_DIR_PREPROCESSED)/$$i >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
	        echo $(hpf) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(wresiduals) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(T_Contrasts) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(F_Contrasts) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(T_condsess_Contrasts) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(Existing_Contrasts_Trigger) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					echo $(Contrast_Manager_Spec_File) >> $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/$(SPM_TEMP_FILE) ;\
					sbatch -t $(SLURM_time) -n $(SLURM_cores) --mem=$(SLURM_mem) -o $(SLURM_output_dir)/$(SLURM_name_patt)_%A.out --wrap="cd $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; First_Level_GLM(pwd); quit()'" ;\
					#rm $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/*SPM_*txt ;\
					#rm $(SUBJECTS_DIR_1STLEVELANALYSIS)/$$i/matlab_init.m ;\
	    done;\
	fi;\
