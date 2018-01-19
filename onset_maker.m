function [num_entries,name,onsets,durationsc,rtcs] = onset_maker(filename,userspecfile,report_output_dir,fMRI_switch)
%The purpose of this regressor extraction tool is to do what the name of
%the tool suggests: extract regressors. In order for the tool to do so
%reliabily, there are certain expectations and assumptions that must be
%met. The regressor extractor is expecting an excel file. 

if strcmp(fMRI_switch,'FSL')

    % Let's create the report name from the filename and the userspecfile
    [~,name_1,~] = fileparts(filename);
    [~,name_2,~] = fileparts(userspecfile);
    name = strcat(report_output_dir,'/',name_1,'_',name_2);

    % Get regressor input file
    [num,txt,raw] = xlsread(filename);

    % How many categories are there
    num_cats = size(raw,2);
    % Get categories
    cats = raw(1,:);

    % Get user specified file
    [num2,txt2,raw2] = xlsread(userspecfile); 

    % Get onset column, duration column ,weights column
    onset_col = raw2{1,1};
    duration_col = raw2{1,2};
    weights_col = raw2{1,3};
    % How many categories of interest
    constrict=0;
    for i=1:size(raw2,2) 
        placeholder = raw2{1,i};
        if isnan(placeholder)~=1
            constrict=constrict+1;
        else
            break
        end
    end
    num_cats_ROI = constrict-3; %accounting for # of columns chiefly used to designate what columns you want to take from after it's all said and done
    % Get categories of interest
    catsROI = raw2(1,4:end); catsROI = catsROI';
    % Allocate space for "values of categories of interest" cell
    values = cell(num_cats_ROI,1);

    % Populate the values cell with the values the user specified
    % The point of this piece of the loop is to figure out how many values
    % there are 
    for i=1:num_cats_ROI
        j=1;
        while j < size(raw2,1)
            % Skip 1st row since the first row is only titles
            placeholder = raw2{j+1,i+3}; % Also skip 1st 3 columns as they're only the onset, duration, and weights columns
            % Let's go ahead and convert NaNs to 0
            placeholder(isnan(placeholder))=1000000;
            if placeholder ~= 1000000
                j=j+1;
            else
                break
            end
        end
        % We now have the length of the non-zero/non-NaN values
        placeholder2 = cell(j-1,1);
        placeholder2(1:j-1) = raw2(2:j,i+3);
        values{i}=placeholder2;
    end

    % Now we wish to filter out the rows that don't match essentially the
    % user's specified filter, i.e. matching category ROIs and corresponding
    % values

    % Get indices of categories
    catsIndices = zeros(num_cats_ROI,1);
    for k=1:num_cats_ROI
        placeholder = catsROI{k};
        for j=1:size(raw,2)
            placeholder2 = raw{1,j};
            if isequal(placeholder,placeholder2)==1
                catsIndices(k)=j;
                break
            end
        end
    end

    % What rows match the values corresponding to each catsROI
    valsIndices = cell(num_cats_ROI,1);
    for i=1:num_cats_ROI
        placeholder = raw(2:end,catsIndices(i)); %raw data column
        placeholder2 = values{i}; 
        l=1;
        for j=1:size(placeholder2,1)
            placeholder3 = placeholder2{j};
            for k=1:size(placeholder,1)
                if isequal(placeholder{k},placeholder3)==1
                    placeholder4(l)=k;
                    l=l+1;
                end
            end
        end
        valsIndices{i} = unique(placeholder4);
    end

    for i=1:num_cats_ROI-1
        placeholder = valsIndices{i};
        placeholder2 = valsIndices{i+1};
         valsIndices{i+1} = intersect(placeholder,placeholder2);
    end

    final_indices = valsIndices{num_cats_ROI};
    for i=1:size(final_indices,2)
        final_indices(i)=final_indices(i)+1;
    end

    filtered_data = raw(final_indices,:);

    standouts = zeros(3,1);

    % Next pick onset column
    l=1;
    for i=1:size(cats,2)
        if isequal(onset_col,cats{i})==1
            standouts(l)=i;
            l=l+1;
            break
        end
    end
    for i=1:size(cats,2)
        if isequal(duration_col,cats{i})==1
            standouts(l)=i;
            l=l+1;
            break
        end
    end
    for i=1:size(cats,2)
        if isequal(weights_col,cats{i})==1
            standouts(l)=i;
            break
        end
    end

    onsets = filtered_data(:,standouts(1));
    durationsc = filtered_data(:,standouts(2));
    rtcs = filtered_data(:,standouts(3));

    name = strcat(name,'.txt');
    fid = fopen(name,'wt');
    num_entries = length(final_indices);
    for i=1:length(final_indices)-1
        onsetsc = onsets{i};
        durationscs = durationsc{i};
        rtc = rtcs{i};
        fprintf(fid, '%.3f\t %.3f\t %.3f\t\n',onsetsc,durationscs,rtc);
    end
    onsetsc = onsets{length(final_indices)};
    durationscs = durationsc{length(final_indices)};
    rtc = rtcs{length(final_indices)};
    fprintf(fid, '%.3f\t %.3f\t %.3f\t',onsetsc,durationscs,rtc);
    fclose(fid);
    
