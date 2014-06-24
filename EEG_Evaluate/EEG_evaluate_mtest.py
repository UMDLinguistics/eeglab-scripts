##  Memory Test Comprehension
## Anna Namyst, Fall 2013

# Intended to evaluate the Matlab logs of WordPres and SentEEG experiments.
## NOTE: This script is specifically coded for the evaluation of true/false style responses. To evaluate rating (as in Orangutan), sections of this script will need to be modified accordingly.

## Import Modules ##
import argparse
import os

## Define the function ##

def EEG_eval(subjID, expt, exptkey, paradigm):

# Set the paths
	
	
	filepath = '/Users/Shared/Experiments/'+args.expt+'/data/logs'
    
    # Key File MUST be in the same directory as the script to run
    # Internal Note: Consider changing this later on (model after CondCodes?)
	keyfile = exptkey+'_key'
    
	e= __import__(keyfile)

	os.chdir(filepath)
	
	origFile = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '.log'
	midwayFile = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_midway.txt'
	score= filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_score.txt'
	
	
# Part 1: Extract question and response lines from original logfile
# and print to a new midway file. 
#**This midway file is a good sanity check to make sure that the correct lines are being extracted for evaluation
    
	f1 = open(origFile, 'r')
	f2 = open(midwayFile, 'w')
	lines = f1.readlines()

	for i, line in enumerate(lines):
		if 'no triggers sent' in line: 	##Check your log and adjust accordingly.
			f2.write(lines[i + 1])
			f2.write(lines[i + 2])

	f1.close()
	f2.close()
    
# Part 2: Evaluate button presses

	f2 = open(midwayFile, 'r')
	f3= open(score,'w')
	ls = f2.readlines()
	lines = [l.split() for l in ls]


	for i in range(len(lines))[::2]:
		ln1= lines[i]
		ln2= lines[i+1]

    # Give to lines to key for evaluation (each key is specific to the experiment run)

		if e.key(ln1,ln2):
			f3.write('1\n')
		else:
			f3.write('0\n')
    
	f2.close()
	f3.close()
 
	print ('Almost there!')      
	
# Part 3: Calculate score	

	f3 = open(score,'r')
	lines = f3.readlines()
	correctcount = 0
	incorrectcount = 0
	total = 0

	for row in lines:
		if (row == '1\n'):
			correctcount += 1
			total += 1
			
		elif (row == '0\n'):
			incorrectcount += 1
			total += 1
			
	print correctcount
	print incorrectcount
	print total
	
	finalScore = (round((float(correctcount)/float(total)), 3))*100
	
	f3.close()
	print ('The subject scored: ' +str(finalScore)+ '%') 
	f3 = open(score,'a')
	f3.write('Final Score: ' + str(finalScore))

#########################################
### Main function ###

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Get input')
	parser.add_argument('subjID',type=str)
	parser.add_argument('expt',type=str)
	parser.add_argument('exptkey',type=str)
	parser.add_argument('paradigm',type=str)
	args=parser.parse_args()
  
  	EEG_eval(args.subjID, args.expt, args.exptkey, args.paradigm)
  	
print "Totally done!"
	

 
