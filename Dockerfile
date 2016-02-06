FROM gliderlabs/alpine
MAINTAINER Joeri van Dooren <ure@mororless.be>

RUN apk --update add php-apache2 curl php-cli php-json php-phar php-openssl && rm -f /var/cache/apk/* && \
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
mkdir /app && chown -R apache:apache /app && \
sed -i 's#^DocumentRoot ".*#DocumentRoot "/app"#g' /etc/apache2/httpd.conf && \
sed -i 's#^Listen 80#Listen 8080#g' /etc/apache2/httpd.conf && \
sed -i 's#ErrorLog logs/error.log#ErrorLog "|/bin/cat"#g' /etc/apache2/httpd.conf && \
sed -i 's#CustomLog logs/access.log combined#CustomLog "|/bin/cat" combined#g' /etc/apache2/httpd.conf && \
sed -i 's#^.ServerName www.example.com:80#ServerName apache#g' /etc/apache2/httpd.conf && \
sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf && \
mkdir /run/apache2/ && \
chmod a+rwx /run/apache2/

ADD scripts/run.sh /scripts/run.sh

RUN mkdir /scripts/pre-exec.d && \
mkdir /scripts/pre-init.d && \
chmod -R 755 /scripts

EXPOSE 8080

# VOLUME /app
WORKDIR /app

ENTRYPOINT ["/scripts/run.sh"]
