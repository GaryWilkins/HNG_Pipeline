function First_Level_GLM(path)
%=====================================================================%
%   SPM12
%
%   This script is for use with the UNC HNG Pipeline. It relies on
%   jobs using the SPM12 matlabbatch structure. 
%
%=====================================================================%
addpath(path);
LS = textread('SPM_1stLEVELANALYSIS_FILE.txt','%s');

% Define the condition and run independent variables
OUTPUT_DIRECTORY=LS{2};
TIMING_UNITS=LS{3};
REPETITION_TIME=str2num(LS{4});
MICROTIME_RES=str2num(LS{5});
MICROTIME_ONSET=str2num(LS{6});
VOLTERRA=str2num(LS{9});
GLOBAL_NORM=str2num(LS{10});
MASKING_THRESHOLD=str2num(LS{11});
SERIAL_CORRELATIONS=LS{12};
HIGH_PASS_FILTER=str2num(LS{14});
WRESIDUALS=str2num(LS{15});
TCont_SWITCH=str2num(LS{16});
FCont_SWITCH=str2num(LS{17});
T_condsess_Cont_SWITCH=str2num(LS{18});
DELETE_EXISTING_CONTRASTS_SWITCH=str2num(LS{19});
Contrast_Manager_Spec_File=LS{20};

matlabbatch{1}.spm.stats.fmri_spec.dir = {OUTPUT_DIRECTORY};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = TIMING_UNITS;
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = REPETITION_TIME;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = MICROTIME_RES;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = MICROTIME_ONSET;

matlabbatch{1}.spm.stats.fmri_spec.volt = VOLTERRA;
matlabbatch{1}.spm.stats.fmri_spec.global = GLOBAL_NORM;
matlabbatch{1}.spm.stats.fmri_spec.mthresh = MASKING_THRESHOLD;
matlabbatch{1}.spm.stats.fmri_spec.cvi = SERIAL_CORRELATIONS;

% Specify the directories for the user spec files and the subjects onset
% folder
USER_SPEC_FILES_DIR = LS{7};
SUBJECTS_ONSET_DIR = LS{8};

% This is the directory containing all the preprocessed data for the
% subject in question
SUBJECT_PREPROCESSED_DATA = LS{13};

% We're going to grab all the normalized data in the directory (which will
% need to be unzipped)
SCANS_gz = dir(fullfile(SUBJECT_PREPROCESSED_DATA,'/','*.sm.nii.gz'));
SCANS_length = length(SCANS_gz);
for k=1:SCANS_length
    gunzip(strcat(SUBJECT_PREPROCESSED_DATA,'/',SCANS_gz(k).name));
end

% Here we set up a nested loop in which we cycle through the fmri EPI scans
% while defining the various parameters as they pertain to each condition
SCANS = dir(fullfile(SUBJECT_PREPROCESSED_DATA,'/','*.sm.nii'));
REGRESSOR_FILES = dir(fullfile(SUBJECT_PREPROCESSED_DATA,'/','*_all_regs.txt'));

