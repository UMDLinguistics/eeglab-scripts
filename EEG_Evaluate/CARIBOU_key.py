#   CARIBOU EEG -- Scoring Key

# designedfor use with evaluate.py
# 101 APPEARED, 102 DID NOT APPEAR
# f = yes, j = no

def key(ln1,ln2): 

        
        if (('101' in ln1[1:]) & ('f' in ln2)):
    #           print(['c'] + ln1 + ln2)
                return True 
                
        elif (('101' in ln1[1:]) & ('j' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False
                
        elif (('102' in ln1[1:]) & ('j' in ln2)):
   #            print(['c'] + ln1 + ln2)
                return True
                
        elif (('102' in ln1[1:]) & ('f' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False

