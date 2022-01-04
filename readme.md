# Huawei - Monitoramento de BGP

## 🏗️ EM CONSTRUÇÃO 🏗️

> Monitoramento de BGP usando script externo para "pegar" o "nome dos ASN"

## Material de apoio

[Bash split string into array using 4 simple methods](https://www.golinuxcloud.com/bash-split-string-into-array-linux/)

[JSONPath Online Evaluator - jsonpath.com](http://jsonpath.com/)

[JSON Formatter](https://jsonformatter.curiousconcept.com/)

[Bash For Loop Array: Iterate Through Array Values](https://www.cyberciti.biz/faq/bash-for-loop-array/)

[How to use bash array in a shell script](https://linuxconfig.org/how-to-use-arrays-in-bash-script)

[remontti / Zabbix-Templates](https://github.com/remontti/Zabbix-Templates/tree/main/Huawei/BGP)

[LAÇOS OU LOOPS COM SHELL SCRIPT (FOR, WHILE E UNTI](https://www.livrosdelinux.com.br/lacos-ou-loops-for-while-e-until/)

[30 Exemplos de Comando SED Com Regex](https://terminalroot.com.br/2015/07/30-exemplos-do-comando-sed-com-regex.html)

[JavaScript Zabbix preprocessing cheat sheet, substitution samples](https://catonrug.blogspot.com/2019/05/javascript-zabbix-preprocessing-cheat-sheet.html)

[Bash - Parse snmpwalk output](https://stackoverflow.com/questions/36214601/bash-parse-snmpwalk-output)

[Extracting specific data from SNMP](https://unix.stackexchange.com/questions/433873/extracting-specific-data-from-snmp)

[How to split a string into an array in Bash?](https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash)

## Dependências

```sh
apt install whois
cd /usr/lib/zabbix/externalscripts
chown zabbix. /usr/lib/zabbix/externalscripts/asname
chmod +x /usr/lib/zabbix/externalscripts/asname
nano asname
```

## Script

```sh
#! /usr/bin/bash
OID="1.3.6.1.4.1.2011.5.25.177.1.1.2.1";
ASNAMES=$(snmpwalk -v 2c -c $1 $2 $OID.2 | \
    sed 's/.*: //');
SNMPINDEXS=$(snmpwalk -v 2c -c $1 $2 $OID.2 |\
    sed 's/ = .*//' |\
    sed 's/iso.*.1.2.1.2.//');
REMOTEADDS=$(snmpwalk -v 2c -c $1 $2 $OID.4 |\
    sed 's/.*: //' |\
    sed 's/"//' |\
    sed 's/"//');
STATES=$(snmpwalk -v 2c -c $1 $2 $OID.5 | \
    sed 's/.*: //');
# TRANSFORMANDO STRINGS PARA ARRAYS
ARRASNAMES=($ASNAMES);
ARRSNMPINDEXS=($SNMPINDEXS);
ARRREMOTEADDS=($REMOTEADDS);
ARRSTATES=($STATES);
C=0;
MAX=${#ARRASNAMES[@]};
echo "ASNAME|SNMPINDEX|REMOTEADD|STATE";
while [  $C -lt $MAX ];
do
    # ASNAME=${ARRASNAMES[$C]};
    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    echo "$ASNAME|${ARRSNMPINDEXS[$C]}|${ARRREMOTEADDS[$C]}|${ARRSTATES[$C]}"
    let C=C+1;
done
```
