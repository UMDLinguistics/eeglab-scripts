## Memory Test Evaluation
# For use with Matlab logs of WordPres memory tests.
# Before using, create a score key and save it in the Experiment's folder.

def evaluate(subjID, expt, exptkey, paradigm):
    
# Set the paths
    #On Anna's Mac:
    #add 'user' as an input argument -- def evaluate(user, subjID, expt, exptkey, paradigm):
#    filepath = '/Users/' +user+ '/Dropbox/' +expt+ '/results/logs/'
    
    #on Cephalopod:
    
    #(for each experiment put all log files into a new folder under data and name it "logs")
    #(for MEG, we might want to consider making a separate log file under each participant)
    #filepath = '/Users/Shared/Experiments/'+expt+'/data/logs'
	#For Caribou:
	filepath= '/Users/Shared/Experiments/'+expt+'/data/logs'
	
	keyfile = exptkey+'_key'
    
	e= __import__(keyfile)

	import os
	os.chdir(filepath)
    
    # For MOOSE_MRI
 #   origFile = filepath +subjID+ '/' +subjID+ '_' +paradigm+ '.log'
#    midwayFile = filepath +subjID+ '/' +subjID+ '_' +paradigm+ '_midway.txt'
#    score= filepath +subjID+ '/' +subjID+ '_' +paradigm+ '_score.txt'
  
    #For CARIBOU_EEG, OSTRICH, NARWHAL, etc.
	origFile = filepath+ '/' +subjID+ '_' +paradigm+ '.log'
	midwayFile = filepath+'/' +subjID+ '_' +paradigm+ '_midway.txt'
	score= filepath+ '/' +subjID+ '_' +paradigm+ '_score.txt'
	
#extract question and response lines from original logfile
#and print to a new midway file
# WILL NEED TO BE MODIFIED FOR STUDIES WITHOUT "no triggers sent"!! (i.e. MEG/MRI studies)
    
	f1 = open(origFile, 'r')
	f2 = open(midwayFile, 'w')
	lines = f1.readlines()

	for i, line in enumerate(lines):
		if 'no triggers sent' in line:
			f2.write(lines[i + 1])
			f2.write(lines[i + 2])

	f1.close()
	f2.close()
    
#evaluate button presses
	f2 = open(midwayFile, 'r')
	f3= open(score,'w')
	ls = f2.readlines()
	lines = [l.split() for l in ls]


	for i in range(len(lines))[::2]:
		ln1= lines[i]
		ln2= lines[i+1]

    #give to key (each key is specific to the experiment run)

		if e.key(ln1,ln2):
			f3.write('correct\n')
		else:
			f3.write('incorrect\n')

    
	f2.close()
	f3.close()
 
	print ('Almost there!')                       
                        
#count number of correct responses
                        
	f3 = open(score,'r')
	lines = f3.readlines()
	correct = lines.count('correct\n')
	incorrect = lines.count('incorrect\n')
	total = correct + incorrect
	finalScore = (correct/total)
	f3.close()
	print ('The subject scored: ', finalScore)
	f3 = open(score,'a')
	f3.write('Final Score: ' + str(finalScore))




 
