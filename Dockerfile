FROM alpine:3.4
MAINTAINER Joeri van Dooren <ure@mororless.be>

RUN apk --no-cache add --update tar rsync openssl python ca-certificates ssmtp nodejs git mysql-client openssh-client php5 php5-xmlrpc php5-zip php5-xmlreader php5-wddx php5-pdo_dblib php5-xsl php5-zlib php5-xml php5-mssql php5-opcache php5-pspell php5-pdo_mysql php5-sysvsem php5-pdo_odbc php5-pgsql php5-sysvmsg php5-phar php5-pdo_sqlite php5-posix php5-pdo_pgsql php5-curl php5-sqlite3 php5-shmop php5-soap php5-snmp php5-sockets php5-sysvshm php5-gmp php5-pdo php5-imap php5-gd php5-openssl php5-json php5-intl php5-ldap php5-mysql php5-mcrypt php5-gettext php5-iconv php5-pcntl php5-mysqli php5-odbc php5-apache2 php5-ctype php5-dba php5-fpm php5-dom php5-exif php5-phpdbg phpredis && rm -f /var/cache/apk/* && \
    && update-ca-certificates && \
    apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --update add php5-redis

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
mkdir /app && chmod a+rwx /app && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/ && \
npm install -g bower

# Apache config
ADD httpd.conf /etc/apache2/httpd.conf

# ADD ssmtp
COPY ssmtp /etc/ssmtp

# Run scripts
ADD scripts/run.sh /scripts/run.sh

RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts && chmod -R a+rw /etc/ssmtp && chmod a+rw /etc/passwd


# Your app
ADD app/index.php /app/index.php

# Exposed Port
EXPOSE 8080

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Alpine linux based Apache PHP Container" \
      io.k8s.display-name="alpine apache php" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,html,apache,php" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"
