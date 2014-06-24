#   OSTRICH EEG -- Scoring Key

# designedfor use with evaluate.py
# 251 APPEARED, 252 DID NOT APPEAR
# j = yes, f = no

def key(ln1,ln2): 

        
        if (('251' in ln1[1:]) & ('j' in ln2)):
    #           print(['c'] + ln1 + ln2)
                return True 
                
        elif (('251' in ln1[1:]) & ('f' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False
                
        elif (('252' in ln1[1:]) & ('f' in ln2)):
   #            print(['c'] + ln1 + ln2)
                return True
                
        elif (('252' in ln1[1:]) & ('j' in ln2)):
   #            print(['i'] + ln1 + ln2)
                return False

