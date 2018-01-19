##### Directory initializations##################################################
# On longleaf
# PIPELINE_HOME will be where the all makefiles are stored
PIPELINE_HOME=/proj/hng/hng_pipeline
# FSL Paths and Objects
LUTpaths=/nas/longleaf/apps/fsl/5.0.10/fsl/etc/luts
LUT=rendersea.lut
MNIpaths=/nas/longleaf/apps/fsl/5.0.10/fsl/data/standard
# SPM Paths and Objects
TPMpaths=/nas/longleaf/apps/fsl/5.0.10/fsl/data/standard
# ANTs Directory
ANTspath=/nas/longleaf/apps/ants/2.2.0/src
# R/3.2.1 Path
Rpath=/proj/hng/hng_pipeline/bin
################################################################################

###### User Directory/Study initializations#####################################
# Define here the root off which your project and study are branched from
ROOT=/proj/hng/
PROJECT_HOME=$(ROOT)
# PROJECT_HOME_local is just where you store the Study pertinent Top_Level.mk, Control_Panel.mk, and Pipeline_Wrapper files
PROJECT_HOME_local=$(PROJECT_HOME)/Pipeline_Local
# STUDY=$(PROJECT_HOME)/[Replace with study/project name and remove brackets]
STUDY=$(PROJECT_HOME)/
# Location of subjects folder (in particular raw data)
SUBJECTS_DIR_RAW=$(PROJECT_HOME)/Raw_Data
SUBJECTS_DIR_PREPROCESSED=$(STUDY)/Preprocessed_Data
SUBJECTS_DIR_1STLEVELANALYSIS=$(STUDY)/1stLevelAnalysis
# Iteration Component (define an array variable)
# This array must be all numerical given the structure of this pipeline
# Will need to write UNIX ls command to be appropriate given subject nomenclature
SUBJECTS_ITR=
BASENAME=
SUBJECTS_ARRAYS=$(shell ls -d $(SUBJECTS_DIR_RAW)/$(SUBJECTS_ITR))
################################################################################

###### Job Submission Parameters (SLURM)########################################
SLURM_time=16:00:00
# e.g. 8:00:00
SLURM_cores=8
# e.g. 6
SLURM_mem=80G
# memory in human readable units (Gigabytes)
SLURM_name_patt=
# what do you want the pattern of the SLURM output text files to be
SLURM_output_dir=$(PROJECT_HOME_local)/
# where do you want the SLURM outputs saved (please--the whole path--!!!)
################################################################################

###### MATLAB/SPM initialization################################################
# will need to speed up at some point
# speed will be an issue unless matlab files are compiled (e.g. C++)
# path for MATLAB
MATLABROOT=/nas/longleaf/apps/matlab/2016b/bin
MATLAB_SCRIPT=$(SCRIPTpath)/MATLAB
################################################################################

# Freesurfer initialization#####################################################
FREESURFER_HOME=/nas/longleaf/apps/freesurfer/6.0.0/freesurfer
################################################################################

###### Pre-processing parameters################################################
#*************Motion Outlier (ART) Detection Parameters#########################
ART_OPT= --fd --thresh=2
# Define what options you'd like to specify for FSL's motion outlier detection function
#*************Motion and Slice Timing Correction Parameters*********************
# repetition time
TR=2.5
# sliceorder is one of the settings determined prior to image acquisition
SLICEORDER='ascending'
#*************Skull Stripping Parameters****************************************
# Define what options you'd like to specify for 4d nifti (EPI) compressed files under
# FSL's bet function here
BET4d= -F
# Define what options you'd like to specify for 3d nifty (MPRAGE) compressed files
#(e.g. anatomical data) under FSL's bet function here
BET3d= -f 0.2 -B
#*************Coregistration Parameters*****************************************
FLIRT_OPT=
# Define what options you'd like to specify for FSL's flirt function
#*************Normalization Parameters******************************************
FNIRT_OPT=
ANTS_OPT=
# Define what options you'd like to specify for FSL's fnirt function
# normalization reference file
NORM_REF_FSL=MNI152_T1_2mm_brain
NORM_REF_SPM=MNI152_T1_2mm.nii.gz
NORM_REF_ANTS=MNI152_T1_2mm_brain.nii.gz
#*************Smoothing Parameters**********************************************
#full with half max - this is your smoothing kernel
FWHM=5
#Define what options you'd like to specify for FSL's fnirt function
SMOOTH_OPT=
#*************Segmentation Parameters*******************************************
#Define what options you'd like to specify for FSL's fast function
SEG_OPT=
################################################################################

###### ACompCor Parameters #####################################################
# Principle components
NPC=5
# Partial least squares regresion
PCTVAR=0
################################################################################

###### Freesurfer Parameters ###################################################
# Used in creating masks from freesurfer segmentations
erosionfactor=1
################################################################################

