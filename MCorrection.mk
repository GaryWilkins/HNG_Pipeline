include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SPM_TEMP_FILE=SPM_TEMP_FILE.txt
MC_TEMP_FILE=MC_TEMP_FILE.txt
MC_MAT_TEMP_FILE=MC_MAT_TEMP_FILE.txt
SUBJECTS_FUNCS_RO=$(shell ls -d $(DIR_INTEREST)/$(BASENAME)*.ro.nii.gz)
SUBJECTS_FUNCS=$(shell ls -d $(DIR_INTEREST)/$(BASENAME)*.nii.gz)

all:
	module add python/3.5.1;
	module load matlab ;\
	module load fsl ;\
	echo "Motion and Slice-Timing Correction" ;\
	echo "Motion and Slice-Timing Correction" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
	echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
	echo "Files processed for Motion and Slice-Timing Correction and PAR output" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(RO_SWITCH) == YES ]; then \
			for i in $(basename $(basename $(SUBJECTS_FUNCS_RO))); do \
					if [ $(MC_AUTO_SWITCH) == NO ]; then \
							$(PIPELINE_HOME)/4dRegister2.py $(TR) $(addsuffix .nii.gz,$$i) --slice_order $(SLICEORDER) --save_params True ;\
							mv $(DIR_INTEREST)/*ro_mc.nii.gz $(addsuffix .mc.nii.gz, $$i) ;\
							mv $(DIR_INTEREST)/mc.par $(addsuffix .PAR.par, $$i) ;\
					fi;\
					if [ $(MC_AUTO_SWITCH) == YES ]; then \
							fslhd $(addsuffix .nii.gz,$$i) > $(DIR_INTEREST)/$(MC_TEMP_FILE) ;\
							echo $(TR) > $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							sed -n '34p' $(DIR_INTEREST)/$(MC_TEMP_FILE) | rev | cut -d ' ' -f1 | rev >> $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; motionslice_correction(pwd); quit()' ;\
							cd $(DIR_INTEREST) && $(MAKE) -f TEMP_MAKEFILE.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL);\
							mv $(DIR_INTEREST)/*ro_mc.nii.gz $(addsuffix .mc.nii.gz, $$i) ;\
							mv $(DIR_INTEREST)/mc.par $(addsuffix .PAR.par, $$i) ;\
					fi;\
					echo $(addsuffix .PAR.par, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			done;\
			cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; plot_motionparams(pwd); quit()' ;\
			rm $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
			rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			rm $(DIR_INTEREST)/$(MC_TEMP_FILE) ;\
		  rm $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
			rm $(DIR_INTEREST)/TEMP_MAKEFILE.mk ;\
	fi;\
	if [ $(RO_SWITCH) == NO ]; then \
			for i in $(basename $(basename $(SUBJECTS_FUNCS))); do \
					if [ $(MC_AUTO_SWITCH) == NO ]; then \
							$(PIPELINE_HOME)/4dRegister2.py $(TR) $(addsuffix .nii.gz,$$i) --slice_order $(SLICEORDER) --save_params True ;\
							mv $(DIR_INTEREST)/*ro_mc.nii.gz $(addsuffix .mc.nii.gz, $$i) ;\
							mv $(DIR_INTEREST)/mc.par $(addsuffix .PAR.par, $$i) ;\
					fi;\
					if [ $(MC_AUTO_SWITCH) == YES ]; then \
							fslhd $(addsuffix .nii.gz,$$i) > $(DIR_INTEREST)/$(MC_TEMP_FILE) ;\
							echo $(TR) > $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							sed -n '34p' $(DIR_INTEREST)/$(MC_TEMP_FILE) | rev | cut -d ' ' -f1 | rev >> $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
							cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; motionslice_correction(pwd); quit()' ;\
							cd $(DIR_INTEREST) && $(MAKE) -f TEMP_MAKEFILE.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL);\							$(MAKE) -f $(DIR_INTEREST)/TEMP_MAKEFILE.mk ;\
							mv $(DIR_INTEREST)/*_mc.nii.gz $(addsuffix .mc.nii.gz, $$i) ;\
							mv $(DIR_INTEREST)/mc.par $(addsuffix .PAR.par, $$i) ;\
					fi;\
					echo $(addsuffix .PAR.par, $$i) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			done;\
			cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; plot_motionparams(pwd); quit()' ;\
			rm $(DIR_INTEREST)/$(SPM_TEMP_FILE) ;\
			rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			rm $(DIR_INTEREST)/$(MC_TEMP_FILE) ;\
		  rm $(DIR_INTEREST)/$(MC_MAT_TEMP_FILE) ;\
			rm $(DIR_INTEREST)/TEMP_MAKEFILE.mk ;\
	fi;\
