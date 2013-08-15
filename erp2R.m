%%Take ERP data to text format for R, samples x channels, for a given
%%list of subjects in one condition (run once for each condition)

%%condition numbers follow the order defined in your bin definition file

function erp2R(expDir, expName, subjNumList, cond,lpfilt)

filePath = strcat('/Users/Shared/Experiments/',expDir,'/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


for subjNum = subjNumList
    if lpfilt == 0
        subjFileName = strcat('data/ERPs/',expName, '_S', int2str(subjNum), '.erp')
    else
        subjFileName = strcat('data/ERPs/',expName, '_S', int2str(subjNum),'_lp',int2str(lpfilt),'.erp')
    end
    outFileName = strcat(filePath,'results/R/ERP_txt/',expName, '_S', int2str(subjNum), '_c',int2str(cond),'.txt');
    
    %%loading data
    ERP = pop_loaderp('filename', subjFileName, 'filePath', filePath);
    subjData = squeeze(ERP.bindata(:,:,cond));
    fprintf(strcat('\nYou loaded : ',ERP.bindescr{cond}),'\n');
    
    
    %%writing out data
    dlmwrite(outFileName, subjData',',');  %%transpose subj data

end

