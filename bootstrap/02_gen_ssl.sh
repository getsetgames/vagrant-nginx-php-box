#!/bin/bash

set -e

# TODO Determine if this bash script can be replaced using Puppet

#SSLDIR=/etc/apache2/ssl
SSLDIR=/vagrant

#hostname=$(ipconfig getifaddr en0)
SSLHOSTNAME='test.getsetgames.com'


SSL_KEY_FILE=${SSLDIR}/server.key
if [ -f ${SSL_KEY_FILE} ]; then
    echo "Key file already exists."
else
    openssl genrsa -out ${SSL_KEY_FILE} 2048
fi

SSL_CERT_FILE=${SSLDIR}/server.crt
if [ -f ${SSL_CERT_FILE} ]; then
    echo "Certificate file already exist."
else
    openssl req -new -x509 -key ${SSL_KEY_FILE} -out ${SSL_CERT_FILE} -days 365 -subj /CN=${SSLHOSTNAME}
fi
