# -*- coding: big5 -*-
import re
import sys

errorrecord = open('errorrecord.txt','w')
prompt = raw_input('specify output file\n')
store  = open(prompt,'w')

rootdir = sys.path[0]



google_url = 'http://maps.google.com/maps/geo?q='

class WrongTextTypeError(Exception):
    def __init__(self,text,value):
        errorrecord.write( str(text) + " Error: Wrong text type : " + value + '\n')
        
class ImportantDataMissingError(Exception):
    def __init__(self,text,failedQuery):
        if failedQuery is False:
            errorrecord.write( str(text) + ' Error: ' + 'name or address' + ' failed to collect\n')
        else:
            errorrecord.write( str(text) + ' Error: ' + 'in querying google for coordinates\n')

def outputInJavascriptFormat(textno,texttype,name,address,longitude,latitude,price,kinds):
    texttype = texttype.replace('\\','').replace('\'','\\\'')
    name = name.replace('\\','').replace('\'','\\\'')
    address = address.replace('\\','').replace('\'','\\\'')
    texttype = texttype.decode('big5').encode('utf-8')
    name = name.decode('big5').encode('utf-8')
    address = address.decode('big5').encode('utf-8')
    store.write('{' + '\'id\':' + textno + ',' + '\'texttype\': \'' + texttype + '\', ' + '\'name\': \'' +  name + '\', ' + '\'address\': \'' + address
                + '\', ' +'\'position\': [' + longitude + ',' + latitude + '],' + '\'price\': ')
    if price == 'null':
        store.write('null')
    else:
        temp = price.copy()
        store.write('[' + temp.pop().decode('big5').encode('utf-8'))
        for foo in temp:
            store.write(',' + foo.decode('big5').encode('utf-8') )
        store.write(']')

    temp = kinds.copy()

    store.write(',\'kind\':[\'' + temp.pop().encode('utf-8') + '\'')

    for kind in temp:
        store.write(',\'' + kind.encode('utf-8') + '\'')
    store.write(']},\n')

       
patterns =  {'restaurant' : re.compile(re.escape('餐廳名稱') +'[ ：:]*(.+)' ),
            'address'     : re.compile(re.escape('地') +' *' + re.escape('址')  +'.*[：:](.+)'),
            'coordinates' : re.compile('"coordinates": \[ ([\d\.\-]+), ([\d\.\-]+),'),
            'texttype'    : re.compile(re.escape('標題')+'.*?\[(.*?)\].*'),
            'price'       : re.compile('每人平均價位 *[：:]*(.+)|價位(範圍)?(\(每人\))?[ ：:]*(.+)'),
            'priceparse'  : re.compile('(\d+)')
            #priceparse  = re.compile('(\d+)([ 元]*)([ -~至到]*)(\d*)([ 元]*)')
           }


