function smoothing(path)

addpath(path);
LS = textread('SPM_TEMP_FILE.txt','%s');
LS2 = textread('SPM_MINOR_TEMP_FILE.txt','%s');
FWHM = str2num(LS2{1});

clear matlabbatch
for i=2:size(LS,1)
    functional = gunzip(LS{i});

    % determine how many time points there are
    time_length = spm_vol(functional); time_length = length(time_length{1}); 
    
    % specify the files that you want to apply the transformation to
    smoothing_data = cell(time_length,1);
    for r=1:time_length
        smoothing_data(r) = strcat(functional,',',num2str(r));
    end
    
    matlabbatch{1}.spm.spatial.smooth.data = smoothing_data;
    matlabbatch{1}.spm.spatial.smooth.fwhm = [FWHM FWHM FWHM];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';

    % save batch file
    savefile = ['smoot_',1];
    save(savefile,'matlabbatch')

    % run batch
    spm_jobman('run',matlabbatch)
    
    % let's rename and rezip for standardization purposes
    [file_path,file_name,~] = fileparts(LS{i});
    delete(strcat(file_path,'/',file_name));
    name_old = strcat(file_path,'/','s',file_name);
    [~,file_name,~] = fileparts(file_name);
    name_new = strcat(file_path,'/',file_name,'.sm.nii');
    movefile(name_old,name_new);
    gzip(name_new);
    delete(name_new);
    clear matlabbatch
end
delete(strcat(pwd,'smoot_?.mat'));
    