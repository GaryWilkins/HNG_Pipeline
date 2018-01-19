include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

SUBJECTS_FUNCS_RO=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.ro.mc*)
SUBJECTS_MPRAGES_RO=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.ro*)
SUBJECTS_STRUCTS_RO=$(shell ls -d $(DIR_INTEREST)/*struct*ro*)

SUBJECTS_FUNCS_noRO=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.mc*)
SUBJECTS_MPRAGES_noRO=$(shell ls -d $(DIR_INTEREST)/*MPRAGE*)
SUBJECTS_STRUCTS_noRO=$(shell ls -d $(DIR_INTEREST)/*struct*)
#--Step 5: Skull stripping (structural and functional)--
#--Notes: if reorientation not done, then accept original nifty file
all:
	module load fsl ;\
	echo "Skull stripping data with FSL's BET" ;\
	echo "Skull stripping data with FSL's BET" >> $(DIR_INTEREST)/$(Report_Filename) ;\
  if [ $(RO_SWITCH) == YES ]; then \
			echo "Functional Data Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
      for i in $(basename $(basename $(SUBJECTS_FUNCS_RO))); do \
          bet $(addsuffix .nii.gz,$$i) $(addsuffix .bet.nii.gz,$$i) $(BET4d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			echo "Anatomical Data (MPRAGE) Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
      for i in $(basename $(basename $(SUBJECTS_MPRAGES_RO))); do \
	  			bet $(addsuffix .nii.gz,$$i) $(addsuffix .bet.nii.gz,$$i) $(BET3d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			echo "Anatomical Data (structural) Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
			for i in $(basename $(basename $(SUBJECTS_STRUCTS_RO))); do \
	  			bet $(addsuffix .nii.gz,$$i) $(addsuffix .bet.nii.gz,$$i) $(BET3d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			rm $(DIR_INTEREST)/*betQA.nii.gz* ;\
  fi;\
  if [ $(RO_SWITCH) == NO ]; then \
			echo "Functional Data Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
      for i in $(basename $(basename $(SUBJECTS_FUNCS_noRO))); do \
          bet $(addsuffix .nii.gz, $$i) $(addsuffix .bet.nii.gz, $$i) $(BET4d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .mc.nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			echo "Anatomical Data (MPRAGE) Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
			for i in $(basename $(basename $(SUBJECTS_MPRAGES_noRO))); do \
          bet $(addsuffix .nii.gz, $$i) $(addsuffix .bet.nii.gz, $$i) $(BET3d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			echo "Anatomical Data (structural) Skull Stripped" >> $(DIR_INTEREST)/$(Report_Filename) ;\
      for i in $(basename $(basename $(SUBJECTS_STRUCTS_noRO))); do \
	  			bet $(addsuffix .nii.gz, $$i) $(addsuffix .bet.nii.gz, $$i) $(BET3d) ;\
					echo $(addsuffix .nii.gz,$$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
					overlay 1 1 $(addsuffix .nii.gz,$$i) -a $(addsuffix .bet.nii.gz,$$i) 1 10 $(addsuffix .betQA.nii.gz, $$i) ;\
					slicer $(addsuffix .betQA.nii.gz, $$i) -l $(LUTpaths)/$(LUT) -L -A 650 $(addsuffix .betQA.png, $$i) ;\
					echo "Skull stripping QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .betQA.apng.txt, $$i) ;\
      done;\
			rm $(DIR_INTEREST)/*betQA.nii.gz* ;\
  fi;\
