##R functions for ERP analysis after EEGLAB/ERPLAB preprocessing
##Ellen Lau Summer 2013, inspired by Wing Yee Chow's code


#Core grand-avg waveform plotting function called by scripts below
plotBasicERP <- function(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,col.scheme){
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'subjLists/',subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  time_vector <- seq(epBeg,epEnd,1000/sampleRate)
  col.scheme = c("black","red","blue","green","cyan","orange","brown")
  
  firstCond <- condList[1]
  ga_c1 <- grandAvgElec(expDir, expName,subjListFileID,condList[1],elec)
  plot(time_vector, ga_c1, type="l", ylim=c(5,-5), col=col.scheme[1],ylab="",xlab="",xaxt="n",yaxt="n",lwd=4, bty="n")
  axis(1,labels=FALSE,pos=c(0,0),lwd=1,tcl=-.5,at=seq(epBeg,epEnd+5,100))
  axis(2,labels=TRUE,pos=c(0,0),las=1,lwd=1,tcl=-.5,at=c(-2,2))
  mtext(elec,side=2,adj=1.5,cex=1,las=1,at=-4)
  
  if(length(condList) > 1){
    otherConds <-condList[2:length(condList)]    
    count = 0  
    for (cond in otherConds){
      count = count + 1
      ga_otherCond <- grandAvgElec(expDir,expName,subjListFileID,otherConds[count],elec)
      lines(time_vector, ga_otherCond, col=col.scheme[count+1],lwd=4)
    }
  }
  
}

#This function plots the waveform for a single electrode in R, with option to export to pdf
#Files needed: 
##(1)ERP files for each subj/cond exported from Matlab, as described above
##(2)Subject list text file in 'Experiments/expDir/results/R/' that has one subject number per row
##(3)To export pdfs, need to create a directory 'Experiments/expDir/results/R/figures/'

#EX: plotERP.1e('MOOSE', 'MOOSE', 'MOOSE_n33', c(1,2,3, 4), c('curly hair (hi-con hi-prob)', 'soaked hair', 'curly leaf (hi-con lo-prob)', 'crunchy leaf'),-100, 798, 500, 6,'yes')

#!!elecLabelList in grandAvgElec should be triple-checked to verify it is correct
plotERP.1e <- function(expDir, expName, subjListFileID, condList, condLabelList,epBeg, epEnd, sampleRate, elec,pdfQ){
  colScheme = c("black","red","blue","green","cyan","orange","brown")
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  par(mfrow=c(1,1))
  
  if(pdfQ=='yes'){pdf(file=paste(filePath,'figures/ERP_',elec,'_',subjListFileID,'_',condLabelList[1],'_',condLabelList[2],'.pdf',sep=""))}
  plotBasicERP(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,colScheme)
  #mtext("μV",side=2,adj=-3, line=1, cex=1, las=1, at=4)  ##mu symbol won't encode correctly in pdf
  mtext(subjListFileID,side=3,adj=.5,cex=1.5)
  #legend(100, 4, condLabelList, col=colScheme[1:length(condList)], lty=c(1,1), merge=TRUE,lwd=2.5,bty="n")
  if(pdfQ=='yes'){dev.off()}
}