elseif strcmp(fMRI_switch,'SPM')

    % Get regressor input file
    [num,txt,raw] = xlsread(filename);

    % How many categories are there
    num_cats = size(raw,2);
    % Get categories
    cats = raw(1,:);

    % Get user specified file
    [num2,txt2,raw2] = xlsread(userspecfile); 

    % Get onset column, duration column ,weights column
    onset_col = raw2{1,1};
    duration_col = raw2{1,2};
    weights_col = raw2{1,3};
    % How many categories of interest
    constrict=0;
    for i=1:size(raw2,2) 
        placeholder = raw2{1,i};
        if isnan(placeholder)~=1
            constrict=constrict+1;
        else
            break
        end
    end
    num_cats_ROI = constrict-3; %accounting for # of columns chiefly used to designate what columns you want to take from after it's all said and done
    % Get categories of interest
    catsROI = raw2(1,4:end); catsROI = catsROI';
    % Allocate space for "values of categories of interest" cell
    values = cell(num_cats_ROI,1);

    % Populate the values cell with the values the user specified
    % The point of this piece of the loop is to figure out how many values
    % there are 
    for i=1:num_cats_ROI
        j=1;
        while j < size(raw2,1)
            % Skip 1st row since the first row is only titles
            placeholder = raw2{j+1,i+3}; % Also skip 1st 3 columns as they're only the onset, duration, and weights columns
            % Let's go ahead and convert NaNs to 0
            placeholder(isnan(placeholder))=1000000;
            if placeholder ~= 1000000
                j=j+1;
            else
                break
            end
        end
        % We now have the length of the non-zero/non-NaN values
        placeholder2 = cell(j-1,1);
        placeholder2(1:j-1) = raw2(2:j,i+3);
        values{i}=placeholder2;
    end

    % Now we wish to filter out the rows that don't match essentially the
    % user's specified filter, i.e. matching category ROIs and corresponding
    % values

    % Get indices of categories
    catsIndices = zeros(num_cats_ROI,1);
    for k=1:num_cats_ROI
        placeholder = catsROI{k};
        for j=1:size(raw,2)
            placeholder2 = raw{1,j};
            if isequal(placeholder,placeholder2)==1
                catsIndices(k)=j;
                break
            end
        end
    end

    % What rows match the values corresponding to each catsROI
    valsIndices = cell(num_cats_ROI,1);
    for i=1:num_cats_ROI
        placeholder = raw(2:end,catsIndices(i)); %raw data column
        placeholder2 = values{i}; 
        l=1;
        for j=1:size(placeholder2,1)
            placeholder3 = placeholder2{j};
            for k=1:size(placeholder,1)
                if isequal(placeholder{k},placeholder3)==1
                    placeholder4(l)=k;
                    l=l+1;
                end
            end
        end
        valsIndices{i} = unique(placeholder4);
    end

    for i=1:num_cats_ROI-1
        placeholder = valsIndices{i};
        placeholder2 = valsIndices{i+1};
        valsIndices{i+1} = intersect(placeholder,placeholder2);
    end

    final_indices = valsIndices{num_cats_ROI};
    for i=1:size(final_indices,2)
        final_indices(i)=final_indices(i)+1;
    end

    filtered_data = raw(final_indices,:);

    standouts = zeros(3,1);

    % Next pick onset column
    l=1;
    for i=1:size(cats,2)
        if isequal(onset_col,cats{i})==1
            standouts(l)=i;
            l=l+1;
            break
        end
    end
    for i=1:size(cats,2)
        if isequal(duration_col,cats{i})==1
            standouts(l)=i;
            l=l+1;
            break
        end
    end
    for i=1:size(cats,2)
        if isequal(weights_col,cats{i})==1
            standouts(l)=i;
            break
        end
    end
    
    num_entries = 0;
    name = 0;
    onsets = filtered_data(:,standouts(1));
    durationsc = filtered_data(:,standouts(2));
    rtcs = filtered_data(:,standouts(3));
    
end