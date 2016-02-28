#!/bin/bash
[ ! -z "${VIRTUAL_HOST}" ] && sed -i "s/VIRTUAL_HOST/${VIRTUAL_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_HOST}" ] && sed -i "s/APP_HOST/${APP_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_PORT}" ] && sed -i "s/APP_PORT/${APP_PORT}/" /etc/nginx/conf.d/default.conf

/usr/share/letsencrypt/letsencrypt-auto certonly --standalone -n --agree-tos --email ${LETSENCRYPT_EMAIL} -d ${VIRTUAL_HOST}

sed -i "s|SSL_CERTIFICATE|/etc/letsencrypt/archive/${VIRTUAL_HOST}/fullchain1.pem|" /etc/nginx/conf.d/default.conf
sed -i "s|SSL_CERTIFICATE|/etc/letsencrypt/archive/${VIRTUAL_HOST}/privkey1.pem|" /etc/nginx/conf.d/default.conf

/usr/sbin/nginx -g "daemon off;"
