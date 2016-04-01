FROM gliderlabs/alpine
MAINTAINER Joeri van Dooren <ure@mororless.be>

RUN apk --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --update add openssl php-xmlrpc php-zip php-xmlreader php-wddx php-pdo_dblib php-xsl php-zlib php-xml php-mssql php-opcache php-pspell php-pdo_mysql php-sysvsem php-pdo_odbc php-pgsql php-sysvmsg php-phar php-pdo_sqlite php-posix php-pdo_pgsql php-curl php-sqlite3 php-shmop php-soap php-snmp php-sockets php-sysvshm php-gmp php-pdo php-imap php-gd php-openssl php-json php-intl php-ldap php-mysql php-mcrypt php-gettext php-iconv php-pcntl php-mysqli php-odbc php-apache2 php-ctype php-dba php-fpm php-dom php-exif php-phpdbg phpredis curl ssmtp nodejs git mysql-client openssh-client && rm -f /var/cache/apk/* && \

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
