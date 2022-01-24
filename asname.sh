#! /usr/bin/bash
alert(){
    echo -e "Tente algo como: ./asname <DEVICE_COMUNITY> <DEVICE_IP>\nOu no zabbix: asname[{\$SNMP_COMMUNITY}, {HOST.IP}]";
    exit 0;
}

if [ "$1" = "" ]; then alert; fi; 
if [ "$2" = "" ]; then alert; fi;

OID="1.3.6.1.4.1.2011.5.25.177.1.1.2.1";

as=($(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/.*: //'));
snmpindexs=($(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/ = .*//' | sed 's/iso.*.1.2.1.2.//'));
remoteaddress=($(snmpwalk -v 2c -c $1 $2 $OID.4 | sed 's/.*: //' | sed 's/"//' | sed 's/"//'));
states=($(snmpwalk -v 2c -c $1 $2 $OID.5 | sed 's/.*: //'));

echo "ASNAME|SNMPINDEX|REMOTEADD|STATE";

C=0;
for i in "${as[@]}"; do
    ASNAME=$(whois -h whois.cymru.com  AS$i | egrep -v "AS Name");
    echo "$ASNAME|${snmpindexs[$C]}|${remoteaddress[$C]}|${states[$C]}";
    let C=C+1;
done;