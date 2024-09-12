#!/bin/bash -e

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Mounting the secrets that we have as files
echo ">> Secrets and Configs Manipulation <<"
cp /opt/fts3/fts3-host-pems/hostcert.pem /etc/grid-security/
chmod 644 /etc/grid-security/hostcert.pem
chown root:root /etc/grid-security/hostcert.pem
cp /opt/fts3/fts3-host-pems/hostkey.pem /etc/grid-security/
chmod 400 /etc/grid-security/hostkey.pem
chown root:root /etc/grid-security/hostkey.pem
#! HERE: Fail to copy (/opt/fts3/fts3-configs/ca.crt does not exist...)
# cp /opt/fts3/fts3-configs/ca.crt /etc/grid-security/certificates/docker-entrypoint_ca.crt
cp /opt/fts3/fts3-configs/fts3config /etc/fts3/fts3config
cp /opt/fts3/fts3-configs/fts-msg-monitoring.conf /etc/fts3/fts-msg-monitoring.conf
#! HERE: Mount path /etc/fts3/fts3restconfig exists in PROD but not in dev... to be fixed
#! Commented to avoid error in PROD 
# cp /opt/fts3/fts3-configs/fts3restconfig /etc/fts3/fts3restconfig
chown root:apache /etc/fts3web/fts3web.ini
chown -R fts3:fts3 /var/log/fts3rest


if [[ ! -z "${DATABASE_UPGRADE}" ]]; then
   echo ">> Database Upgrade <<"
   yes Y | python /usr/share/fts/fts-database-upgrade.py
fi
if [[ ! -z "${REST_HOST}" ]]; then
   echo ">> Replace Host <<"
   replaceCommand="sed -i -e 's/*/${REST_HOST}/g' /etc/httpd/conf.d/fts3rest.conf"
   eval $replaceCommand
fi
if [[ -z "${WEB_INTERFACE}" ]]; then
   echo ">> Remove FST Mon <<"
   rm /etc/httpd/conf.d/ftsmon.conf
else
   echo ">> Set FTS3 Aliases <<"
   echo "${HOSTNAME} ${WEB_INTERFACE}" > /etc/fts3/host_aliases
fi

#! HERE: Do we need to run again? It fails to execute but this is an init container process already (okd)
# echo ">> START fetch-crl <<"
# fetch-crl  

echo ">> START httpd <<"                                                      
httpd

echo ">> EXEC restart_httpd.sh <<"
echo 'while true; do sleep 3600; &>/dev/null httpd -k graceful; done' > /root/restart_httpd.sh
chmod +x /root/restart_httpd.sh
nohup /root/restart_httpd.sh &

echo ">> START supervisord <<"
supervisord -c /etc/supervisord.conf --nodaemon
