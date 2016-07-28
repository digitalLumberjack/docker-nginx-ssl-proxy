# docker-nginx-ssl-proxy

Create a nginx ssl in front of any webapp.  
Uses https://letsencrypt.org/ to create dynamically a valid ssl certificate.

Use the following ENV when running : 
- ENV APP_PORT : the port of the app on the linked container
- ENV APP_HOST : the linked container hostname
- ENV VIRTUAL_HOST : your domain name (the dns must be redirected to your container for letsencrypt to validate the certificate
- CERTIFICATE_MODE : the certificate mode ( 'letsencrypt' or 'provided' )
- ENV LETSENCRYPT_EMAIL : your email account on letencrypt 
- ENV LETSENCRYPT_ENV : prod for production, staging for testing purpose (ssl certifcates will not be valid)

Run with a docker-compose or directly by linking the application container in command line.