% We also need to pull the arrays of numbers that correspond to the onset,
% durations, and weights/strengths/etc, but first we need to grab the
% correct subject specific onset file
[~,SUBJECT_ID,~]=fileparts(SUBJECT_PREPROCESSED_DATA);
SUBJECT_ONSET_FILES=dir(fullfile(SUBJECTS_ONSET_DIR,'/',strcat('*',SUBJECT_ID,'*')));
for k=1:SCANS_length
    fmri_img = strcat(SUBJECT_PREPROCESSED_DATA,'/',SCANS(k).name);
    time_length = spm_vol(fmri_img); time_length = length(time_length);
    epi = cell(time_length,1);
    for h=1:time_length
        epi{h} = strcat(SUBJECT_PREPROCESSED_DATA,'/',SCANS(k).name,',',num2str(h));
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).scans = epi;
    % Get data from subject-run specific onset file
    subj_onset_file = strcat(SUBJECTS_ONSET_DIR,'/',SUBJECT_ONSET_FILES(k).name);
    % Set up loop for conditions
    conditions = dir(fullfile(USER_SPEC_FILES_DIR,'/','*.xls*'));
    for g=1:length(conditions)
        cond_unit_file = strcat(USER_SPEC_FILES_DIR,'/',conditions(g).name);
        % Grab time modulator, parametric modulator, orthogonal control,
        % and high pass filter value from conditional user spec file
        [num,txt,raw2] = xlsread(cond_unit_file);
        [~,~,onsets,durations,strengths]=onset_maker(subj_onset_file,cond_unit_file,SUBJECT_PREPROCESSED_DATA,'SPM');
        time_mod = raw2{2,1}; para_mod = raw2{3,1}; weights_col = raw2{1,3}; ortho = raw2{4,1};
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).name = conditions(g).name;
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).onset = cell2mat(onsets);
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).duration = cell2mat(durations);
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).tmod = time_mod;
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).pmod = struct('name', {weights_col}, 'param', {cell2mat(strengths)}, 'poly', {para_mod});
        matlabbatch{1}.spm.stats.fmri_spec.sess(k).cond(g).orth = ortho;
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).regress = struct('name', {}, 'val', {});
    % select/load regressor file pertaining to particular scan
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).multi_reg = {strcat(SUBJECT_PREPROCESSED_DATA,'/',REGRESSOR_FILES(k).name)};
    matlabbatch{1}.spm.stats.fmri_spec.sess(k).hpf = HIGH_PASS_FILTER;
end

if exist('SPM_FACTORIAL_DESIGN_FILE.txt')==2
    LS_FACT = textread('SPM_FACTORIAL_DESIGN_FILE.txt','%s');
    Factorial_Design_Name = LS_FACT{2};
    Factorial_Design_Levels = LS_FACT{3};
    matlabbatch{1}.spm.stats.fmri_spec.fact.name = Factorial_Design_Name;
    matlabbatch{1}.spm.stats.fmri_spec.fact.levels = Factorial_Design_Levels;
else
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
end

if exist('SPM_BASIS_FUNCTION_FILE.txt')==2
    LS_BASIS = textread('SPM_BASIS_FUNCTION_FILE.txt','%s');
    BASIS_SWITCH = LS_BASIS{2};
    if strcmp(BASIS_SWITCH,'CHRF')
        MODEL_DERIVa = str2num(LS_BASIS{3});
        MODEL_DERIVb = str2num(LS_BASIS{4});
        MODEL_DERIV = [MODEL_DERIVa MODEL_DERIVb];
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = MODEL_DERIV;
    elseif strcmp(BASIS_SWITCH,'FS')
        WINDOW = str2num(LS_BASIS{3}); BF_ORDER = str2num(LS_BASIS{4});
        matlabbatch{1}.spm.stats.fmri_spec.bases.fourier.length = WINDOW;
        matlabbatch{1}.spm.stats.fmri_spec.bases.fourier.order = BF_ORDER;
    elseif strcmp(BASIS_SWITCH,'FSH')
        WINDOW = str2num(LS_BASIS{3}); BF_ORDER = str2num(LS_BASIS{4});
        matlabbatch{1}.spm.stats.fmri_spec.bases.fourier_han.length = WINDOW;
        matlabbatch{1}.spm.stats.fmri_spec.bases.fourier_han.order = BF_ORDER;    
    elseif strcmp(BASIS_SWITCH,'GF')
        WINDOW = str2num(LS_BASIS{3}); BF_ORDER = str2num(LS_BASIS{4});
        matlabbatch{1}.spm.stats.fmri_spec.bases.gamma.length = WINDOW;
        matlabbatch{1}.spm.stats.fmri_spec.bases.gamma.order = BF_ORDER;
    elseif strcmp(BASIS_SWITCH,'FIR')
        WINDOW = str2num(LS_BASIS{3}); BF_ORDER = str2num(LS_BASIS{4});
        matlabbatch{1}.spm.stats.fmri_spec.bases.fir.length = WINDOW;
        matlabbatch{1}.spm.stats.fmri_spec.bases.fir.order = BF_ORDER;
    end
