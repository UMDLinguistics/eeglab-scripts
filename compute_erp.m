%%%Input re-referenced, epoched file with artifact rejection applied

%%Example
%%compute_erp('MOOSE','Moose',[1:18],40)

function compute_erp(expDir, expName, subjNumList, lpfilt)


filePath = strcat('/Users/Shared/Experiments/',expDir,'/data/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


for subjNum = subjNumList
    
    subjFileName = strcat('EEGLAB_sets/',expName, '_S', int2str(subjNum), '_elist_bins_be_ar.set')
    outFileName = strcat('ERPs/',expName, '_S', int2str(subjNum), '.erp')
    outFileNameFilt = strcat('ERPs/',expName, '_S', int2str(subjNum),'_lp',int2str(lpfilt),'.erp')
    
    %%loading data
    EEG = pop_loadset('filename',subjFileName,'filepath',filePath);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    EEG = eeg_checkset( EEG );
    
    %%compute erp
    ERP = pop_averager( ALLEEG , 'Criterion', 'good', 'DSindex',1, 'Stdev', 'on', 'Warning', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', strcat('S', int2str(subjNum)), 'filename', outFileName, 'filepath', filePath, 'warning', 'on');         

    %%filter erp
    ERP = pop_filterp( ERP,1:32 , 'Cutoff',lpfilt, 'Design', 'butter', 'Filter', 'lowpass', 'Order',2 );
    ERP = pop_savemyerp(ERP, 'erpname', strcat('S', int2str(subjNum)), 'filename', outFileNameFilt, 'filepath', filePath, 'warning', 'on');         

    %%delete epoch data
    ALLEEG = pop_delset( ALLEEG, [1] );

end