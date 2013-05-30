%%%%Reading in EEG datafiles from CNT format

function cnt2set(expDir, expName,subjNumList)

dataType = 'int16';
filePath = strcat('/Users/Shared/Experiments/',expDir,'/data/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for subjNum = subjNumList
    
    subjFileName = strcat(filePath, expName, '_S', int2str(subjNum), '.cnt')
    outFileName = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum),'.set')

    EEG = pop_loadcnt(subjFileName, 'dataformat', dataType);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
    EEG = eeg_checkset( EEG );
    
    %%Add channel locations
    EEG=pop_chanedit(EEG, 'lookup','/Users/Shared/MATLAB/eeglab10_2_5_8b/plugins/dipfit2.2/standard_BESA/standard-10-5-cap385.elp');
    EEG = eeg_checkset( EEG );
    
    
    EEG = pop_editset(EEG, 'setname', strcat('S',int2str(subjNum)));
    EEG = pop_saveset( EEG, 'filename',outFileName,'filepath',filePath);

end