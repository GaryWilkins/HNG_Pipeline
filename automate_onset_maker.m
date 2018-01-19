function automate_onset_maker(regressor_dir,userspecfile_dir,report_output_dir)


% We are going to create some structure arrays (and from those cells) of our specified directories
regressor_dir_list = struct2cell(dir(regressor_dir));
userspecfile_list = struct2cell(dir(userspecfile_dir));

if ~exist(report_output_dir,'dir')
    mkdir(report_output_dir);
end

% Now we're going to pull just the filenames (which should be only xcell
% files after all, there's no quality control yet at this point
regressor_files = regressor_dir_list(1,1:end);
userspecfile_files = userspecfile_list(1,1:end);

% Find index of first file in regressor and user spec file lists
reg_index = 0; userspec_index = 0;
for i=1:length(regressor_files)
    placeholder=regressor_files{i};
    if isempty(strfind(placeholder,'xlsx'))==1
        reg_index = reg_index+1;
    else
        reg_index = reg_index+1;
        break
    end
end
for i=1:length(userspecfile_files)
    placeholder=userspecfile_files{i};
    if isempty(strfind(placeholder,'xlsx'))==1
        userspec_index = userspec_index+1;
    else
        userspec_index = userspec_index+1;
        break
    end
end
% let's create a variable that will be used only once, when an error has
% resulted from running the script. we're going to want to produce a
% header, but only once
error_head=0; event_head=0;
for i=reg_index:length(regressor_files)
    for j=userspec_index:length(userspecfile_files)
        regressor_fil = strcat(regressor_dir,'/',regressor_files{i});
        userspecfile_fil = strcat(userspecfile_dir,'/',userspecfile_files{j});
        try
            [num_entry,onset_name,~,~,~]=onset_maker(regressor_fil,userspecfile_fil,report_output_dir,'FSL');
            disp(strcat('Regressor File Index ',num2str(i),' User Spec Files Index ',num2str(j)))
            if event_head==0
                events_file = strcat('Events_Log','.txt');
                fid0 = fopen(events_file,'wt');
                header0 = 'Onset Events Log: How Many Records Satisfied User Spec Conditionals';
                fprintf(fid0, '%s\n',header0);
                event_head = event_head+1;
            end
            fprintf(fid0,'%s\t\t %d\t\n',onset_name,num_entry);
        catch
            error_head = error_head+1;
            if error_head==1
                errfile = strcat('Onset_Errors','.txt');
                fid = fopen(errfile,'wt');
                header = 'Onset Errors: Subject and Regressor file combinations that resulted in an error';
                header_1 = 'Regressor Files'; header_2 = 'User Spec Files';
                fprintf(fid, '%s\n',header);
                fprintf(fid, '%s\t %s\t\n',header_1,header_2);
            end
            fprintf(fid, '%s\t %s\t\n',regressor_fil,userspecfile_fil);
        end
    end
end

if exist('Onset_Errors.txt','file')
    movefile('Onset_Errors.txt',report_output_dir);
end

if exist('Events_Log.txt','file')
    movefile('Events_Log.txt',report_output_dir);
end

fclose(fid0);
