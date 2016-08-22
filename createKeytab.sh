 > ktutil
#  ktutil:  addent -password -p abr-sadm@KAC.SBLOKALNET -k 1 -e rc4-hmac
##  Password for abr-sadm@KAC.SBLOKALNET: [enter your password]
#  ktutil:  addent -password -p abr-sadm@KAC.SBLOKALNET -k 1 -e aes256-cts
##  Password for abr-sadm@KAC.SBLOKALNET: [enter your password]
#  ktutil:  wkt abr-sadm.keytab
#  ktutil:  quit
mkdir ~/.kerberos
mv abr-sadm.keytab .kerberos/
