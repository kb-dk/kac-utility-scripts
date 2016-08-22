#!/usr/bin/env bash


ADMIN=abr-sadm
read -s -p "Password for $ADMIN@KAC.SBLOKALNET: " VARIABLE
ssh $ADMIN@kac-adm <<EOI
    set -e
    klist -s || echo -n $VARIABLE | kinit $ADMIN
    #ipa group-add $PROJECT
    exit
EOI

