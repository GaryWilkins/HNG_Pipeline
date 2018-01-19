function coregister_secondary(path)

addpath(path);
LS = textread('secondary_coregistrations.txt','%s');

%epi_reg --epi=$(addsuffix .cr2.nii.gz, $$i) --t1=$(SUBJECTS_CR_WHOLEHEAD_MPRAGES) --t1brain=$(SUBJECTS_CR_BET_MPRAGEs) --out=$(addsuffix .cr.nii.gz, $$i) ;\

Line0 = 'include $(PROJECT_HOME_local)/$(CONTROL_PANEL)';
Line1 = 'all:';
Line2 = 'module load fsl';
EPI1 = 'epi_reg --epi=';
EPI2 = ' --t1=';
EPI3 = ' --t1brain=';
EPI4 = ' --out=';
Line3 = ';\';

%the number of LS elements should be even as there should be the functional
%file and right next to it should be the lower quality structural file

makefile = 'TEMP_MAKEFILE';
fid = fopen(strcat(makefile,'.mk'),'wt');
fprintf(fid, '%s\n',Line0);
fprintf(fid, '%s\n',Line1);
fprintf(fid, '\t%s %s\n',Line2,Line3);
for i=1:2:size(LS,1)
    %strip the .gz, .nii, and tertiary extension
    [~,filename,~] = fileparts(LS{i}); [~,filename,~] = fileparts(filename);
    [~,structname,~] = fileparts(LS{i+1}); [~,structname,~] = fileparts(structname);
    filename2 = strcat(filename,'.cr2.nii.gz');
    structname = strcat(structname,'.bet.nii.gz');
    fprintf(fid, '\t%s %s %s %s %s %s %s %s %s\n',EPI1,LS{i},EPI2,LS{i+1},EPI3,structname,EPI4,filename2,Line3);
end
fclose(fid);

