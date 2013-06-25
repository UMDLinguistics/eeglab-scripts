%%Take ERP data to text format for R, samples x channels, for a given
%%condition

function erp2R(expDir, expName, subjNumList, cond)

filePath = strcat('/Users/Shared/Experiments/',expDir,'/');

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


for subjNum = subjNumList
    
    subjFileName = strcat('data/ERPs/',expName, '_S', int2str(subjNum), '.erp');
    outFileName = strcat(filePath,'results/R/ERP_txt/',expName, '_S', int2str(subjNum), '_c',int2str(cond),'.txt');
    
    %%loading data
    ERP = pop_loaderp('filename', subjFileName, 'filePath', filePath);
    subjData = squeeze(ERP.bindata(:,:,cond));
    fprintf(strcat('\nYou loaded : ',ERP.bindescr{cond}),'\n');
    
    
    %%writing out data
    dlmwrite(outFileName, subjData',',');  %%transpose subj data

end

