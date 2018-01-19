include $(CONTROL_PANEL)
#What we ultimately want is for the make file to do the iteration over multiple
#subjects so the loops that achieve this should be within the makefile itself
#not within any longleaf wrapper

#There may be/will be a need to address how best to time these tasks and figure
#out upon scaling up how much total time a task will take. There will be a lot
#of trial and error in determining this and it will need to take into
#account the properties of the cluster running the process in the first place

.PHONY: all

all:
	#Convert and Directory Setup
	#$(MAKE) -f $(PIPELINE_HOME)/DirectorySetup.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL)
	#Reorientation--FSL only
	#$(MAKE) -f $(PIPELINE_HOME)/Reorientation.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Motion Outlier Detection--FSL only
	#$(MAKE) -f $(PIPELINE_HOME)/ARTDetection.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Motion and Slice-timing Correction--Python script(neither FSL nor SPM)--no option
	#$(MAKE) -f $(PIPELINE_HOME)/MCorrection.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Skull stripping--FSL only--no option
	#$(MAKE) -f $(PIPELINE_HOME)/SStripping.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Segmentation
	#$(MAKE) -f $(PIPELINE_HOME)/Segmentation.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Coregistration
	#$(MAKE) -f $(PIPELINE_HOME)/Coregistration.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Component Based Noise Correction Method (CompCor)
	#$(MAKE) -f $(PIPELINE_HOME)/aCompCor.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Generation of Nuissance Regressors
	#$(MAKE) -f $(PIPELINE_HOME)/Nuissance_Regressors.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Normalizaton
	#$(MAKE) -f $(PIPELINE_HOME)/Normalization.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#Smoothing
	#$(MAKE) -f $(PIPELINE_HOME)/Smoothing.mk PROJECT_HOME_local=$(PROJECT_HOME_local) CONTROL_PANEL=$(CONTROL_PANEL) DIR_INTEREST=$(DIR_INTEREST)
	#DARTEL Model
	#$(MAKE) -f $(PIPELINE_HOME)/DARTEL_Normalize.mk CONTROL_PANEL=$(CONTROL_PANEL) PROJECT_HOME_local=$(PROJECT_HOME_local)
	#First Level GLM
	#$(MAKE) -f $(PIPELINE_HOME)/1stLevelGLM.mk CONTROL_PANEL=$(CONTROL_PANEL) PROJECT_HOME_local=$(PROJECT_HOME_local)
	#Fixed Effects (FSL Only)
	#$(MAKE) -f $(PIPELINE_HOME)/Fixed_Effects.mk CONTROL_PANEL=$(CONTROL_PANEL) PROJECT_HOME_local=$(PROJECT_HOME_local)
	#Quality Assurance
	#$(MAKE) -f $(PIPELINE_HOME)/QA.mk CONTROL_PANEL=$(CONTROL_PANEL) PROJECT_HOME_local=$(PROJECT_HOME_local)
