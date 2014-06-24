%%epoched data seems to be baselined already
%%epBeg and epEnd should be entered in ms

function epochWin2R(expDir, expName, subjNumList, epBeg, epEnd)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/');


allData = [];
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
for subjNum = subjNumList
 
    subjFileName = strcat('data/EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_ar.set')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    sampBeg = find(EEG.times==epBeg);
    sampEnd = find(EEG.times==epEnd);
    
    winEpochs = squeeze(mean(EEG.data(:,sampBeg:sampEnd,:),2))'; % epochs x chan
    
    winEpochsTarget = [];
    code1 = [];
    code2 = [];

    %%%Extract trigger codes 1 and 2 from the prime epoch, but extract only
    %%%the data from the target epoch (the second of each pair, given the
    %%%way we did the binning for MOOSE)
    %%%This only extracts non-rejected epochs
    
    for i = 2:2:size(winEpochs)
        flag = EEG.epoch(i).eventflag{1};
        itemInfo = EEG.epoch(i-1).eventtype; %%this is the bin codes that happened in that epoch, prime and target triggers
        if flag == 0   %%if event is not rejected
            winEpochsTarget(end+1,:) = winEpochs(i,:);
            startPos1 = strfind(itemInfo{1},'(')+1;
            endPos1 = strfind(itemInfo{1},')')-1;
            code1(end+1) = str2num(itemInfo{1}(startPos1:endPos1)); %%how to extract trigger code for prime
            startPos2 = strfind(itemInfo{2},'(')+1;
            endPos2 = strfind(itemInfo{2},')')-1;
            code2(end+1) = str2num(itemInfo{2}(startPos2:endPos2)); %%how to extract trigger code for target          
        end
    end
    
    %%Make long form
    currSubj = [];
    for epochNum = 1:size(winEpochsTarget,1)
        for elecNum = 1:size(winEpochsTarget,2)
            codeCombine = str2num(strcat(int2str(code1(epochNum)),int2str(code2(epochNum))));
            currLine = [subjNum code1(epochNum) code2(epochNum) codeCombine elecNum winEpochsTarget(epochNum,elecNum)];
            currSubj = [currSubj;currLine];
        end  
    end
    allData = [allData;currSubj];
    ALLEEG = pop_delset( ALLEEG, [1] );
end


dlmwrite(strcat(filePath,'results/R/EpochWin_txt/MOOSE_epoch_win_',int2str(epBeg),'-',int2str(epEnd),'.txt'),allData,'delimiter','\t','precision',6);


