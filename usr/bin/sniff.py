#!/usr/bin/env python
# import all the needed libraries
import sys
import os.path
import logging

import urllib
import json
import codecs

logging.getLogger("scapy.runtime").setLevel(logging.ERROR)
from scapy.all import *
from subprocess import *
import datetime
import time

# clear the console
call(["clear"])                                           

# define variables                                                          
clients = []                          
uni = 0
mach = []
manu =[]

# our packet handler                                                          
def phandle(p):                       
    global uni    
    if p.haslayer(Dot11ProbeReq):                         
        mac_address = str(p.addr2)
        try:
                url = 'http://macvendors.co/api/%s'
                r = requests.get(url % mac_address)
                obj = r.json()
                company = (obj['result']['company']);

        except Exception:
                company = "unknown"

        print mac_address + " " + company


	macFile="/usr/sniff/" + mac_address

	f = open(macFile,"w")

	now = datetime.datetime.now()

	if(os.path.exists(macFile) or os.path.getsize(macFile) > 0):
		f.write('[{"mac":"'+mac_address+'","company":"'+company+'","lastseen":"'+now.isoformat()+'","nickname":""}]')
	else:	
    		json = json.load(f)
		nickname = json["nickname"]
                f.write('[{"mac":"'+mac_address+'","company":"'+company+'","lastseen":"'+now.isoformat()+'","nickname":"' + nickname + '"}]')

# our main function             
if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description='PyRobe Help')
    parser.add_argument('interface', action="store", help="specify interface (ex. mon0)", default=False)
    parser.add_argument("-l","--log", dest="log",action="store_true", help="print log file")
    args = parser.parse_args()
    sniff(iface=args.interface,prn=phandle, store=0)

    if args.log:
        f = open("ProbeLog"+str(today)+str(tf)+".txt","w")    
        sniff(iface=args.interface,prn=phandle, store=0)                    
        print ("\n")
        print "Unique MACs: ",uni
        f.write ("\nUnique MACs: "+str(uni))
        f.write ("\nScan performed on: "+str(d)+" at"+str(t))  
        f.close()                                                 
        print "Log successfully written. Exiting!"
    else:
        sniff(iface=args.interface,prn=phandle, store=0)
        print "\nSuccessfully Exited! No log file written."
