!/bin/bash -x

#For acc:
#cd /afs/cas.unc.edu/depts/psychology/mabsher/projects/YES/EMOREG

#For longleaf:
cd /proj/hng/sheridanlab/projects/YES/EMOREG

subjectlist=`ls -d 5*`

for i in ${subjectlist}

do 

	cd $i
	echo "in $i"
	pwd
	mv *emoreg1* emoreg1.nii.gz	
	mv *emoreg2* emoreg2.nii.gz
	mv *emoreg3* emoreg3.nii.gz
	mv *emoreg4* emoreg4.nii.gz
	mv *emoreg5* emoreg5.nii.gz
	mv *emoreg6* emoreg6.nii.gz	
	echo "done $i"	
	cd ../
done

#For acc:
#cd /afs/cas.unc.edu/depts/psychology/mabsher/projects/YES/SOC_REJ

#For longleaf:
cd /proj/hng/sheridanlab/projects/YES/SOC_REJ

subjectlist=`ls -d 5*`

for i in ${subjectlist}

do 
	cd $i
	echo "in $i"
	pwd
	mv *socreject* soc_rej.nii.gz
	echo "done $i"	
	cd ../
done

#For acc:
cd /afs/cas.unc.edu/depts/psychology/mabsher/projects/YES/CARIT

#For longleaf:
#cd /proj/hng/sheridanlab/projects/YES/CARIT

subjectlist=`ls -d 5*`

for i in ${subjectlist}

do 
	cd $i
	echo "in $i"
	pwd
	mv *carit1* carit1.nii.gz
	mv *carit2* carit2.nii.gz
	mv *carit3* carit3.nii.gz
	echo "done $i"	
	cd ../
done

#For acc:
#cd /afs/cas.unc.edu/depts/psychology/mabsher/projects/YES/REST

#For longleaf:
cd /proj/hng/sheridanlab/projects/YES/REST

subjectlist=`ls -d 5*`

for i in ${subjectlist}

do 	
	cd $i
	echo "in $i"
	pwd
	mv *rest* rest.nii.gz
	cd ../
	pwd

done
