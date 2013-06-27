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
#MOOSE_time <- seq(-100, 798, 2)  for a sampling rate of 500Hz, an epoch of -100:798ms
#MEH_time <- seq(-100, 898, 1) for a sampling rate of 1000Hz, an epoch of -100:898ms
avgWinERP <- function(erpData, subjNum, condNum, epBeg, epEnd, sampleRate, t1, t2){
  time_vector <- seq(epBeg, epEnd, sampleRate)
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