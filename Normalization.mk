include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

#to further initialize MATLAB functions
MATLAB_INIT = matlab_init.m
MATLAB_1 = function matlab_init
MATLAB_2 = addpath $(PIPELINE_HOME)

SUBJECTS_NO_PRIMES=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*bet.nii.gz)
SUBJECTS_NO_SECONDARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.cr.nii.gz)
SUBJECTS_NO_TERTIARY=$(shell ls -d $(DIR_INTEREST)/*$(BASENAME)*.sm.nii.gz)

SUBJECTS_CR_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.nii.gz)
SUBJECTS_CR_RO_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.ro.bet.nii.gz)
SUBJECTS_CR_BET_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.bet.nii.gz)

SUBJECTS_CR_RO_SPM_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.ro.nii.gz)
SUBJECTS_CR_SPM_MPRAGEs=$(shell ls -d $(DIR_INTEREST)/*MPRAGE.nii.gz)

SPM_TEMP_FILE=SPM_TEMP_FILE.txt
START=BEGIN_READ

all:
	echo "Normalizing Data" ;\
	echo "Normalizing Data" >> $(DIR_INTEREST)/$(Report_Filename) ;\
	if [ $(NO_SWITCH) == YES ]; then \
			module load fsl ;\
			if [ $(OPTS_NO_SWITCH) == FSL ]; then \
					if [ $(RO_SWITCH) == YES ]; then \
							flirt -ref $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL)) -in $(SUBJECTS_CR_RO_MPRAGEs) -omat $(DIR_INTEREST)/affine_transf.mat ;\
							fnirt --in=$(SUBJECTS_CR_RO_MPRAGEs) --aff=$(DIR_INTEREST)/affine_transf.mat --cout=$(DIR_INTEREST)/nonlinear_transf --config=T1_2_MNI152_2mm.cnf ;\
							applywarp -i $(SUBJECTS_CR_RO_MPRAGEs) -o $(DIR_INTEREST)/warped_structural -r $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL))  -w $(DIR_INTEREST)/nonlinear_transf ;\
					fi;\
					if [ $(RO_SWITCH) == NO ]; then \
							flirt -ref $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL)) -in $(SUBJECTS_CR_BET_MPRAGEs) -omat $(DIR_INTEREST)/affine_transf.mat ;\
							fnirt --in=$(SUBJECTS_CR_BET_MPRAGEs) --aff=$(DIR_INTEREST)/affine_transf.mat --cout=$(DIR_INTEREST)/nonlinear_transf --config=T1_2_MNI152_2mm.cnf ;\
							applywarp -i $(SUBJECTS_CR_BET_MPRAGEs) -o $(DIR_INTEREST)/warped_structural -r $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL))  -w $(DIR_INTEREST)/nonlinear_transf ;\
					fi;\
					if [ $(ORDER_OPS_1) == NO ]; then \
							for i in $(basename $(basename $(basename $(SUBJECTS_NO_PRIMES)))); do \
									applywarp -i $(addsuffix .bet.nii.gz, $$i) -o $(addsuffix .bet.no.nii.gz, $$i) -r $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL))  -w $(DIR_INTEREST)/nonlinear_transf.nii.gz --premat=$(addsuffix .bet.cr.mat, $$i)  ;\
									echo $(addsuffix .bet.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
									slicer $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL)) $(addsuffix .bet.no.nii.gz, $$i) -L -A 650 $(addsuffix .bet.noQA.png, $$i) ;\
									echo "Normalization QA for" $(addsuffix .bet.nii.gz, $$i) >> $(addsuffix .bet.noQA.apng.txt, $$i) ;\
							done;\
					fi;\
					if [ $(ORDER_OPS_2) == NO ]; then \
							for i in $(basename $(basename $(basename $(SUBJECTS_NO_PRIMES)))); do \
									applywarp -i $(addsuffix .bet.nii.gz, $$i) -o $(addsuffix .bet.cr.no.nii.gz, $$i) -r $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL))  -w $(DIR_INTEREST)/nonlinear_transf.nii.gz --premat=$(addsuffix .bet.cr.mat, $$i)  ;\
									echo $(addsuffix .bet.cr.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
									slicer $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL)) $(addsuffix .bet.cr.no.nii.gz, $$i) -L -A 650 $(addsuffix .bet.cr.noQA.png, $$i) ;\
									echo "Normalization QA for" $(addsuffix .cr.nii.gz, $$i) >> $(addsuffix .cr.noQA.apng.txt, $$i) ;\
							done;\
					fi;\
					if [ $(ORDER_OPS_3) == NO ]; then  \
							for i in $(basename $(basename $(basename $(SUBJECTS_NO_PRIMES)))); do \
									applywarp -i $(addsuffix .bet.nii.gz, $$i) -o $(addsuffix .bet.sm.no.nii.gz, $$i) -r $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL))  -w $(DIR_INTEREST)/nonlinear_transf.nii.gz --premat=$(addsuffix .bet.cr.mat, $$i)  ;\
									echo $(addsuffix .bet.sm.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
									slicer $(MNIpaths)/$(addsuffix .nii.gz, $(NORM_REF_FSL)) $(addsuffix .bet.sm.no.nii.gz, $$i) -L -A 650 $(addsuffix .bet.sm.noQA.png, $$i) ;\
									echo "Normalization QA for" $(addsuffix .sm.nii.gz, $$i) >> $(addsuffix .sm.noQA.apng.txt, $$i) ;\
							done;\
					fi;\
			fi;\
			if [ $(OPTS_NO_SWITCH) == SPM ]; then \
			    module load matlab ;\
			    module load spm ;\
			    echo $(MATLAB_1) > $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			    echo $(MATLAB_2) >> $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			    echo $(START) > $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			    if [ $(RO_SWITCH) == YES ]; then \
			        echo $(SUBJECTS_CR_RO_SPM_MPRAGEs) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			    fi;\
			    if [ $(RO_SWITCH) == NO ]; then \
			        echo $(SUBJECTS_CR_SPM_MPRAGEs) >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			    fi;\
			    if [ $(ORDER_OPS_2) == NO ]; then \
			        for i in $(SUBJECTS_NO_SECONDARY); do \
			            echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			        done;\
			        cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; normalization(pwd); quit()' ;\
			        for i in $(basename $(basename $(SUBJECTS_NO_SECONDARY))); do \
			            slicer $(TPMpaths)/$(NORM_REF_SPM) $(addsuffix .no.nii.gz, $$i) -L -A 650 $(addsuffix .noQA.png, $$i) ;\
			            echo "Normalization QA for" $(addsuffix .no.nii.gz, $$i) >> $(addsuffix .noQA.apng.txt, $$i) ;\
			            echo $(addsuffix .no.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			        done;\
			    fi;\
			    if [ $(ORDER_OPS_3) == NO ]; then  \
			        for i in $(SUBJECTS_NO_TERTIARY); do \
			            echo $$i >> $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			        done;\
			        cd $(DIR_INTEREST) && $(MATLABROOT)/matlab -nodesktop -nosplash -r 'matlab_init; spm_prep; normalization(pwd); quit()' ;\
			        for i in $(basename $(basename $(SUBJECTS_NO_TERTIARY))); do \
			            slicer $(TPMpaths)/$(NORM_REF_SPM) $(addsuffix .no.nii.gz, $$i) -L -A 650 $(addsuffix .noQA.png, $$i) ;\
			            echo "Normalization QA for" $(addsuffix .no.nii.gz, $$i) >> $(addsuffix .noQA.apng.txt, $$i) ;\
			            echo $(addsuffix .no.nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			        done;\
			    fi;\
			    rm $(DIR_INTEREST)/$(SPM_TEMP_FILE);\
			    rm $(DIR_INTEREST)/$(MATLAB_INIT) ;\
			fi;\
			if [ $(OPTS_NO_SWITCH) == ANTS ]; then \
					if [ $(RO_SWITCH) == YES ]; then \
							if [ $(SS_SWITCH) == YES ]; then \
									$(ANTspath)/stnava-ANTs-dc99262/Scripts/antsRegistrationSyN.sh -d 3 -f $(MNIpaths)/$(NORM_REF_ANTS) -m $(SUBJECTS_CR_RO_MPRAGEs) -o $(DIR_INTEREST)/MPRAGE_MNI $(ANTS_OPT) ;\
									$(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(SUBJECTS_CR_RO_MPRAGEs) -e 0 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(DIR_INTEREST)/MPRAGE_MNI.nii.gz -v 1 $(ANTS_OPT) ;\
							fi;\
							if [ $(SS_SWITCH) == NO ]; then \
									$(ANTspath)/stnava-ANTs-dc99262/Scripts/antsRegistrationSyN.sh -d 3 -f $(MNIpaths)/$(NORM_REF_ANTS) -m $(SUBJECTS_CR_RO_SPM_MPRAGEs) -o $(DIR_INTEREST)/MPRAGE_MNI $(ANTS_OPT) ;\
									$(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(SUBJECTS_CR_RO_MPRAGEs) -e 0 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(DIR_INTEREST)/MPRAGE_MNI.nii.gz -v 1 $(ANTS_OPT) ;\
							fi;\
					fi;\
					if [ $(RO_SWITCH) == NO ]; then \
							if [ $(SS_SWITCH) == YES ]; then \
									$(ANTspath)/stnava-ANTs-dc99262/Scripts/antsRegistrationSyN.sh -d 3 -f $(MNIpaths)/$(NORM_REF_ANTS) -m $(SUBJECTS_CR_BET_MPRAGEs) -o $(DIR_INTEREST)/MPRAGE_MNI $(ANTS_OPT) ;\
									$(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(SUBJECTS_CR_RO_MPRAGEs) -e 0 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(DIR_INTEREST)/MPRAGE_MNI.nii.gz -v 1 $(ANTS_OPT) ;\
							fi;\
							if [ $(SS_SWITCH) == NO ]; then \
									$(ANTspath)/stnava-ANTs-dc99262/Scripts/antsRegistrationSyN.sh -d 3 -f $(MNIpaths)/$(NORM_REF_ANTS) -m $(SUBJECTS_CR_SPM_MPRAGEs) -o $(DIR_INTEREST)/MPRAGE_MNI $(ANTS_OPT) ;\
									$(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(SUBJECTS_CR_RO_MPRAGEs) -e 0 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(DIR_INTEREST)/MPRAGE_MNI.nii.gz -v 1 $(ANTS_OPT) ;\
							fi;\
					fi;\
			    if [ $(ORDER_OPS_1) == NO ]; then \
			        for i in $(basename $(basename $(SUBJECTS_NO_PRIMES))); do \
			            $(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(addsuffix .nii.gz, $$i) -e 3 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(addsuffix .no.nii.gz, $$i) -v 1 ;\
			            echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			            slicer $(MNIpaths)/$(NORM_REF_ANTS) $(addsuffix .no.nii.gz, $$i) -L -A 650 $(addsuffix .noQA.png, $$i) ;\
			            echo "Normalization QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .noQA.apng.txt, $$i) ;\
			        done;\
			    fi;\
			    if [ $(ORDER_OPS_2) == NO ]; then \
			        for i in $(basename $(basename $(SUBJECTS_NO_SECONDARY))); do \
			            $(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(addsuffix .nii.gz, $$i) -e 3 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(addsuffix .no.nii.gz, $$i) -v 1 ;\
			            echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			            slicer $(MNIpaths)/$(NORM_REF_ANTS) $(addsuffix .no.nii.gz, $$i) -L -A 650 $(addsuffix .noQA.png, $$i) ;\
			            echo "Normalization QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .noQA.apng.txt, $$i) ;\
			        done;\
			    fi;\
			    if [ $(ORDER_OPS_3) == NO ]; then  \
			        for i in $(basename $(basename $(SUBJECTS_NO_TERTIARY))); do \
			            $(ANTspath)/build/bin/antsApplyTransforms -d 3 -r $(MNIpaths)/$(NORM_REF_ANTS) -i $(addsuffix .nii.gz, $$i) -e 3 -t $(DIR_INTEREST)/MPRAGE_MNI1Warp.nii.gz -t $(DIR_INTEREST)/MPRAGE_MNI0GenericAffine.mat -o $(addsuffix .no.nii.gz, $$i) -v 1 ;\
			            echo $(addsuffix .nii.gz, $$i) >> $(DIR_INTEREST)/$(Report_Filename) ;\
			            slicer $(MNIpaths)/$(NORM_REF_ANTS) $(addsuffix .no.nii.gz, $$i) -L -A 650 $(addsuffix .noQA.png, $$i) ;\
			            echo "Normalization QA for" $(addsuffix .nii.gz, $$i) >> $(addsuffix .noQA.apng.txt, $$i) ;\
			        done;\
			    fi;\
			fi;\
	fi;\
