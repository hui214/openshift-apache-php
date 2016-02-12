FROM gliderlabs/alpine
MAINTAINER Joeri van Dooren <ure@mororless.be>

# https://pkgs.alpinelinux.org/packages?name=php%25&repo=all&arch=x86_64&maintainer=all
RUN apk --update add php-apache2 curl php-cli php-json php-phar php-openssl php-pgsql php-mysql php-gd php-gd php-exif php-iconv php-json php-dom php-ftp php-xml php-openssl php-xmlreader php-sockets php-zlib php-zip ssmtp nodejs git && rm -f /var/cache/apk/* && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
mkdir /app && chown -R apache:apache /app && \
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
chmod -R 755 /scripts && chmod -R 755 /etc/ssmtp && chmod a+rw /etc/passwd


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
