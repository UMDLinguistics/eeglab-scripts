##R functions for ERP analysis after EEGLAB/ERPLAB preprocessing
##Ellen Lau Summer 2013, inspired by Wing Yee Chow's code

readERP <- function(expDir, expName, subjNum, condNum){
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'ERP_txt/',expName,'_S', subjNum, '_c', condNum, '.txt',sep="")
  subjERP <- read.table(fileName, sep= ',')
  return(subjERP)
}


#This function extracts the mean from a time-window specified in ms by t1 and t2
#To coordinate with different sampling rates, you need to specify the appropriate time_vector
#for your erp data. This variable can be made as so:
#MOOSE_time <- seq(-100, 798, 500)  for a sampling rate of 500Hz, an epoch of -100:798ms
#MEH_time <- seq(-100, 898, 1000) for a sampling rate of 1000Hz, an epoch of -100:898ms
avgWinERP <- function(erpData, subjNum, condNum, epBeg, epEnd, sampleRate, t1, t2){
  time_vector <- seq(epBeg, epEnd, 1000/sampleRate)
  sample1 <- which(time_vector == t1)
  sample2 <- which(time_vector == t2)
  avgWinDataV <- colMeans(erpData[sample1:sample2, ])
  subjV <- rep(c(subjNum))
  condV <- rep(c(condNum))
  numElec <- dim(erpData)[2]
  elecV <- c(1:numElec)
  avgWinData <- cbind(avgWinDataV, subjV, condV, elecV)
  return(avgWinData)
}

#This function calls the previous two functions to create a dataframe containing mean over selected
#time-window for all subjects and conditions of interest
#ex: allData.df <- allSubjCondWin('MOOSE','Moose',c(1:4,6:29,31,33:36), c(1,2), -100, 798, 2, 300,500)

allSubjCondWin <- function(expDir, expName, subjList, condList, epBeg, epEnd, sampleRate, t1, t2){
  for (subj in subjList){
    for (cond in condList){
      if(exists('tempERP')){
        tempERP <- readERP(expDir, expName, subj, cond)
        tempWinData <- avgWinERP(tempERP, subj, cond, epBeg, epEnd, sampleRate, t1, t2)
        allData <- rbind(allData, tempWinData)
      }
      else{
        #first time through loop
        tempERP <- readERP(expDir, expName, subj, cond)
        allData <- avgWinERP(tempERP, subj, cond, epBeg, epEnd, sampleRate, t1, t2)
      }
    }
  }
  
  allData.df <- data.frame(subj=factor(allData[,2]), cond=factor(allData[,3]), elec=factor(allData[,4]), amp=allData[,1])
  return(allData.df)
}

#elecLabelList in grandAvgElec should be triple-checked to verify it is correct
grandAvgElec <- function(expDir, expName, subjList, condList, elec){
  elecLabelList <- c('O2','O1','Oz','Pz','P4','CP4','P8','C4','TP8','T8','P7','P3','CP3','CPz','Cz','FC4','FT8','TP7','C3','FCz','Fz','F4','F8','T7','FT7','FC3','F3','RM','F7','FP1')
  elecNum <- which(elecLabelList == elec)
  for (subj in subjList){
    for (cond in condList){
      if(exists('tempERP')){
        tempERP <- readERP(expDir, expName, subj, cond)
        tempERPElec <- tempERP[,elecNum]
        allDataElec <- cbind(allDataElec, tempERPElec)
      }
      else{
        #first time through loop
        tempERP <- readERP(expDir, expName, subj, cond)
        allDataElec <- tempERP[,elecNum]
      }
    }
  }
  gaData <- rowMeans(allDataElec)
  return(gaData)  
}


plotERP.1e <- function(expDir, expName, subjListFileID, condList, condLabelList,epBeg, epEnd, sampleRate, elec,pdfQ){
  colScheme = c("black","red","blue","green","cyan","orange","brown")
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  par(mfrow=c(1,1))
  
  if(pdfQ=='yes'){pdf(file=paste(filePath,'figures/ERP_',elec,'_',subjListFileID,'.pdf',sep=""))}
  plotBasicERP(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,colScheme)
  #mtext("μV",side=2,adj=-3, line=1, cex=1, las=1, at=4)  ##mu symbol won't encode correctly in pdf
  mtext(subjListFileID,side=3,adj=.5,cex=1.5)
  legend(-100, 6, condLabelList, col=colScheme[1:length(condList)], lty=c(1,1), merge=TRUE,lwd=2.5,bty="n")
  if(pdfQ=='yes'){dev.off()}
}

