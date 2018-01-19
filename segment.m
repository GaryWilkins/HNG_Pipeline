function segment(path)

addpath(path);
LS = textread('SPM_TEMP_FILE.txt','%s');

clear matlabbatch

anatomical = gunzip(LS{2});

matlabbatch{1}.spm.spatial.preproc.channel.vols = strcat(anatomical,',1');
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];

% save batch file
savefile = ['segm',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)
    
% let's rename and rezip for standardization purposes
[file_path,file_name,~] = fileparts(LS{2});

% strip off '.nii'
[~,file_name,~] = fileparts(file_name);
name_old_c1 = strcat(file_path,'/','c1',file_name,'.nii');
name_new_c1 = strcat(file_path,'/',file_name,'.c1.nii');
movefile(name_old_c1,name_new_c1);
gzip(name_new_c1); delete(name_new_c1);
name_old_c2 = strcat(file_path,'/','c2',file_name,'.nii');
name_new_c2 = strcat(file_path,'/',file_name,'.c2.nii');
movefile(name_old_c2,name_new_c2);
gzip(name_new_c2); delete(name_new_c2);
name_old_c3 = strcat(file_path,'/','c3',file_name,'.nii');
name_new_c3 = strcat(file_path,'/',file_name,'.c3.nii');
movefile(name_old_c3,name_new_c3);
gzip(name_new_c3); delete(name_new_c3);
name_old_c4 = strcat(file_path,'/','c4',file_name,'.nii');
name_new_c4 = strcat(file_path,'/',file_name,'.c4.nii');
movefile(name_old_c4,name_new_c4);
gzip(name_new_c4); delete(name_new_c4);
name_old_c5 = strcat(file_path,'/','c5',file_name,'.nii');
name_new_c5 = strcat(file_path,'/',file_name,'.c5.nii');
movefile(name_old_c5,name_new_c5);
gzip(name_new_c5); delete(name_new_c5);
    
delete(strcat(file_path,'/',file_name,'.nii'));
    
clear matlabbatch