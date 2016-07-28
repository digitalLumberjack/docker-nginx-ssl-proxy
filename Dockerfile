FROM nginx:1.9.9
MAINTAINER DigitalLumberjack <digitallumberjack@gmail.com>

ENV APP_PORT 9000
ENV APP_HOST localhost
ENV VIRTUAL_HOST localhost
ENV CERTIFICATE_MODE letsencrypt
ENV LETSENCRYPT_EMAIL replaceme@gmail.com
ENV LETSENCRYPT_ENV staging

RUN apt-get -y update && apt-get -y install git

RUN cd /usr/share
RUN git clone https://github.com/letsencrypt/letsencrypt /usr/share/letsencrypt
RUN chmod +x /usr/share/letsencrypt/letsencrypt-auto 
RUN /usr/share/letsencrypt/letsencrypt-auto --help

COPY ./default.conf /etc/nginx/conf.d/
COPY ./start.sh /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
