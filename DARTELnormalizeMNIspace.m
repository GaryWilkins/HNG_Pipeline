function DARTELnormalizeMNIspace(path)

addpath(path);
LS = textread('SPM_DARTEL_TEMP_FILE.txt','%s');

count = 2;
while strcmp(LS{count},'STOP')~=1
    count = count+1;
end

Template = strcat(LS{2},'/','Template_6.nii');

matlabbatch{1}.spm.tools.dartel.mni_norm.template = {Template};
for i=2:count-1
    placeholder1 = dir(fullfile(LS{i},'/','u*MPRAGE*Template.nii'));
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i-1).flowfield = {strcat(LS{i},'/',placeholder1.name)};
    placeholder2 = dir(fullfile(LS{i},'/','*.cr.nii.gz'));
    for j=1:length(placeholder2)
        gunzip(strcat(LS{i},'/',placeholder2(j).name));
    end
    placeholder2 = dir(fullfile(LS{i},'/','*.cr.nii'));
    placeholder3 = cell(1,length(placeholder2));
    for j=1:length(placeholder2)
        placeholder3{j} = strcat(LS{i},'/',placeholder2(j).name);
    end
    matlabbatch{1}.spm.tools.dartel.mni_norm.data.subj(i-1).images = placeholder3';
end

matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [-175 -175 -175
                                               175 175 175];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 0;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [4 4 4];

% save batch file
savefile = ['dartel_normMNIspace',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)

for i=2:count-1
    placeholder1 = dir(fullfile(LS{i},'/','u*MPRAGE*Template.nii'));
    gzip(strcat(LS{i},'/',placeholder1.name));
    delete(strcat(LS{i},'/',placeholder1.name));
    placeholder2 = dir(fullfile(LS{i},'/','sw*.cr.nii'));   
    for j=1:length(placeholder2)
        % get rid of the left over unzipped files but grab the functs name
        % parts
        [file_path,file_name,ext] = fileparts(strcat(LS{i},'/',placeholder2(j).name));
        file_name = strtok(file_name,'sw');
        delete(strcat(file_path,'/',file_name,ext));
        % change the name over
        name_old = strcat(file_path,'/sw',file_name,ext);
        name_new = strcat(file_path,'/',file_name,'.no.nii');
        movefile(name_old,name_new);
        gzip(name_new);
        delete(name_new);
    end
end

clear matlabbatch

gzip(strcat(LS{2},'/','Template_6.nii'));
delete(strcat(LS{2},'/','Template_6.nii'));
gzip(strcat(LS{2},'/','Template_5.nii'));
delete(strcat(LS{2},'/','Template_5.nii'));
gzip(strcat(LS{2},'/','Template_4.nii'));
delete(strcat(LS{2},'/','Template_4.nii'));
gzip(strcat(LS{2},'/','Template_3.nii'));
delete(strcat(LS{2},'/','Template_3.nii'));
gzip(strcat(LS{2},'/','Template_2.nii'));
delete(strcat(LS{2},'/','Template_2.nii'));
gzip(strcat(LS{2},'/','Template_1.nii'));
delete(strcat(LS{2},'/','Template_1.nii'));
gzip(strcat(LS{2},'/','Template_0.nii'));
delete(strcat(LS{2},'/','Template_0.nii'));
