%%%Input raw file, output re-referenced, baselined, epoched file
%%%This script assumes that all the pre-stimulus points are used to compute
%%%the baseline

%%Example
%%epoch_set('MOOSE','Moose',[1:18], 1, 'Moose_bdf.txt', -100,800)

function epoch_set(expDir, expName, subjNumList, rerefQ, bdfFileName, epStart, epEnd)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/data/EEGLAB_sets/');
bdfFile = strcat('/Users/Shared/Experiments/',expDir,'/',bdfFileName)

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


for subjNum = subjNumList
    
    subjFileName = strcat(expName, '_S', int2str(subjNum), '.set')
    outFileName = strcat(expName, '_S', int2str(subjNum),'_elist_bins_be.set')
    evFileName = strcat(filePath, expName, '_S',int2str(subjNum),'_evlist.txt')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    %%creating event list
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'Eventlist',evFileName,'Newboundary', { -99 }, 'Stringboundary', { 'boundary' }, 'Warning', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );
    
    %%finding bins
    EEG  = pop_binlister( EEG , 'BDF', bdfFile, 'ExportEL', evFileName, 'ImportEL', 'no',  'SendEL2', 'EEG&Text', 'Warning', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'gui','off');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );
 
    %%extracting baselined epochs
    EEG = pop_epochbin( EEG , [epStart  epEnd],  'pre'); %%baselined with pre-stimulus interval
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'gui','off');
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );

    if rerefQ
        %%rereference
        EEG = pop_eegchanoperator( EEG, {  ' ch1=ch1 - ch28/2 label O2'   ' ch2=ch2 - ch28/2 label O1'   ' ch3=ch3 - ch28/2 label OZ'   ' ch4=ch4 - ch28/2 label PZ'   ' ch5=ch5 - ch28/2 label P4'   ' ch6=ch6 - ch28/2 label CP4'   ' ch7=ch7 - ch28/2 label P8'   ' ch8=ch8 - ch28/2 label C4'   ' ch9=ch9 - ch28/2 label TP8'   ' ch10=ch10 - ch28/2 label T8'   ' ch11=ch11 - ch28/2 label P7'   ' ch12=ch12 - ch28/2 label P3'   ' ch13=ch13 - ch28/2 label CP3'   ' ch14=ch14 - ch28/2 label CPZ'   ' ch15=ch15 - ch28/2 label CZ'   ' ch16=ch16 - ch28/2 label FC4'   ' ch17=ch17 - ch28/2 label FT8'   ' ch18=ch18 - ch28/2 label TP7'   ' ch19=ch19 - ch28/2 label C3'   ' ch20=ch20 - ch28/2 label FCZ'   ' ch21=ch21 - ch28/2 label FZ'   ' ch22=ch22 - ch28/2 label F4'   ' ch23=ch23 - ch28/2 label F8'   ' ch24=ch24 - ch28/2 label T7'   ' ch25=ch25 - ch28/2 label FT7'   ' ch26=ch26 - ch28/2 label FC3'   ' ch27=ch27 - ch28/2 label F3'   ' ch28=ch28 - ch28/2 label RM'   ' ch29=ch29 - ch28/2 label F7'   ' ch30=ch30 - ch28/2 label FP1'   ' ch31=ch31 - ch28/2 label HEOG'   ' ch32=ch32 - ch28/2 label VEOG'    });
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off');
        [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, CURRENTSET );
    end
    %%save dataset
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',outFileName,'filepath',filePath);
    

    
end