#!/bin/bash

cd /etc/strongswan

strongswan pki --gen --type rsa --size 4096 --outform der > ipsec.d/private/strongswanKey.der
chmod 600 ipsec.d/private/strongswanKey.der

strongswan pki --self --ca --lifetime 3650 --in ipsec.d/private/strongswanKey.der --type rsa --dn "C=NL, O=Org, CN=strongSwan Root CA" --outform der > ipsec.d/cacerts/strongswanCert.der

