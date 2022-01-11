# Huawei - Monitoramento de BGP

> Monitoramento de BGP usando script externo para "pegar" o "nome dos ASN".

## Material de apoio

[Bash split string into array using 4 simple methods](https://www.golinuxcloud.com/bash-split-string-into-array-linux/)

[JSONPath Online Evaluator - jsonpath.com](http://jsonpath.com/)

[JSON Formatter](https://jsonformatter.curiousconcept.com/)

[Bash For Loop Array: Iterate Through Array Values](https://www.cyberciti.biz/faq/bash-for-loop-array/)

[remontti / Zabbix-Templates](https://github.com/remontti/Zabbix-Templates/tree/main/Huawei/BGP)

[LAÇOS OU LOOPS COM SHELL SCRIPT (FOR, WHILE E UNTIL)](https://www.livrosdelinux.com.br/lacos-ou-loops-for-while-e-until/)

[30 Exemplos de Comando SED Com Regex](https://terminalroot.com.br/2015/07/30-exemplos-do-comando-sed-com-regex.html)

[JavaScript Zabbix preprocessing cheat sheet, substitution samples](https://catonrug.blogspot.com/2019/05/javascript-zabbix-preprocessing-cheat-sheet.html)

[Bash - Parse snmpwalk output](https://stackoverflow.com/questions/36214601/bash-parse-snmpwalk-output)

[Extracting specific data from SNMP](https://unix.stackexchange.com/questions/433873/extracting-specific-data-from-snmp)

[How to split a string into an array in Bash?](https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash)

[Unix / Linux - Shell Basic Operators](https://www.tutorialspoint.com/unix/unix-basic-operators.htm)

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
#! /bin/bash
alert(){
    echo -e "msg\nTry something like '{\$SNMP_COMMUNITY}, {HOST.IP}'"; exit 0;
}

if [ "$2" = "" ]; then alert; fi;

OID="1.3.6.1.4.1.2011.5.25.177.1.1.2.1";

ASNAMES=$(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/.*: //');
SNMPINDEXS=$(snmpwalk -v 2c -c $1 $2 $OID.2 | sed 's/ = .*//' | sed 's/iso.*.1.2.1.2.//');
REMOTEADDS=$(snmpwalk -v 2c -c $1 $2 $OID.4 | sed 's/.*: //' | sed 's/"//' | sed 's/"//');
STATES=$(snmpwalk -v 2c -c $1 $2 $OID.5 | sed 's/.*: //');

# TRANSFORMANDO STRINGS EM ARRAYS
ARRASNAMES=($ASNAMES);
ARRSNMPINDEXS=($SNMPINDEXS);
ARRREMOTEADDS=($REMOTEADDS);
ARRSTATES=($STATES);

C=0; # CONTADOR
MAX=${#ARRASNAMES[@]}; # QUANTIDADE DE AS's ENCONTRADOS

echo "ASNAME|SNMPINDEX|REMOTEADD|STATE";
while [  $C -lt $MAX ]; do
    ASNAME=$(whois -h whois.cymru.com  AS${ARRASNAMES[$C]} | egrep -v "AS Name");
    echo "$ASNAME|${ARRSNMPINDEXS[$C]}|${ARRREMOTEADDS[$C]}|${ARRSTATES[$C]}"
    let C=C+1;
done;
```

## Pré-processamento - Zabbix

> Esse script tem o [CSV](https://rockcontent.com/br/blog/csv/) como formato de saida de dados. Por isso vamos usar o pre-processamento do Zabbix para converte-lo para um formato Json.

![Zabbix - Pre-processamento](img/pre%20processamento.png)

1) Nome: "CSV to JSON".
2) Parâmetros: "|" (pipe).
   1) Esse sinal é o que delimita as informações do nosso CSV. Geralmente usamos a vírgula para isso. Mas como o 'nome do asn' pode conter virgulas tambem, optei por separar as informações com o "|" (pipe).

[Template - Zabbix 5.4](SC%20-%20Huawei%20NE40%20-%20NE8000%20-%20BGP%20-%20ASNAME%20-%20ZABBIX%205_4_9.yaml)
