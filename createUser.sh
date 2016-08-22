#!/usr/bin/env bash

#Oprettelse af brugere
#Hvis man er logget ud skal man igen bede om Kerberos-ticket fra freeIPA:


#Opret nu alle de nye brugere:
#TODO Read these from params
FIRST=fornavn
LAST=efternavn
INITIALS=test
EMAIL=email@email.com
ORGUNIT=institute
PROJECT=p001
#TODO fail if any of these variables is not set is not set
#todo test format of names and so on

USERNAME=$PROJECT$INITIALS # navngivningsstandard for brugere

ADMIN=$USER-sadm # eller sbadmin

read -s -p "Password for $ADMIN@KAC.SBLOKALNET: " ADMIN_PASS

ssh -t root@kac-adm <<EOI
    set -e
    klist -s || echo -n $ADMIN_PASS | kinit $ADMIN

    # hack med yes til at besvare password prompten med 'abc123'
    yes abc123 | echo ipa user-add --first=\"$FIRST\" --last=\"$LAST\" --homedir=\"/home/$USERNAME\" --shell=/bin/bash --email=\"$EMAIL\" --password --gidnumber=\$(getent group $PROJECT | cut -d':' -f3) --noprivate --orgunit=\"$ORGUNIT\" \"$USERNAME\"

    #Alle de nye brugere skal også knyttes til biusers og projekt gruppen, som gøre med:
    ipa group-add-member \"$PROJECT\" --users=\"$USERNAME\"
    ipa group-add-member biusers --users=\"$USERNAME\"

    #Herefter oprettes hver brugers hjemmemappe på NFS:
    mkdir \"/data/home/$USERNAME\"
    chown \"$USERNAME:$PROJECT\" \"/data/home/$USERNAME\"
    chmod 700 \"/data/home/$USERNAME\"
EOI

echo "Alle nye brugere skal skifte kodeordet 'abc123' ved personligt fremmøde til et hemmeligt kodeord. Dette gøres på https://kac-adm-001.kac.sblokalnet/ipa "

echo "Slutteligt skal Ambari importere den nye bruger (det er relevant hvis vi bruger #ambari views til brugere)"

echo -e "$ADMIN\n$ADMIN_PASS\n" | ssh -t root@kac-man sudo service ambari-server sync-ldap --all

