!/bin/bash -x

#For acc:
#cd /afs/cas.unc.edu/depts/psychology/mabsher/projects/YES/rawdata/

#For longleaf:
cd /proj/hng/sheridanlab/projects/YES/rawdata/

#This script needs to be edited to read *ABCDsaveRMSs016* for 5093 & 5113 and *ABCDsaveRMSs009* for 5032, 5091 & 5080

#subjectlist=`ls -d 5*`

#for i in ${subjectlist}
##if you just want to run a few subjects, # out the two lines above and then use this one: 
for i in 5073 5079 5065 5064 5063 5060 5059 5057 5054 5044 5083

do 

	echo "working on $i"
	cd $i
	echo "in $i"
	#cd 2*
	pwd
	#cp *ABCDsaveRMSs007*.nii.gz ../
	#cd ../
	#pwd	
	mv *ABCDsaveRMSs007*.nii.gz ${i}_MPRAGE.nii.gz	
	cp ${i}_MPRAGE.nii.gz ../../EMOREG/$i
	cp ${i}_MPRAGE.nii.gz ../../SOC_REJ/$i
	cp ${i}_MPRAGE.nii.gz ../../CARIT/$i
	cp ${i}_MPRAGE.nii.gz ../../REST/$i
	echo "done $i"
	cd ../

done



