function nuissance_regressors(path)
addpath(path);

LS = textread('SPM_TEMP_SWITCH.txt','%s');

if (strcmp(LS{2},'YES')==0) && (strcmp(LS{3},'YES')==0)
    LS1 = textread('SPM_TEMP_FILE_PAR.txt','%s');
    for h=2:size(LS1)
        %read in the par files
        parfile1 = LS1{h}; %motion parameter file (6 columns 3-mm/3-radians)
        A1 = load(parfile1);

        %generate the temporal derivatives
        %first let's define the step size
        k = 1;

        %now let's allocate space for the temporal derivate matrix
        A2 = zeros(size(A1,1)-1,size(A1,2));

        for i=1:size(A1,2)
            A2(:,i) = diff(A1(:,i))/k;
        end

        %so the table is even, let's pad the temporal derivatives with one 
        %row of zeros
        A2 = [zeros(1,size(A2,2)); A2];

        %now we concatenate all the regressors together to get one large matrix
        A3 = [A1 A2];

        %let's get the name we want to use for the output par file
        [~,filename,~] = fileparts(parfile1);
        %we have to cut one more extension off
        [~,filename,~] = fileparts(filename);
    
        pname = '_all_regs.txt';
        fid = fopen(strcat(filename,pname),'wt');
        for i = 1:size(A3,1)
            fprintf(fid,'%g\t',A3(i,:));
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
elseif (strcmp(LS{2},'YES')==1) && (strcmp(LS{3},'YES')==0)
    LS1 = textread('SPM_TEMP_FILE_PAR.txt','%s');
    LS2 = textread('SPM_TEMP_FILE_MOD.txt','%s');
    for h=2:size(LS1)
        %read in the par files (THERE SHOULD ALWAYS BE A PAR FILE)
        parfile1 = LS1{h}; %motion parameter file (6 columns 3-mm/3-radians)
        %need to check that the motion outlier detection file exists and
        %if not, we'll just substitute a column vecctor of zeros with the
        %same length as the number of time points
        parfile2 = LS2{h}; %motion outlier detection parameter file (we'll concatenate this at the end)
        A1 = load(parfile1);
        try
            A3 = load(parfile2);
        catch
            A3 = zeros(size(A1,1),1);
        end

        %generate the temporal derivatives
        %first let's define the step size
        k = 1;

        %now let's allocate space for the temporal derivate matrix
        A2 = zeros(size(A1,1)-1,size(A1,2));

        for i=1:size(A1,2)
            A2(:,i) = diff(A1(:,i))/k;
        end

        %so the table is even, let's pad the temporal derivatives with one 
        %row of zeros
        A2 = [zeros(1,size(A2,2)); A2];

        %now we concatenate all the regressors together to get one large matrix
        A4 = [A1 A2 A3];

        %let's get the name we want to use for the output par file
        [~,filename,~] = fileparts(parfile1);
        %we have to cut one more extension off
        [~,filename,~] = fileparts(filename);
    
        pname = '_all_regs.txt';
        fid = fopen(strcat(filename,pname),'wt');
        for i = 1:size(A4,1)
            fprintf(fid,'%g\t',A4(i,:));
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
elseif (strcmp(LS{2},'YES')==1) && (strcmp(LS{3},'YES')==1)
    LS1 = textread('SPM_TEMP_FILE_PAR.txt','%s');
    LS2 = textread('SPM_TEMP_FILE_MOD.txt','%s');
    LS3 = textread('SPM_TEMP_FILE_ACOMPCOR.txt','%s');
    for h=2:size(LS1)
        %read in the par files
        parfile1 = LS1{h}; %motion parameter file (6 columns 3-mm/3-radians)
        parfile2 = LS2{h}; %motion outlier detection parameter file (we'll concatenate this at the end)
        parfile3 = LS3{h}; %acompcor parameter file
        A1 = load(parfile1);
        % same logic as before; we just want to make sure that in the
        % absence of any motion outliers, we have a column vecto of zeros
        % to sub in
        try
            A3 = load(parfile2);
        catch
            A3 = zeros(size(A1,1),1);
        end
        A4 = load(parfile3);

        %generate the temporal derivatives
        %first let's define the step size
        k = 1;

        %now let's allocate space for the temporal derivate matrix
        A2 = zeros(size(A1,1)-1,size(A1,2));

        for i=1:size(A1,2)
            A2(:,i) = diff(A1(:,i))/k;
        end

        %so the table is even, let's pad the temporal derivatives with one 
        %row of zeros
        A2 = [zeros(1,size(A2,2)); A2];

        %now we concatenate all the regressors together to get one large matrix
        A5 = [A1 A2 A3 A4];

        %let's get the name we want to use for the output par file
        [~,filename,~] = fileparts(parfile1);
        %we have to cut one more extension off
        [~,filename,~] = fileparts(filename);
    
        pname = '_all_regs.txt';
        fid = fopen(strcat(filename,pname),'wt');
        for i = 1:size(A5,1)
            fprintf(fid,'%g\t',A5(i,:));
            fprintf(fid,'\n');
        end
        fclose(fid);
    end
end

