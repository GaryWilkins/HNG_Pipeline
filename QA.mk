include $(PROJECT_HOME_local)/$(CONTROL_PANEL)

all:
	convert $(DIR_INTEREST)/*png* $(DIR_INTEREST)/QA.pdf ;\
	rm $(DIR_INTEREST)/*png* ;\
