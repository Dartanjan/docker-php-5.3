FROM webdevops/apache:centos-7

MAINTAINER Eric Pfeiffer <computerfr33k@users.noreply.github.com>

ARG PHP_SOCKET=php-fpm:9000

ENV WEB_PHP_SOCKET=$PHP_SOCKET
ENV WEB_DOCUMENT_INDEX=index.php
ENV WEB_DOCUMENT_ROOT=/var/www

ADD ./server.crt /opt/docker/etc/httpd/ssl/server.crt
ADD ./server.key /opt/docker/etc/httpd/ssl/server.key
ADD ./cs.conf /etc/httpd/conf.d/cs.conf

EXPOSE 80 443

WORKDIR /var/www

ENTRYPOINT ["/opt/docker/bin/entrypoint.sh"]

CMD ["supervisord"]
