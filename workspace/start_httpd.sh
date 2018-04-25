#!/bin/bash
## Set password if passed as environment variable
if [ ! -z "${ROOT_PASS}" ]
then
   echo "root:${ROOT_PASS}" | chpasswd
fi

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -D FOREGROUND