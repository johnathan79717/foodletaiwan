# -*- coding: big5 -*-
import re, urllib
import time
import os
import sys

from pattern_exception_big5 import WrongTextTypeError as WrongTextTypeError
from pattern_exception_big5 import ImportantDataMissingError as ImportantDataMissingError
from pattern_exception_big5 import patterns as patterns , errorrecord as errorrecord , google_url as google_url
from pattern_exception_big5 import outputInJavascriptFormat as output , store as store , rootdir as rootdir

#pattern_priceparse  = re.compile('(\d+)([ 元]*)([ -~至到]*)(\d*)([ 元]*)')


success = 0
duplicate = 0
walked = 0

start = time.clock()

foodtype = []
restaurant_record = {}

for subdir, dirs, files in os.walk(rootdir):
    tags = set(subdir.lstrip(rootdir).decode('big5').split('\\'))
    for file in files:
            walked += 1
            opentext = open(subdir+'/'+file)
            text = file.rstrip('.txt')
            try:     
                a = opentext.read()
                texttype = re.search(patterns['texttype'] ,a)
        
                if texttype is None:
                    raise WrongTextTypeError(text,'Unrecongized format')
                else:
                    texttype = texttype.group(1)
            
                if  '食記' not in texttype and '廣宣' not in texttype :
                    raise WrongTextTypeError(text,texttype)

                restaruant_name = re.search(patterns['restaurant'],a)
                address = re.search(patterns['address'],a)
                if restaruant_name is None or address is None:
                     raise ImportantDataMissingError(text,False)
                else:
                    restaruant_name = restaruant_name.group(1)
                    address = address.group(1)            
        
                response = urllib.urlopen(google_url+address.decode('big5').encode('utf-8')).read()
                coordinates = re.search(patterns['coordinates'],response)
                if coordinates is None:
                    raise ImportantDataMissingError(text,True)
                else:
                    longitude,latitude = coordinates.group(1),coordinates.group(2)
                # Handled
                

                # updating price and tags if possible ...
                
                price = re.search(patterns['price'],a)
                
                if price is not None:
                    price = price.group(0)
                    price = re.findall(patterns['priceparse'],price)
                    price = set(price)
                    if len(price) == 0:
                         price = 'null'
                else:
                    price = 'null'
                
                if (longitude,latitude) not in restaurant_record :
                    restaurant_record [(longitude,latitude)] = (text , texttype, restaruant_name , address , price,tags)
                else:
                    previous = restaurant_record[(longitude,latitude)]
                    if price != 'null' and previous[4] != 'null':
                        price = price.union(previous[4])
                    elif previous[4] != 'null':
                        price = previous[4]
                    
                    newtag = tags.union(previous[5])
                    restaurant_record [(longitude,latitude)] = (text , texttype, restaruant_name , address , price,newtag)
                    duplicate += 1

                
                success += 1
                opentext.close()
            except (WrongTextTypeError,ImportantDataMissingError):
                pass
            except IOError:
                print " file not found"
            except UnicodeDecodeError:
                errorrecord.write( str(text) + ' Error: ' + 'unrecongized character or bad encoding\n')
            except KeyboardInterrupt:
                break
            except Exception as inst:
                print "in text " + str(text) + " : UnhandledException:" + str(inst) + str(type(inst))
            finally:
                if walked % 20 == 0:
                    print str(walked) + " files processed"

print "finished processing. Writing to output file..."

# (text , texttype, restaruant_name , address , price,tags)
store.write('var restaurant = [\n')
for (longitude,latitude) in restaurant_record:
    try:
        data = restaurant_record[(longitude,latitude)]
        output(data[0] , data[1], data[2] , data[3], longitude,latitude,data[4],data[5])
    except Exception as inst:
        print data[0] + " , something wrong here.." + str(inst)
store.write('];')
errorrecord.close()
store.close()
print "success : " + str(success) + " out of " + str(walked)
print "duplicate : "  + str(duplicate)
print "\nIn " + str(time.clock()-start) + "\n"  