else
    matlabbatch{1}.spm.stats.fmri_spec.bases.none = true;
end

if exist('SPM_MASK_FILE.txt')==2
    LS_Mask = textread('SPM_MASK_FILE.txt','%s');
    matlabbatch{1}.spm.stats.fmri_spec.mask = LS_Mask{2};
end

% save batch file
savefile = ['SPM_',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)

clear matlabbatch

% set design matrix file and location
SPM_mat = strcat(OUTPUT_DIRECTORY,'/','SPM.mat');
matlabbatch{1}.spm.stats.fmri_est.spmmat = {SPM_mat};

% write residuals?
if WRESIDUALS==1
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
else
    matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
end

matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;

% save batch file
savefile = ['Estimate_',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)

clear matlabbatch

%where's the SPM file of interest
matlabbatch{1}.spm.stats.con.spmmat = {SPM_mat};

%get contrast manager spec file
[~,~,specs] = xlsread(Contrast_Manager_Spec_File);

%assign potential cell columns to T, F, and/or T-cond/sess
try
    TCONTS = specs(:,1); 
catch
    TCONTS = {0};
end
try
    FCONTS = specs(:,2); 
catch
    FCONTS = {0};
end
try
    TCOND_CONTS = specs(:,3);
catch
    TCOND_CONTS = {0};
end

%we're going to get rid of any empty cells; this will depend on the
%end-user having set up the Contrast Manager Spec file correctly
TCONTS(cellfun(@(TCONTS) any(isnan(TCONTS)),TCONTS))=[];
FCONTS(cellfun(@(FCONTS) any(isnan(FCONTS)),FCONTS))=[];
TCOND_CONTS(cellfun(@(TCOND_CONTS) any(isnan(TCOND_CONTS)),TCOND_CONTS))=[];

%now we're going to get the lengths of each
TCONTS_LEN = length(TCONTS); %should be divisible by 3
FCONTS_LEN = length(FCONTS); %should be divisible by 3
TCOND_CONTS_LEN = length(TCOND_CONTS); %should be divisible by 6

%what and which contrasts? (T, F, T-cond/sess)

if TCont_SWITCH==1
    a = 1;
    for i=1:3:TCONTS_LEN
        matlabbatch{1}.spm.stats.con.consess{a}.tcon.name = TCONTS{i};
        matlabbatch{1}.spm.stats.con.consess{a}.tcon.weights = str2num(TCONTS{i+1});
        matlabbatch{1}.spm.stats.con.consess{a}.tcon.sessrep = TCONTS{i+2};
        a=a+1;
    end
end
if FCont_SWITCH==1
    b = 1;
    for j=1:3:FCONTS_LEN
        matlabbatch{1}.spm.stats.con.consess{b}.fcon.name = FCONTS{j};
        matlabbatch{1}.spm.stats.con.consess{b}.fcon.weights = str2num(FCONTS{j+1});
        matlabbatch{1}.spm.stats.con.consess{b}.fcon.sessrep = FCONTS{j+2};
        b=b+1;
    end
end
if T_condsess_Cont_SWITCH==1
    c = 1;
    for k=1:6:TCOND_CONTS_LEN
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.name = TCOND_CONTS{k};
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.coltype.colconds.conweight = str2num(TCOND_CONTS{k+1});
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.coltype.colconds.colcond = str2num(TCOND_CONTS{k+2});
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.coltype.colconds.colbf = str2num(TCOND_CONTS{k+3});
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.coltype.colconds.colmod = str2num(TCOND_CONTS{k+4});
        matlabbatch{1}.spm.stats.con.consess{c}.tconsess.coltype.colconds.colmodord = str2num(TCOND_CONTS{k+5});
        c=c+1;
    end
end

%whether or not to delete existing contrasts
matlabbatch{1}.spm.stats.con.delete = DELETE_EXISTING_CONTRASTS_SWITCH;

% save batch file
savefile = ['Contrasts_',1];
save(savefile,'matlabbatch')

% run batch
spm_jobman('run',matlabbatch)

clear matlabbatch