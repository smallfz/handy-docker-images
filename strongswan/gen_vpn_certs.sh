#!/bin/bash

SERVERIP=`curl http://ip.mtak.nl`

cd /etc/strongswan/ipsec.d

strongswan pki --gen --type rsa --size 4096 --outform der > private/vpnHostKey.der
chmod 600 private/vpnHostKey.der

strongswan pki --pub --in private/vpnHostKey.der --type rsa > ./vpnHostKey.pub
strongswan pki --issue --in ./vpnHostKey.pub --lifetime 730 --cacert cacerts/strongswanCert.der --cakey private/strongswanKey.der --dn "C=NL, O=Org, CN=ipsec02.bluemask.net" --san ipsec02.bluemask.net --san $SERVERIP  --san @$SERVERIP --flag serverAuth --flag ikeIntermediate --outform der > certs/vpnHostCert.der

strongswan pki --print --in certs/vpnHostCert.der

