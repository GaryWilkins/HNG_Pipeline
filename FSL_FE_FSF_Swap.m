function FSL_FE_FSF_Swap(path)

addpath(path);

% Grab metadata directed by makefile
LS = textread('FSL_TEMP_FILE.txt','%s');

% Assign pertinent variables (strings)
FE_FSF_MasterFile = LS{1};
SubREPLACE = LS{2};
SUBJECTS_DIR_1STLEVELANALYSIS = LS{3};
FSFPrefix = LS{4};

% Grab user specified FSF Swap file
MF = textread(FE_FSF_MasterFile,'%s');

for i=1:2:length(MF)
    subj = MF{i};
    % Now grab user specified pertinent INIT FSF file
    init_fsf = MF{i+1};
    filename = strcat(FSFPrefix,'_FE',subj,'.fsf');
    newfile = strcat(SUBJECTS_DIR_1STLEVELANALYSIS,'/',filename);
    % Let's get the new file open
    fin = fopen(init_fsf,'r');
    fout = fopen(newfile,'w');
    while ~feof(fin)
        line = fgets(fin); 
        if (isempty(strfind(line,SubREPLACE))==1)
            fprintf(fout,'%s',line);
        elseif (isempty(strfind(line,SubREPLACE))==0)
            newline = strrep(line,SubREPLACE,subj);
            fprintf(fout,'%s',newline);
        end
    end
    fclose(fin);
    fclose(fout);    
end