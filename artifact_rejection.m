%%%Input re-referenced, epoched file, output re-referenced, epoched file
%%%with artifact rejection applied, plus a text file documenting rejection

%%Example
%%artifact_rejection('MOOSE','Moose',1,-100,800,100,40,25,[])

function artifact_rejection(expDir, expName, subjNumList, rejStart, rejEnd, ptpThresh, veogThresh, heogThresh, badChan)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/data/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


for subjNum = subjNumList
    
    subjFileName = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be.set')
    outFileName = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_ar.set')
    outTextName = strcat(filePath,'ArtifactRejection/', expName, '_S', int2str(subjNum), '_AR_summary.txt')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    

   %%interpolate bad channels
   if ~isempty(badChan)
       backupFile = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_unint.set')
       EEG = pop_saveset( EEG, 'filename',backupFile,'filepath',filePath);   
       EEG = eeg_interp(EEG, badChan);
       EEG = pop_saveset( EEG, 'filename',subjFileName,'filepath',filePath);
   end
    
    
    %%peak to peak threshold for general noise on regular channels
    %test_channels = setxor([1:30],badChan);
    test_channels = [1:30];
    EEG  = pop_artmwppth( EEG , 'Channel',  test_channels, 'Flag', [ 1 2], 'Review', 'on', 'Threshold',  ptpThresh, 'Twindow', [ rejStart rejEnd], 'Windowsize',  200, 'Windowstep',  100 );
    EEG = eeg_checkset( EEG );

    %%VEOG threshold for blinking, step function
    EEG  = pop_artstep( EEG , 'Channel',  32, 'Flag', [ 1 3], 'Review', 'on', 'Threshold',  veogThresh, 'Twindow', [ rejStart rejEnd], 'Windowsize',  200, 'Windowstep',  50 );
    EEG = eeg_checkset( EEG );

    %%HEOG threshold for blinking, step function
    EEG  = pop_artstep( EEG , 'Channel',  31, 'Flag', [ 1 4], 'Review', 'on', 'Threshold',  heogThresh, 'Twindow', [ rejStart rejEnd], 'Windowsize',  200, 'Windowstep',  50 );
    EEG = eeg_checkset( EEG );

    %%output documentation file
    pop_summary_AR_eeg_detection(EEG, outTextName);

    
    
    %%save dataset
       
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',outFileName,'filepath',filePath);
    

   
end
