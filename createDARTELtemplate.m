function createDARTELtemplate(path)

addpath(path);
LS = textread('SPM_DARTEL_TEMP_FILE.txt','%s');

count = 2;
while strcmp(LS{count},'STOP')~=1
    count = count+1;
end
MATnames_Length = count-2;
MATfiles = cell(1,MATnames_Length);
ANATfiles_c1 = cell(1,MATnames_Length);
ANATfiles_c2 = cell(1,MATnames_Length);
for i=2:count-1
    placeholder = dir(fullfile(LS{i}, '*seg8.mat'));
    MATfiles{i-1} = strcat(LS{i},'/',placeholder.name);
end
for i=2:count-1
    placeholder1 = dir(fullfile(LS{i},'/','*MPRAGE*c1*nii.gz'));
    placeholder2 = dir(fullfile(LS{i},'/','*MPRAGE*c2*nii.gz'));
    gunzip(strcat(LS{i},'/',placeholder1.name));
    gunzip(strcat(LS{i},'/',placeholder2.name));
    placeholder1 = dir(fullfile(LS{i},'/','*MPRAGE*c1*nii'));
    placeholder2 = dir(fullfile(LS{i},'/','*MPRAGE*c2*nii'));    
    ANATfiles_c1{i-1} = strcat(LS{i},'/',placeholder1.name,',1');
    ANATfiles_c2{i-1} = strcat(LS{i},'/',placeholder2.name,',1');
end

clear matlabbatch

matlabbatch{1}.spm.tools.dartel.initial.matnames = MATfiles';
matlabbatch{1}.spm.tools.dartel.initial.odir = {LS{count+1}};
matlabbatch{1}.spm.tools.dartel.initial.bb = [NaN NaN NaN
                                              NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.initial.vox = 1.5;
matlabbatch{1}.spm.tools.dartel.initial.image = 0;
matlabbatch{1}.spm.tools.dartel.initial.GM = 1;
matlabbatch{1}.spm.tools.dartel.initial.WM = 1;
matlabbatch{1}.spm.tools.dartel.initial.CSF = 0;
matlabbatch{2}.spm.tools.dartel.warp.images = {ANATfiles_c1' ANATfiles_c2'};
matlabbatch{2}.spm.tools.dartel.warp.settings.template = 'Template';
matlabbatch{2}.spm.tools.dartel.warp.settings.rform = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).rparam = [4 2 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(1).slam = 16;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).rparam = [2 1 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).K = 0;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(2).slam = 8;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).rparam = [1 0.5 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).K = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(3).slam = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).rparam = [0.5 0.25 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).K = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(4).slam = 2;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).K = 4;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(5).slam = 1;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).its = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).rparam = [0.25 0.125 1e-06];
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).K = 6;
matlabbatch{2}.spm.tools.dartel.warp.settings.param(6).slam = 0.5;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.lmreg = 0.01;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.cyc = 3;
matlabbatch{2}.spm.tools.dartel.warp.settings.optim.its = 3;

% save batch file
savefile = ['dartel_templateCreation',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)
    
clear matlabbatch

for i=2:count-1
    placeholder1 = dir(fullfile(LS{i},'/','*MPRAGE*c1*nii'));
    placeholder2 = dir(fullfile(LS{i},'/','*MPRAGE*c2*nii'));    
    delete(strcat(LS{i},'/',placeholder1.name));
    delete(strcat(LS{i},'/',placeholder2.name));
end