#!/usr/bin/env bash
set -e
#Oprettelse af projektgruppe
#Projektgruppen får en delt mappe på GPFS i mappen "projects". Den fulde sti til denne projektmappe bliver på UNIX: /bigfs/hdfs/projects/<projektnavn>.
#På kac-adm-001 udføres nu følgende som en administratorbruger. 

PROJECT="$1"

#TODO fail if $PROJECT is not set

#Den første #kommando udsteder en Kerberos-ticket som gør at man kan udføre ipa kommandoer.
#Den sidste kommando returnerer projektgruppens GID som skal benyttes ved #oprettelse af projektets brugere. Man opretter nu projektets fælles mappe på GPFS:

ADMIN=$USER-sadm

read -s -p "Password for $ADMIN@KAC.SBLOKALNET: " ADMIN_PASS

ssh -t $ADMIN@kac-adm <<EOI
    set -e
    klist -s || echo -n $ADMIN_PASS | kinit $ADMIN
    ipa group-add $PROJECT
    exit
EOI

ssh -t root@kac-man <<EOI
    set -e
    mkdir \"/bigfs/hdfs/projects/$PROJECT\"
    chown \"root:$PROJECT\" \"/bigfs/hdfs/projects/$PROJECT\"
    chmod 770 \"/bigfs/hdfs/projects/$PROJECT\"
EOI


