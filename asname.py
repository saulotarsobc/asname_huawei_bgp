#! /usr/bin/python3
import os
import re
import json
import sys

if len(sys.argv) != 4:
    print('script <ip> <snmp port> <snmo community>')

else:
    IP = sys.argv[1]
    PORT = sys.argv[2]
    CM = sys.argv[3]
    
asIndex = []
asNun = []
asStatus = []
asRemoteAddress = []
asName = []
final = []


def snmpwalk(ip, port, cm, oid):
    return os.popen(f'snmpwalk -v 2c -c {cm} {ip}:{port} {oid}').read()


def getIndexAndAsnun():
    for row in snmpwalk(IP, PORT, CM, '1.3.6.1.4.1.2011.5.25.177.1.1.2.1.2').split('\n'):
        if row:
            rowSplited = re.split('.*1.1.2.1.2.0.(.*)\s\=.*:\s(.*)', row)
            asIndex.append(rowSplited[1])
            asNun.append(rowSplited[2])


def getStatus():
    for row in snmpwalk(IP, PORT, CM, '1.3.6.1.4.1.2011.5.25.177.1.1.2.1.5').split('\n'):
        if row:
            rowSplited = re.split('.*:\s(.*)', row)
            asStatus.append(rowSplited[1])


def getAsAdress():
    for row in snmpwalk(IP, PORT, CM, '1.3.6.1.4.1.2011.5.25.177.1.1.2.1.4').split('\n'):
        if row:
            rowSplited = re.split('.*:\s(.*)', row)
            asRemoteAddress.append(rowSplited[1].replace('"', ''))


def getAsName():
    for nun in asNun:
        names = os.popen(
            f'whois -h whois.cymru.com  AS{nun} | egrep -v "AS Name"').read().split('\n')
        for name in names:
            if name:
                asName.append(name)


def main():
    
    getIndexAndAsnun()
    getStatus()
    getAsAdress()
    getAsName()

    cont = 0
    limite = len(asIndex)

    while cont < limite:
        final.append({
            '{#SNMPINDEX}': asIndex[cont],
            '{#AS}': asNun[cont],
            '{#STATUS}': asStatus[cont],
            '{#REMOTE_ADDRESS}': asRemoteAddress[cont],
            '{#ASNAME}': asName[cont],
        })
        cont = cont + 1

    print(json.dumps(final))


if __name__ == '__main__':
    main()
