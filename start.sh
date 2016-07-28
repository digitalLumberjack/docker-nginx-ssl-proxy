#!/bin/bash
[ ! -z "${VIRTUAL_HOST}" ] && sed -i "s/VIRTUAL_HOST/${VIRTUAL_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_HOST}" ] && sed -i "s/APP_HOST/${APP_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_PORT}" ] && sed -i "s/APP_PORT/${APP_PORT}/" /etc/nginx/conf.d/default.conf

if [[ ! -f "/root/.stamp_installed" ]];then

  if [[ "${CERTIFICATE_MODE}" == "letsencrypt" ]]; then
    if [[ ! -f "/etc/letsencrypt/live/${VIRTUAL_HOST}/fullchain.pem" ]];then 
      /usr/share/letsencrypt/letsencrypt-auto certonly --standalone -n --agree-tos $([[ "${LETSENCRYPT_ENV}" == "staging" ]] && echo "--staging") --email ${LETSENCRYPT_EMAIL} -d ${VIRTUAL_HOST} || ( echo "Unable to execute letsencrypt" && exit 1 )
    fi
    sed -i "s|SSL_CERTIFICATE|/etc/letsencrypt/live/${VIRTUAL_HOST}/fullchain.pem|" /etc/nginx/conf.d/default.conf
    sed -i "s|SSL_KEY|/etc/letsencrypt/live/${VIRTUAL_HOST}/privkey.pem|" /etc/nginx/conf.d/default.conf
    touch /root/.stamp_installed
  else
    if [[ ! -f "/usr/share/certs/${VIRTUAL_HOST}.pem" ]];then
      echo "Unable to find certificate chain at /usr/share/certs/${VIRTUAL_HOST}.pem" && exit 1
    fi
    if [[ ! -f "/usr/share/certs/${VIRTUAL_HOST}.key" ]];then
      echo "Unable to find key at /usr/share/certs/${VIRTUAL_HOST}.key" && exit 1
    fi
    sed -i "s|SSL_CERTIFICATE|/usr/share/certs/${VIRTUAL_HOST}.pem|" /etc/nginx/conf.d/default.conf
    sed -i "s|SSL_KEY|/usr/share/certs/${VIRTUAL_HOST}.key|" /etc/nginx/conf.d/default.conf
    touch /root/.stamp_installed
  fi
fi


/usr/sbin/nginx -g "daemon off;"
