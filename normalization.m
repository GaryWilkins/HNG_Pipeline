function normalization(path)

addpath(path);
LS = textread('SPM_TEMP_FILE.txt','%s');

clear matlabbatch

anatomical = gunzip(LS{2});
for i=3:size(LS,1)
    functional = gunzip(LS{i});
    % determine how many time points there are
    time_length = spm_vol(functional); time_length = length(time_length{1});   
    
    % anatomical data
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = strcat(anatomical,',1');

    % specify the files that you want to apply the transformation to
    normalise_estwrite_subj_resample = cell(time_length,1);
    for r=1:time_length
        normalise_estwrite_subj_resample(r) = strcat(functional,',',num2str(r));
    end
    matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = normalise_estwrite_subj_resample;
    
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;

    % should be the template space
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/nas/longleaf/apps/spm/12/spm12/tpm/TPM.nii'};
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
    matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
    matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';

    % save batch file
    savefile = ['norm_',1];
    save(savefile,'matlabbatch')

    % run batch
    spm_jobman('run',matlabbatch)
    
    % let's rename and rezip for standardization purposes
    [file_path,file_name,~] = fileparts(LS{i});
    name_old = strcat(file_path,'/w',file_name);
    delete(strcat(file_path,'/',file_name));
    [~,file_name,~] = fileparts(file_name);
    name_new = strcat(file_path,'/',file_name,'.no.nii');
    movefile(name_old,name_new);
    gzip(name_new);
    delete(name_new);
    clear matlabbatch
end
gzip(anatomical);
mat_work = strcat(pwd,'/norm_?.mat');
delete(mat_work);
