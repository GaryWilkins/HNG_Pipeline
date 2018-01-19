function coregister(path)

addpath(path);
LS = textread('SPM_TEMP_FILE.txt','%s');
LS2 = textread('SPM_TEMP_FILE2.txt','%s');

clear matlabbatch

anatomical = gunzip(LS2{2});
[file_path_struct,structural,~] = fileparts(LS2{2});

for i=2:size(LS,1)
    % here anatomical image is co-registered to functional image
    functional = gunzip(LS{i});
    [file_path_func,file_name_func,~] = fileparts(LS{i});    
    % Now we need to find the right structural file. 
    % The following is to determine whether or not we're doing a two-pass
    % or a one-pass, i.e. coregistration of functionals to one structural
    % file or coregistration of functionals to a minor structural file and
    % then re-coregistration of the product to the major structural file
    % (opposite of respectively)
    if exist('secondary_coregistrations.txt', 'file')==2
        LS3 = textread('secondary_coregistrations.txt','%s'); % we put this here because it may not exist
        % We're making sure that the subject #, the path generally, of the
        % minor and major structural files match that of the functional [THERE SHOULD BE
        % ONLY 1]
        for j=1:2:size(LS3,1)
            [~,temp_name,~] = fileparts(LS3{j});
            if strcmp(file_name_func,temp_name)==1
                [file_path_lilstruct,lilstructural,~] = fileparts(LS3{j+1});
                anatomical2 = gunzip(LS3{j+1});
                break
            end
        end        
        %-----------------------FIRST PASS
        % determine how many time points there are
        time_length = spm_vol(functional); time_length = length(time_length{1})-1;        
        % specify reference file, the file you want to co-register other files to 
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = strcat(file_path_struct,'/',anatomical2,',1');
        % specify the file that will be transformed to match the reference
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = strcat(file_path_func,'/',functional,',1');
        
        % specify the files that you want to apply the transformation to
        coreg_estwrite_other = cell(time_length,1);
        for r=1:time_length
            coreg_estwrite_other(r) = strcat(file_path_func,'/',functional,',',num2str(r+1));
        end
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = coreg_estwrite_other;

        % matlabbatch{1} options
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r_int';

        % save batch file
        savefile = ['coreg_2',1];
        save(savefile,'matlabbatch')

        % run batch
        spm_jobman('run',matlabbatch)
        
        clear matlabbatch
        
        % let's rename and rezip for standardization purposes
        name_old_int = strcat(file_path_func,'/r_int',file_name_func);
        gzip(name_old_int);
        name_old_int = strcat(file_path_func,'/r_int',file_name_func,'.gz');
        
        %-----------------------SECOND PASS
        functional2 = gunzip(name_old_int);
        % determine how many time points there are
        time_length = spm_vol(functional); time_length = length(time_length{1})-1;
        % specify reference file, the file you want to co-register other files to 
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = strcat(file_path_struct,'/',anatomical,',1');
        % specify the file that will be transformed to match the reference
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = strcat(file_path_func,'/',functional2,',1');
        
        % specify the files that you want to apply the transformation to
        coreg_estwrite_other = cell(time_length,1);
        for r=1:time_length
            coreg_estwrite_other(r) = strcat(file_path_func,'/',functional2,',',num2str(r+1));
        end
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = coreg_estwrite_other;

        % matlabbatch{1} options
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

        % save batch file
        savefile = ['coreg_',1];
        save(savefile,'matlabbatch')

        % run batch
        spm_jobman('run',matlabbatch)
        
        % change name of the file
        name_fin_image = strcat(file_path_func,'/rr_int',file_name_func);
        [~,stripped_to_mc,n_ext] = fileparts(file_name_func);
        new_name = strcat(file_path_func,'/',stripped_to_mc,'.cr',n_ext);
        movefile(name_fin_image,new_name);
        gzip(new_name);
        delete(new_name); % should get rid of the non-zipped nifty file
        delete(strcat(file_path_func,'/',file_name_func));   
        delete(strcat(file_path_lilstruct,'/',lilstructural));
        
        clear matlabbatch
    else
        % determine how many time points there are
        time_length = spm_vol(functional); time_length = length(time_length{1})-1;
        % specify reference file, the file you want to co-register other files to 
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = strcat(file_path_struct,'/',anatomical,',1');
        % specify the file that will be transformed to match the reference
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = strcat(file_path_func,'/',functional,',1');
        
        % specify the files that you want to apply the transformation to
        coreg_estwrite_other = cell(time_length,1);
        for r=1:time_length
            coreg_estwrite_other(r) = strcat(file_path_func,'/',functional,',',num2str(r+1));
        end
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = coreg_estwrite_other;

        % matlabbatch{1} options
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';

        % save batch file
        savefile = ['coreg_',1];
        save(savefile,'matlabbatch')

        % run batch
        spm_jobman('run',matlabbatch)
        
        % change name of the file
        old_name = strcat(file_path_func,'/r',file_name_func);
        [~,stripped_to_mc,n_ext] = fileparts(file_name_func);
        new_name = strcat(file_path_func,'/',stripped_to_mc,'.cr',n_ext);
        movefile(old_name,new_name);
        gzip(new_name);
        delete(new_name);        
        delete(strcat(file_path_func,'/',file_name_func));
        clear matlabbatch
    end
end
delete(strcat(file_path_struct,'/',structural));