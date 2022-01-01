#! /usr/bin/bash
# 1 - comunidade snmp
# 2 - ip do dispositivo

#  ASNAME
## SNMPWALK NO OID QUE RETORNA OS ASNAME
ASNAMES=$(snmpwalk -v 2c -c $1 $2 | cut  -d ":" -f 2 | sed -e "s/^[ \t]*//");
ASNAMES=$(echo $ASNAMES);
read -a ARRASNAMES <<< $ASNAMES;

#  SNMPINDEX
## SNMPWALK NO OID QUE RETORNA OS IPS >> CORRIGIR
SNMPINDEXS=$(snmpwalk -v 2c -c 10l15p130A@huawei 45.7.118.1 1.3.6.1.2.1.15.3.1.7 | cut  -d ":" -f 2 | sed -e "s/^[ \t]*//");
SNMPINDEXS=$(echo $SNMPINDEXS);
read -a ARRSNMPINDEXS <<< $SNMPINDEXS;

C=0; # CONTADOR
MAX=${#ARRASNAMES[@]}; # QUANTIDADE DE ITENS NO ARRAY

echo '[';
while [  $C -lt $MAX ]; do
    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    SNMPINDEX=${ARRSNMPINDEXS[$C]};
    echo '{"ASNAME":"'$ASNAME'","SNMPINDEX":"'$SNMPINDEX'"},'
    let C=C+1;
done
echo ']';