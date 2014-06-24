%%epoched data seems to be baselined already
%%epBeg and epEnd should be entered in ms

function epoch2R(expDir, expName, subjNumList)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/');


allData = [];
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
for subjNum = subjNumList
 
    subjFileName = strcat('data/EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_ar.set')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    %winEpochs = squeeze(mean(EEG.data(:,sampBeg:sampEnd,:),2))'; % epochs x chan
    epochs = permute(EEG.data,[3 2 1]); %epochs x samples x chan
    epochsTarget = [];
    code1 = [];
    code2 = [];

    %%%Extract trigger codes 1 and 2 from the prime epoch, but extract only
    %%%the data from the target epoch (the second of each pair, given the
    %%%way we did the binning for MOOSE)
    %%%This only extracts non-rejected epochs
    size(epochs)
    for i = 2:2:size(epochs,1)
        flag = EEG.epoch(i).eventflag{1};
        itemInfo = EEG.epoch(i-1).eventtype; %%this is the bin codes that happened in that epoch, prime and target triggers

        if flag == 0   %%if event is not rejected
            
            epochsTarget(end+1,:,:) = epochs(i,:,:);
            
            startPos1 = strfind(itemInfo{1},'(')+1;
            endPos1 = strfind(itemInfo{1},')')-1;
            code1(end+1) = str2num(itemInfo{1}(startPos1:endPos1)); %%how to extract trigger code for prime
            startPos2 = strfind(itemInfo{2},'(')+1;
            endPos2 = strfind(itemInfo{2},')')-1;
            code2(end+1) = str2num(itemInfo{2}(startPos2:endPos2)); %%how to extract trigger code for target          
        end
    end
    
    %%Make long form
    firstDim = size(epochsTarget, 1)*size(epochsTarget, 2)*1;
    secondDim = 7;
    currSubj = zeros(firstDim, secondDim);
    %currSubj = [];
    size(epochsTarget)
    size(epochsTarget, 1) * size(epochsTarget, 2) * size(epochsTarget, 3)
    count = 0;
    for epochNum = 1:size(epochsTarget,1)
        epochNum
        for sampNum = 1:size(epochsTarget, 2)
            for elecNum = 1:1%size(epochsTarget,3)
                count = count+1;
                codeCombine = str2num(strcat(int2str(code1(epochNum)),int2str(code2(epochNum))));
                currLine = [subjNum code1(epochNum) code2(epochNum) codeCombine EEG.times(sampNum) elecNum epochsTarget(epochNum,sampNum, elecNum)];
                %currSubj = [currSubj;currLine];
                currSubj(count, :) = currLine;
            end  
        end
    end
    allData = [allData;currSubj];
    ALLEEG = pop_delset( ALLEEG, [1] );
end


dlmwrite(strcat(filePath,'results/R/Epoch_txt/MOOSE_epoch.txt'),allData,'delimiter','\t','precision',6);