plotERP.4e <- function(expDir, expName, subjListFileID, condList, condLabelList,epBeg, epEnd, sampleRate, elecList,pdfQ){
  colScheme = c("black","red","blue","green","cyan","orange","brown")
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  
  if(pdfQ=='yes'){pdf(file=paste(filePath,'figures/ERP_test4elec_',subjListFileID,'.pdf',sep=""))}
  par(mfrow=c(5,5))
  for(elec in elecList){
    plotBasicERP(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,colScheme)
    #mtext("μV",side=2,adj=-3, line=1, cex=1, las=1, at=4)  ##mu symbol won't encode correctly in pdf
  }
  #mtext(subjListFileID,side=3,adj=.5,cex=1.5)
  #legend(-100, 6, condLabelList, col=colScheme[1:length(condList)], lty=c(1,1), merge=TRUE,lwd=2.5,bty="n")
  if(pdfQ=='yes'){dev.off()}
}

plotERP.9e <- function(expDir, expName, subjListFileID, condList, condLabelList,epBeg, epEnd, sampleRate, pdfQ){
  colScheme = c("black","red","blue","green","cyan","orange","brown")
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  elecList = c('F7','Fz','F8','T7','Cz','T8','P7','Pz','P8')
  
  if(pdfQ=='yes'){pdf(file=paste(filePath,'figures/ERP_9elec_',subjListFileID,'.pdf',sep=""))}
  par(mfrow=c(3,3))
  for(elec in elecList){
    plotBasicERP(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,colScheme)
    #mtext("μV",side=2,adj=-3, line=1, cex=1, las=1, at=4)  ##mu symbol won't encode correctly in pdf
  }
  #mtext(subjListFileID,side=3,adj=.5,cex=1.5)
  legend(350, -5, condLabelList, col=colScheme[1:length(condList)], lty=c(1,1), merge=TRUE,lwd=1.5,bty="n",cex=.7)
  if(pdfQ=='yes'){dev.off()}
}


plotBasicERP <- function(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, elec,col.scheme){
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  time_vector <- seq(epBeg,epEnd,1000/sampleRate)
  col.scheme = c("black","red","blue","green","cyan","orange","brown")
  
  firstCond <- condList[1]
  ga_c1 <- grandAvgElec(expDir, expName,subjList,condList[1],elec)
  plot(time_vector, ga_c1, type="l", ylim=c(5,-5), col=col.scheme[1],ylab="",xlab="",xaxt="n",yaxt="n",lwd=2.5, bty="n")
  axis(1,labels=FALSE,pos=c(0,0),lwd=1,tcl=-.5,at=seq(epBeg,epEnd+5,100))
  axis(2,labels=TRUE,pos=c(0,0),las=1,lwd=1,tcl=-.5,at=c(-3,3))
  mtext(elec,side=2,adj=1.5,cex=1,las=1,at=-4)
  
  if(length(condList) > 1){
    otherConds <-condList[2:length(condList)]    
    count = 0  
    for (cond in otherConds){
      count = count + 1
      ga_otherCond <- grandAvgElec(expDir,expName,subjList,otherConds[count],elec)
      lines(time_vector, ga_otherCond, col=col.scheme[count+1],lwd=2)
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

plotERP.1e.orig <- function(expDir, expName, subjListFileID, condList, condLabelList,epBeg, epEnd, sampleRate, elec,pdfQ){
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  time_vector <- seq(epBeg,epEnd,1000/sampleRate)
  col.scheme = c("black","red","blue","green","cyan","orange","brown")
  if(pdfQ=='yes'){pdf(file=paste(filePath,'figures/ERP_',elec,'_',subjListFileID,'.pdf',sep=""))}
  
  firstCond <- condList[1]
  ga_c1 <- grandAvgElec(expDir, expName,subjList,condList[1],elec)
  plot(time_vector, ga_c1, type="l", ylim=c(12,-6), col=col.scheme[1],ylab="",xlab="",xaxt="n",yaxt="n",lwd=2.5, bty="n")
  axis(1,labels=FALSE,pos=c(0,0),lwd=1,tcl=-.5,at=seq(epBeg,epEnd+5,100))
  axis(2,labels=TRUE,pos=c(0,0),las=1,lwd=1,tcl=-.5,at=c(-3,3))
  mtext(elec,side=2,adj=.5,cex=2,las=1,at=-4)
  #mtext("μV",side=2,adj=-3, line=1, cex=1, las=1, at=4)  ##mu symbol won't encode correctly in pdf
  mtext(subjListFileID,side=3,adj=.5,cex=1.5)
  
  if(length(condList) > 1){
    otherConds <-condList[2:length(condList)]    
    count = 0  
    for (cond in otherConds){
      count = count + 1
      ga_otherCond <- grandAvgElec(expDir,expName,subjList,otherConds[count],elec)
      lines(time_vector, ga_otherCond, col=col.scheme[count+1],lwd=2)
    }
  }
  
  legend(-100, 6, condLabelList, col=col.scheme[1:length(condList)], lty=c(1,1), merge=TRUE,lwd=2.5,bty="n")
  if(pdfQ=='yes'){dev.off()}
  
}
