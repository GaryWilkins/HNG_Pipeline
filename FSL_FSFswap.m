function FSL_FSFswap(path)

addpath(path);

% Grab metadata directed by makefile
LS = textread('FSL_TEMP_FILE.txt','%s');

% Assign pertinent variables (strings)
FSF_MasterFile = LS{1};
SubREPLACE = LS{2};
RunREPLACE = LS{3};
SUBJECTS_DIR_1STLEVELANALYSIS = LS{4};
FSFPrefix = LS{5};

% Grab user specified FSF Swap file
MF = textread(FSF_MasterFile,'%s');

for i=1:3:length(MF)
    subj = MF{i};
    run = MF{i+1};
    % Now grab user specified pertinent INIT FSF file
    init_fsf = MF{i+2};
    filename = strcat(FSFPrefix,subj,'_',run,'.fsf');
    newfile = strcat(SUBJECTS_DIR_1STLEVELANALYSIS,'/',filename);
    % Let's get the new file open
    fin = fopen(init_fsf,'r');
    fout = fopen(newfile,'w');
    while ~feof(fin)
        line = fgets(fin); 
        if (isempty(strfind(line,SubREPLACE))==1) && (isempty(strfind(line,RunREPLACE))==1)
            fprintf(fout,'%s',line);
        elseif (isempty(strfind(line,SubREPLACE))==0) || (isempty(strfind(line,RunREPLACE))==0)
            newline = strrep(line,SubREPLACE,subj);
            newline2 = strrep(newline,RunREPLACE,run);
            fprintf(fout,'%s',newline2);
        end
    end
    fclose(fin);
    fclose(fout);    
end