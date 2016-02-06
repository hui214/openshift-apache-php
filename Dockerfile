FROM gliderlabs/alpine
MAINTAINER Joeri van Dooren <ure@mororless.be>

RUN apk --update add php-apache2 curl php-cli php-json php-phar php-openssl && rm -f /var/cache/apk/* && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
mkdir /app && chown -R apache:apache /app && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

# Run scripts
ADD scripts/run.sh /scripts/run.sh
RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts

# Your app
ADD app/index.php /app/index.php

# Exposed Port
EXPOSE 8080

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]
