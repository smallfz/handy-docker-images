#!/bin/bash

firewall-cmd --zone=dmz --permanent --add-rich-rule='rule protocol value="esp" accept' # ESP (the encrypted data packets)
firewall-cmd --zone=dmz --permanent --add-rich-rule='rule protocol value="ah" accept' # AH (authenticated headers)
firewall-cmd --zone=dmz --permanent --add-port=500/udp #IKE  (security associations)
firewall-cmd --zone=dmz --permanent --add-port=4500/udp # IKE NAT Traversal (IPsec between natted devices)
firewall-cmd --permanent --add-service="ipsec"
firewall-cmd --zone=dmz --permanent --add-masquerade
firewall-cmd --permanent --set-default-zone=dmz
firewall-cmd --reload
firewall-cmd --list-all
