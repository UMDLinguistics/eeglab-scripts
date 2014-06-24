#   PROPINES EEG -- Scoring Key

# designedfor use with evaluate.py
# 242 APPEARED, 243 DID NOT APPEAR
# f = yes, j = no

def key(ln1,ln2): 

        
        if (('242' in ln1[1:]) & ('f' in ln2)):
    #           print(['c'] + ln1 + ln2)
                return True 
                
        elif (('242' in ln1[1:]) & ('j' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False
                
        elif (('243' in ln1[1:]) & ('j' in ln2)):
   #            print(['c'] + ln1 + ln2)
                return True
                
        elif (('243' in ln1[1:]) & ('f' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False

