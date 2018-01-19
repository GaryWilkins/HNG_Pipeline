#!/proj/hng/hng_pipeline/bin/R

Args<- commandArgs(TRUE)
if(length(Args)!=3)
{
  stop("Error,please put in 3 arguments")
}
inputfile<- Args[1]
ncomp <- Args[2]
pctvar <- Args[3]

ncomp <- as.numeric(ncomp)
pctvar <- as.numeric(pctvar)

library(Rniftilib)
library(pracma)

#Read in masked timeseries
maskeddata <- nifti.image.read(inputfile,read_data = TRUE)

#Get dimensions from timeseries data
x<-maskeddata$dim[1]
y<-maskeddata$dim[2]
z<-maskeddata$dim[3]
t<-maskeddata$dim[4]

#Rearrange the data so that each column is a timepoint.
permdata=aperm(maskeddata[],c(4,1,2,3))

#Rearrange the data into a matrix where each voxel is a column with timepoints in rows
tsmat <- matrix(data=permdata[],nrow=t,ncol=x*y*z)

#Get rid of the columns where there is no data in the mask.
restrictedmat<-tsmat[,(colSums(tsmat) != 0)]

#Remove constant and linear trends
detrended <- detrend(restrictedmat,tt = 'constant')
detrended <- detrend(detrended,tt = 'linear')

#Variance normalizion
normed=scale(detrended,scale=TRUE,center=TRUE)

#Singular Value Decomposition
compcorsvd <- svd(normed, nv=0)

#Explained Variance and Graph
PctVarianceExplained <- compcorsvd$d^2/sum(compcorsvd$d^2)*100
CumPctVarianceExplained <- cumsum(PctVarianceExplained)

outputplot <- gsub(".nii.gz","_aCompCorVarExplain.png",inputfile)
png(outputplot)
plot(PctVarianceExplained, xlim = c(0, t/2), type = "b", pch = 16, xlab = "principal components", ylab = "percent variance explained")
dev.off()

#Figure out how many components are needed to explain some percent (e.g., 50) of the variance if a variance argument was given.  If not, use a set number of components.
if (pctvar>0) {
  ncomp <- which (CumPctVarianceExplained > pctvar)[[1]]
}

TotalVE <- CumPctVarianceExplained[ncomp]

compcorr <- compcorsvd$u[,1:ncomp]
outputfile<-gsub(".nii.gz",".ACOMPCORregs.txt",inputfile)
write(compcorr,file=outputfile,ncolumns=ncomp, append=FALSE)
pctfile<-gsub(".nii.gz","_aCompCor_frac_explain.txt",inputfile)
write(TotalVE,file=pctfile, append=FALSE)
