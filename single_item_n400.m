%%epoched data seems to be baselined already

function single_item_n400(expDir, expName, subjNumList)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/data/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

allSubjCode = [];
allCode1 = [];
allCode2 = [];
allTargetData = [];
for subjNum = subjNumList
    
    subjFileName = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_ar.set')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    czData = squeeze(EEG.data(15,:,:));
    czN400Data = squeeze(mean(czData(201:301,:),1));
    
    targetData = [];
    code1 = [];
    code2 = [];

    for i = 2:2:size(czN400Data,2)
        flag = EEG.epoch(i).eventflag{1};
        itemInfo = EEG.epoch(i-1).eventtype;
        if flag == 0
            targetData(end+1) = czN400Data(i);
            startPos1 = strfind(itemInfo{1},'(')+1;
            endPos1 = strfind(itemInfo{1},')')-1;
            code1(end+1) = str2num(itemInfo{1}(startPos1:endPos1));
            startPos2 = strfind(itemInfo{2},'(')+1;
            endPos2 = strfind(itemInfo{2},')')-1;
            code2(end+1) = str2num(itemInfo{2}(startPos2:endPos2));
            
        end
    end
    subjCode = ones(size(code1))*subjNum;

    allSubjCode = [allSubjCode;subjCode'];
    allCode1 = [allCode1;code1'];
    allCode2 = [allCode2;code2'];
    allTargetData = [allTargetData;targetData'];
    
    newData = [allSubjCode allCode1 allCode2 allTargetData ];
    dlmwrite('MOOSE_single_item_n400.txt',newData,' ');
    %targetData
end

