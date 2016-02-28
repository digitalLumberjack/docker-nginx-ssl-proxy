#!/bin/bash
[ ! -z "${VIRTUAL_HOST}" ] && sed -i "s/VIRTUAL_HOST/${VIRTUAL_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_HOST}" ] && sed -i "s/APP_HOST/${APP_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_PORT}" ] && sed -i "s/APP_PORT/${APP_PORT}/" /etc/nginx/conf.d/default.conf

if [[ ! -f "/etc/letsencrypt/live/${VIRTUAL_HOST}/fullchain.pem" ]];then 
  /usr/share/letsencrypt/letsencrypt-auto certonly --standalone -n --agree-tos --email ${LETSENCRYPT_EMAIL} -d ${VIRTUAL_HOST}
fi

sed -i "s|SSL_CERTIFICATE|/etc/letsencrypt/live/${VIRTUAL_HOST}/fullchain.pem|" /etc/nginx/conf.d/default.conf
sed -i "s|SSL_KEY|/etc/letsencrypt/live/${VIRTUAL_HOST}/privkey.pem|" /etc/nginx/conf.d/default.conf

/usr/sbin/nginx -g "daemon off;"
