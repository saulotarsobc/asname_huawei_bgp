# Material de apoio

[Bash split string into array using 4 simple methods
](https://www.golinuxcloud.com/bash-split-string-into-array-linux/)

[JSONPath Online Evaluator - jsonpath.com
](http://jsonpath.com/)

[JSON Formatter](https://jsonformatter.curiousconcept.com/)

[Bash For Loop Array: Iterate Through Array Values](https://www.cyberciti.biz/faq/bash-for-loop-array/)

[How to use bash array in a shell script](https://linuxconfig.org/how-to-use-arrays-in-bash-script)

[remontti / Zabbix-Templates](https://github.com/remontti/Zabbix-Templates/tree/main/Huawei/BGP)

[LAÇOS OU LOOPS COM SHELL SCRIPT (FOR, WHILE E UNTI](https://www.livrosdelinux.com.br/lacos-ou-loops-for-while-e-until/)

## Dependências

```sh
apt install whois
cd /usr/lib/zabbix/externalscripts
chown zabbix. /usr/lib/zabbix/externalscripts/asname
chmod +x /usr/lib/zabbix/externalscripts/asname
```

## Script

```sh
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
```
