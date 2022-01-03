#! /usr/bin/bash
ASNAMES=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.2  | sed 's/.*: //');
ARRASNAMES=($ASNAMES);

SNMPINDEXS=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.2 | sed 's/ = .*//'  | sed 's/iso.3.6.1.4.1.2011.5.25.177.1.1.2.1.2.//');
ARRSNMPINDEXS=($SNMPINDEXS);

REMOTEADDS=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.4 | sed 's/.*: //' | sed 's/"//' | sed 's/"//');
ARRREMOTEADDS=($REMOTEADDS);

STATES=$(snmpwalk -v 2c -c $1 $2 1.3.6.1.4.1.2011.5.25.177.1.1.2.1.5 | sed 's/.*: //');
ARRSTATES=($STATES);

C=0;
MAX=${#ARRASNAMES[@]};

echo '[';

while [  $C -lt $MAX ]; do
    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    SNMPINDEX=${ARRSNMPINDEXS[$C]};
    REMOTEADD=${ARRREMOTEADDS[$C]};
    STATE=${ARRSTATES[$C]};
    echo '{"ASNAME":"'$ASNAME'","SNMPINDEX":"'$SNMPINDEX'","REMOTEADD":"'$REMOTEADD'","STATE":"'$STATE'"},'
    let C=C+1;
done

echo ']'