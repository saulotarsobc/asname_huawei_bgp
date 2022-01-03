#! /usr/bin/bash
# PARAMETROS
# 1 - comunidade snmp
# 2 - ip do dispositivo
# cd /usr/lib/zabbix/externalscripts
# APAGAR
# echo "" > asname ; nano asname

# ASNAME ## SNMPWALK NO OID QUE RETORNA OS ASNAME
ASNAMES=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.2  | sed 's/.*: //');
ARRASNAMES=($ASNAMES);

# SNMPINDEX ## SNMPWALK NO OID QUE RETORNA OS INDEX SNMP
SNMPINDEXS=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.2 | sed 's/ = .*//'  | sed 's/iso.3.6.1.4.1.2011.5.25.177.1.1.2.1.2.//');
ARRSNMPINDEXS=($SNMPINDEXS);

# REMOTEADD ## SNMPWALK NO OID QUE RETORNA OS REMOTE ADDRESS
REMOTEADDS=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.4 | sed 's/.*: //' | sed 's/"//' | sed 's/"//');
ARRREMOTEADDS=($REMOTEADDS);

C=0; # CONTADOR
MAX=${#ARRASNAMES[@]}; # QUANTIDADE DE ITENS NO ARRAY

echo '[{"BGP": [';
while [  $C -lt $MAX ]; do

    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    SNMPINDEX=${ARRSNMPINDEXS[$C]};
    REMOTEADD=${ARRREMOTEADDS[$C]};

    echo '{"ASNAME":"'$ASNAME'","SNMPINDEX":"'$SNMPINDEX'","REMOTEADD":"'$REMOTEADD'"},'

    let C=C+1;

done
echo ']}]'