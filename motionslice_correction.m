function motionslice_correction(path)

addpath(path);
LS = textread('MC_MAT_TEMP_FILE.txt','%s');

Line0 = 'include $(PROJECT_HOME_local)/$(CONTROL_PANEL)';
Line1 = 'all:';
Line2 = 'module add python/3.5.1';
Line3 = '$(PIPELINE_HOME)/4dRegister2.py ';
Line4 = '--slice_order ';
Line5 = '--save_params True';
END = ';\';

%the number of LS elements should be even as there should be the functional
%file and right next to it should be the lower quality structural file

if strcmp(LS{3},'ascending')
    slice_order = 'ascending' ;
elseif strcmp(LS{3},'descending')
	slice_order = 'descending' ;
elseif strcmp(LS{3},'alternating_increasing_2')
    slice_order = 'asc_alt_2' ;
elseif strcmp(LS{3},'alternating_increasing_2_1')
    slice_order = 'asc_alt_2_1' ;
elseif strcmp(LS{3},'alternating_decreasing_2')
	slice_order = 'desc_alt_2' ;
elseif strcmp(LS{3},'alternating_ascending_siemens')
	slice_order = 'asc_alt_siemens' ;
elseif strcmp(LS{3},'alternating_ascending_half')
	slice_order = 'asc_alt_half' ;
elseif strcmp(LS{3},'alternating_descending_half')
	slice_order = 'desc_alt_half' ;
end

makefile = 'TEMP_MAKEFILE';
fid = fopen(strcat(makefile,'.mk'),'wt');
fprintf(fid, '%s\n',Line0);
fprintf(fid, '%s\n',Line1);
fprintf(fid, '\t%s %s\n',Line2,END);
fprintf(fid, '\t%s %s %s %s %s %s %s %s %s',Line3,LS{1},LS{2},Line4,slice_order,Line5,END);
fclose(fid);

