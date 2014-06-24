## Comprehension Evaluation for NARWHAL
# For use with Matlab logs of SentMEG experiments.

##Import Modules ##
import argparse
import os

## Define the function ##

def eval_Orang(expt, subjID, paradigm):

# Set the paths
	
	
	filepath = '/Users/Shared/Experiments/'+args.expt+'/data/'+args.subjID+'/logs'
    
	origFile = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '.log'
	midFile_events = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_midway_events.txt'
	midFile_verbs = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_midway_verbs.txt'
	midFile_nouns = filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_midway_nouns.txt'
	score= filepath+ '/' +args.subjID+ '_' +args.paradigm+ '_score.txt'
	
	
#extract question and response lines from original logfile
#and print to a new midway file
    
	f1 = open(origFile, 'r')
	f2_events = open(midFile_events, 'w')
	f2_verbs = open(midFile_verbs, 'w')
	f2_nouns = open(midFile_nouns, 'w')
	
	ls1 = f1.readlines()
	lines = [l.split('\t') for l in ls1]

	for i, line in enumerate(lines):
		if ('32' in line[2]):
			f2_events.write(' '.join(lines[i - 2]))
			f2_events.write(' '.join(lines[i - 1]))
			f2_events.write(' '.join(lines[i]))	
			f2_events.write(' '.join(lines[i + 1]))	
			
		if ('34' in line[2]):
			f2_verbs.write(' '.join(lines[i - 2]))
			f2_verbs.write(' '.join(lines[i - 1]))
			f2_verbs.write(' '.join(lines[i]))	
			f2_verbs.write(' '.join(lines[i + 1]))		
			
		if ('36' in line[2]):
			f2_nouns.write(' '.join(lines[i - 2]))
			f2_nouns.write(' '.join(lines[i - 1]))
			f2_nouns.write(' '.join(lines[i]))	
			f2_nouns.write(' '.join(lines[i + 1]))			
			
	f1.close()
	f2_events.close()
	f2_verbs.close()
	f2_nouns.close()
    
	print 'Halfway through!'
	
# 	#evaluate button presses
# 	f2 = open(midwayFile, 'r')
# 	f3= open(score,'w')
# 	ls2 = f2.readlines()
# 	lines = [l.split() for l in ls2]
# #	wrongTrigs = ['130', '131', '132', '135']
# 			
# 	for i in range(len(lines)-1):
# 		try:
# 			ln1= lines[i]
# 			ln2= lines[i+1]
# 			ln3= lines[i+2]
# 
# 			if (('133' in ln1[2:]) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Prime, delayed\n')
# 				f3.write('1-delayed\n')
# 
# 			elif (('134' in ln1[2:]) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Target, delayed\n')
# 				f3.write('1-delayed\n')
# 			elif (('133' in ln2[2:]) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Prime\n')
# 				f3.write('1\n')	
# 
# 			elif (('134' in ln2[2:]) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Target\n')
# 				f3.write('1\n')	
# 
# 			elif ((('FLY' in ln2[1])&('130' in ln2[2:])) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Target "FLY" \n')
# 				f3.write('1\n')	
# 
# 			elif ((('FLY' in ln1[1])&('130' in ln1[2:])) & ('999' in ln3)):
# 				#f3.write('correct -- Animal Target "FLY", delayed\n')
# 				f3.write('1-delayed\n')	
# 
# 			elif ((((('130' in ln2[2:])|('131' in ln2[2:]))|('132' in ln2[2:]))|('135' in ln2[2:])) & ('999' in ln3)):
# 				f3.write('0\n')
# 		except IndexError:
# 			pass
# 
# 	f2.close()
# 	f3.close()
# 	
# ## Calculate score	
# 	f3 = open(score,'r')
# 	lines = f3.readlines()
# 	correctcount = 0
# 	incorrectcount = 0
# 	delayedcount = 0
# 	total = 0
# 
# 	for row in lines:
# 		if (row == '1\n'):
# 			correctcount += 1
# 			total += 1
# 			
# 		elif (row == '1-delayed\n'):
# 			delayedcount += 1
# 			total += 1
# 			
# 		elif (row == '0\n'):
# 			incorrectcount += 1
# 			total += 1
# 			
# 	print correctcount
# 	print delayedcount		
# 	print incorrectcount
# 	print total
# 	
# 	totalcorrect = (float(correctcount)+float(delayedcount))
# 	finalScore = (round((float(totalcorrect)/float(total)), 3))*100
# 	
# 	f3.close()
# 	print ('The subject scored: ' +str(finalScore)+ '% and ' +str(delayedcount)+' of ' +str(total)+ ' responses were delayed.') 
# 	f3 = open(score,'a')
# 	f3.write('Final Score: ' + str(finalScore) + '% with'+str(delayedcount)+' delayed responses.')

#########################################
### Main function ###

if __name__ == '__main__':
	parser = argparse.ArgumentParser(description='Get input')
	parser.add_argument('expt',type=str)
	parser.add_argument('subjID',type=str)
	parser.add_argument('paradigm',type=str)
	args=parser.parse_args()
  
  	eval_Orang(args.expt, args.subjID, args.paradigm)
  	
print "Totally done!"
	

 
