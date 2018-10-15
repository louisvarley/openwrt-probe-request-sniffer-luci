# openwrt-probe-request-sniffer-luci
A Wifi Probe Request Python Script with a Luci page to read the contents


# What this does?

Just an experiment, the python script uses scapy to monitor for wifi probe requests from devices which are not connected to a wifi connection. 

When the script finds a probe request packet it logs it into a file in the /usr/sniff directory. The file contains json for the mac, the vendor and the last seen time, along with a nickname you can set in luci to make tracking easier. 

# How to setup?

Setup an interface at wlan0 in monitor mode. (or change script, interface is set at the bottom of script in /usr/bin/)

There are a number of Python requirements so you really need your FS to be on a USB for this to run. 

`opkg install python
opkg install python-pip
opkg install scapy
pip install scapy
pip install requests`

extract all contents to the directorties given. 

chmod +x the /etc/init.d/sniff file. 

then /etc/init.d/sniff start 

on Luci, you should see under services/probe sniffer a list of Mac Addresses and vendors the script found. and when they were last seen, 

![Screenshot](https://raw.githubusercontent.com/SEAL-team-ricks/openwrt-probe-request-sniffer-luci/master/screenshot.png)

Did you want this actually put into a usable ipkg? i tend to just store code on github, feel free to fork if this project is useful or reuse code or just shout at me that you wanted an ipkg
