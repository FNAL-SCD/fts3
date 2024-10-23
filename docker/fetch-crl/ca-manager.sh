#!/bin/bash
#
# Dockerentry point for the OSG CA certificate management container in OKD
# Adaptation from Farrukh script to help our fetch-crl-cron jobs to not exit

## These are the global constants ##
# Command to initialize the certificate directory
cacert_init="/usr/sbin/osg-ca-manage setupCA --location root --url osg"

# Command to update the certificate directory
cacert_update=/usr/sbin/osg-update-certs

# Command to fetch certificate revocation list
cacert_crl="/usr/sbin/fetch-crl -v"

# base directory
cacert_base=/etc/grid-security

# creating the certificate directory
printf ">> Checking ${cacert_base} to see if certificates exist\n"
if [ ! -h "${cacert_base}/certificates" ]; then
  printf ">> ${cacert_base}/certificates does not exist. Downloading certificates...\n"

  # Initializing certificate directory and configuration
  $cacert_init
  if [ $? -ne 0 ]; then
    printf "\nCommand exited with a non zero status code\n"
    exit $?
  fi
fi

# Setting up the right configuration for cloning
printf "\n>> ${cacert_base}/certificates exists. Setting up correct configuration\n"

echo "install_dir = /etc/grid-security" >> /etc/osg/osg-update-certs.conf
if [ $? -ne 0 ]; then
  exit 1
fi

echo "cacerts_url = https://repo.opensciencegrid.org/cadist/ca-certs-version-new" >> /etc/osg/osg-update-certs.conf
if [ $? -ne 0 ]; then
  exit 1
fi

echo "log = /var/log/osg-update-certs.log" >> /etc/osg/osg-update-certs.conf
if [ $? -ne 0 ]; then
  exit 1
fi

# Certificates directory exists, check for updates
printf "\n>> Checking for updates...\n"
$cacert_update
if [ $? -ne 0 ]; then
  printf "\nCommand exited with a non zero status code\n"
fi

# Certificates directory exists, update CRLs
printf "\n>> Fetching CRLs...\n"
$cacert_crl
if [ $? -ne 0 ]; then
  printf "\nCommand exited with a non zero status code\n"
fi

# exit 0 in all cases
exit 0