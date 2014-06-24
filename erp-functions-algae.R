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
#ex: allData.df <- allSubjCondWin('MOOSE','Moose','MOOSE_n36', c(1,2), -100, 798, 500, 300,500)

allSubjCondWin <- function(expDir, expName, subjListFileID, condList, epBeg, epEnd, sampleRate, t1, t2){
  #Read in subject list
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'subjLists/',subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  
  #Read in ERP data
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

#This function runs a simple comparison between 2 conditions in a time-window including ALL electrodes
#except VEOG, HEOG, right mastoid, and FP1 for symmetry
#results go to a directory you need to create: '/Users/Shared/Experiments/expDir/results/R'
#Ex:simple_2cond_ANOVA('MOOSE','Moose',c(1:4,6:29,31,33:39), 1, 2, -100, 798, 500, 300, 500)

simple_2cond_ANOVA <- function(expDir, expName, subjListFileID,c1,c2,epBeg, epEnd, sampleRate, t1,t2){
  #Read in subject list
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'subjLists/',subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  
  allData.df <- allSubjCondWin(expDir,expName,subjListFileID, c(c1,c2), epBeg, epEnd, sampleRate,t1,t2)

  #exclude veog, heog, right mastoid, fp1
  allData.df <- subset(allData.df, elec != 28 & elec != 30 & elec != 31 & elec != 32)
  
  c1c2Data.df <- subset(allData.df,cond==c1 | cond==c2)
  
  library('ez')
  
  ez_c1c2 <- ezANOVA(data=c1c2Data.df,dv=.(amp),wid=.(subj),within=.(cond),type=3, detailed=TRUE)
  
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  outFileName <- paste(filePath,'anova_c',c1,'c',c2,'_',t1,t2,'.txt',sep="")
  sink(outFileName)
  print(ez_c1c2)
  sink()
  
}

##quads should be double-checked--this analysis includes 20 electrodes
ezANOVAquad <- function(expDir, expName, subjListFileID,c1,c2,epBeg, epEnd, sampleRate, t1,t2,slabel){
  #Read in subject list
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'subjLists/',subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  
  allData.df <- allSubjCondWin(expDir,expName,subjListFileID, c(c1,c2), epBeg, epEnd, sampleRate,t1,t2)
  
  allData.df <- subset(allData.df, elec != 28 & elec != 30 & elec != 31 & elec != 32)
  droplevels(allData.df)
  
  allData.df$hem <- factor(allData.df$elec)
  levels(allData.df$hem) <- c("R","M","L","M","R","R","R","R","R","R","L","L","L","M","M","R","R","L","L","M","M","R","R","L","L","L","L","L")
  
  allData.df$ap <- factor(allData.df$elec)
  levels(allData.df$ap) <- c("X","X","X","P","P","P","P","M","P","M","P","P","P","P","M","A","A","P","M","A","A","A","A","M","A","A","A","A")
  
  quadData.df <- subset(allData.df, ap !="X" & ap !="M" & hem !="M")
  quadData.df <- droplevels(quadData.df)
  
  c1c2Data.df <- subset(quadData.df,cond==c1 | cond==c2)
  c1c2Data.df <- droplevels(c1c2Data.df)

  
  library('ez')
  
  ez_c1c2 <- ezANOVA(data=c1c2Data.df,dv=.(amp),wid=.(subj),within=.(cond,hem,ap),type=3, detailed=TRUE)
  
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  outFileName <- paste(filePath,'anova_quad_c',c1,'c',c2,'_',t1,t2,'.txt',sep="")
  sink(outFileName)
  print(ez_c1c2)
  c1c2.aov = aov(amp ~ cond * hem * ap + Error(subj/(cond * hem * ap)), data = c1c2Data.df)
  print(model.tables(c1c2.aov,"means"), digits = 5)
  sink()
  
  
}


#elecLabelList in grandAvgElec should be triple-checked to verify it is correct
grandAvgElec <- function(expDir, expName, subjListFileID, condList, elec){
  #Read in subject list
  filePath <- paste('/Users/Shared/Experiments/',expDir,'/results/R/',sep="")
  fileName <- paste(filePath,'subjLists/',subjListFileID, '.txt',sep="")
  subjList = scan(file=fileName,flush=TRUE)
  
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