##### Flags: To do/not to do process; to use FSL or SPM#########################
# RO - Reorientation
RO_SWITCH=YES
# MC - Motion and Slice-timing Correction
MC_SWITCH=YES
# Automatic MC - Motion and Slice-timing Correction
MC_AUTO_SWITCH=YES
# Motion Outlier Detection
ART_SWITCH=YES
ACOMPCOR_SWITCH=NO
# Skull Stripping
SS_SWITCH=
# Coregistration
CR_SWITCH=YES
# Single Pass or Multi-pass coregistration (ONEPASS or TWOPASS)
CR_STEP=ONEPASS
FSLSPM_CR_SWITCH=
NO_SWITCH=YES
# FSL, SPM, or ANTs can be used to drive Normalization
OPTS_NO_SWITCH=
SM_SWITCH=YES
FSLSPM_SM_SWITCH=
# Segmentatation
FT_SWITCH=YES
FSLSPM_FT_SWITCH=
#--Note This section is for explicitly defining the order of potential operations
#--CR=Coregistration--NO=Normalization--SM=Smoothing
ORDER_OPS_1=CR
ORDER_OPS_2=NO
ORDER_OPS_3=SM
################################################################################

##### First Level GLM Parameters ###############################################
FSLSPM_GLM_SWITCH=
# FSL Parameters ***************************************************************
FSFPrefix=EMOREG_FE
SubREPLACE=XXSUBJECTXX
RunREPLACE=XXRUNXX
INIT_FE_FSF=/proj/hng/sheridanlab/projects/YES_old/YES4GARY/projects/Pipeline_Demonstration_01092018/Pipeline_Local/master_FE_fsf.txt
FSF_MASTER_FILE=/proj/hng/sheridanlab/projects/YES_old/YES4GARY/projects/Pipeline_Demonstration_01092018/Pipeline_Local/master_all_fsf.txt
# SPM Parameters ***************************************************************
# SPM timing units are either 'secs' or 'scans'
TIMING_UNIT=secs
# SPM Microtime Resolution (should match # of slices after slice-timing correction)
Microtime_Resolution=44
# SPM Microtime Onset (should match the reference slice)
Microtime_Onset=22
# User Spec File Directory
UserSpecFile_DIR=/proj/hng/sheridanlab/projects/YES_old/YES4GARY/projects/UserSpecFile_DIR
# Directory for Subjects Onset Data
Subjects_Onset_DIR=/proj/hng/sheridanlab/projects/YES_old/YES4GARY/projects/Subjects_Onset_DIR
# Factorial Design
# factorial design Switch must be specified as either YES or NO
Factorial_Design_SWITCH=NO
Factorial_Design_Name=
Factorial_Number_Levels=
# Basis Functions
# MUST choose from among { 1) CHRF => Canonical HRF, 2) FS => Fourier Set, 3) FSH => Fourier Set Henning, 4) GF => Gamma Functions, 5) FIR => Finite Impulse Response, 6) NONE}
BASIS_FUNCTION=CHRF
# if Canonical HRF {choose amongst: 1) [0 0] => no derivative, 2) [1 0] => time derivative, or 3) [1 1] time and dispersion derivative}
MODEL_DERIVATIVE= 0 0
# if Fourier Set, Fourier Set Henning, Gamma Functions, or Finite Impulse Response, must choose window length and order
WINDOW=
BF_ORDER=
# Volterra Interactions {choose: 1 ==> no or 2: model interactions}
Volterra_Model=1
# Global Normalization {choose: Scaling or None}
Global_Norm=None
# Masking Threshold {one such common value is 0.8}
MThreshold=0.8
# Explicit Mask {SWITCH should = YES or NO}
Mask_SWITCH=NO
# Explicit Mask (for analysis) {either use 1 common by specifying path and name or use variable to point to the same-named mask within each subject's preprocessing directory}
Mask=
# Serial Correlations {choose: 1) none, 2) AR(1) => autoregressive, 3) FAST }
SerialCorr=AR\(1\)
# high-pass filter (in secs)
hpf=128
# write residuals {choose: 0 => no or 1 => yes}
wresiduals=1
# Contrast Manager Section #######
# T Contrasts ? (0 => NO, 1 => YES)
T_Contrasts=1
# F Contrasts ? (0 => NO, 1 => YES)
F_Contrasts=0
# T Cond/Sess Based Contrasts ? (0 => NO, 1 => YES)
T_condsess_Contrasts=0
# Do you want to delete existing contrasts? (Default should be NO) (0 => NO, 1 => YES)
Existing_Contrasts_Trigger=0
# Contrast Manager Spec File
Contrast_Manager_Spec_File=/proj/hng/sheridanlab/projects/YES_old/YES4GARY/projects/Pipeline_Demonstration_01092018/Pipeline_Local/Contrasts.xlsx
################################################################################

# Report Generation ############################################################
Report_Filename = Basic_Report_1stLevelAnalysis
Report_Title = Basic Report 1st Level Analysis
Report_Date = $(shell date)
#--
#Assuming directory structure of Projects=>Study(uniq)=>raw_data,processed data
#scripts, etc, and each subject has own folder so file names wouldn't
#necessarily be unique=>strong need for regularization
#--
#It may be a good idea to make subsequent processes look for their make targets
#and in the cases in which those make targets are absent, e.g. end-user
#specifies not to run preceding process(es), accept the most relevant target
#--
#There are some processes that are forced, i.e. no opton to opt-out is permitted
#examples include: motion&slice timing correction, motion outliers detection,
#and skull stripping,
#--
#Should be central place for standard files, e.g. T1, T2 nifty files
################################################################################
