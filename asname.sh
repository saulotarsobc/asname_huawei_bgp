#! /usr/bin/bash
OID="1.3.6.1.4.1.2011.5.25.177.1.1.2.1";
ASNAMES=$(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/.*: //');
SNMPINDEXS=$(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/ = .*//' | sed 's/iso.*.1.2.1.2.//');
REMOTEADDS=$(snmpwalk -v 2c -c $1 $2 $OID.4 | sed 's/.*: //' | sed 's/"//' | sed 's/"//');
STATES=$(snmpwalk -v 2c -c $1 $2 $OID.5 | sed 's/.*: //');
# TRANSFORMANDO STRINGS PARA ARRAYS
ARRASNAMES=($ASNAMES);
ARRSNMPINDEXS=($SNMPINDEXS);
ARRREMOTEADDS=($REMOTEADDS);
ARRSTATES=($STATES);
C=0; # CONTADOR
MAX=${#ARRASNAMES[@]}; # QUANTIDADE DE AS's ENCONTRADOS
echo "ASNAME|SNMPINDEX|REMOTEADD|STATE";
while [  $C -lt $MAX ];
do
    # ASNAME=${ARRASNAMES[$C]};
    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    echo "$ASNAME|${ARRSNMPINDEXS[$C]}|${ARRREMOTEADDS[$C]}|${ARRSTATES[$C]}"
    let C=C+1;
done