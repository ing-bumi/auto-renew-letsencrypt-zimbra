#!/bin/bash

#Set domain for renew (in format openthreat.ro)
DOMAIN=""

#Stop the jetty or nginx service at Zimbra level
runuser -l zimbra -c 'zmproxyctl stop'
runuser -l zimbra -c 'zmmailboxdctl stop'

#Renew SSL
certbot-auto renew --standalone

#Unduh FIle yang di butuhkan
wget -P /etc/letsencrypt/live/mail.$DOMAIN/ https://letsencrypt.org/certs/isrgrootx1.pem.txt

wget -P /etc/letsencrypt/live/mail.$DOMAIN/ https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt

#Sesuiakan folder letsencrypt di server anda
cat /etc/letsencrypt/live/mail.zimbra.com/isrgrootx1.pem.txt letsencryptauthorityx3.pem.txt chain.pem > combined.pem

#Copy new SSL to Zimbra SSL folder
cp /etc/letsencrypt/live/mail.$DOMAIN/* /opt/zimbra/ssl/letsencrypt/
chown zimbra:zimbra /opt/zimbra/ssl/letsencrypt/*

#Backup Zimbra SSL directory
cp -a /opt/zimbra/ssl/zimbra /opt/zimbra/ssl/zimbra.$(date "+%Y%m%d")

#Copy the private key under Zimbra SSL path
cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key

#Final SSL deployment
runuser -l zimbra -c 'cd /opt/zimbra/ssl/letsencrypt/ && /opt/zimbra/bin/zmcertmgr deploycrt comm cert.pem combined.pem'
runuser -l zimbra -c 'zmcontrol restart'
