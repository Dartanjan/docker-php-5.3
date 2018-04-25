FROM mysql:5.6

MAINTAINER Mahmoud Zalt <mahmoud@zalt.me>

USER root
RUN chown -R mysql:mysql /var/lib/mysql/
RUN chown -R mysql:mysql /etc/mysql/

ADD startup /etc/mysql/startup

ARG MYSQL_DATABASE=citizenshipper
ARG MYSQL_USER=darko
ARG MYSQL_PASSWORD=secret
ARG MYSQL_ROOT_PASSWORD=root

ENV MYSQL_DATABASE=$MYSQL_DATABASE
ENV MYSQL_USER=$MYSQL_USER
ENV MYSQL_PASSWORD=$MYSQL_PASSWORD
ENV MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

RUN sed -i 's/MYSQL_DATABASE/'$MYSQL_DATABASE'/g' /etc/mysql/startup && \
    sed -i 's/MYSQL_USER/'$MYSQL_USER'/g' /etc/mysql/startup && \
    sed -i 's/MYSQL_PASSWORD/'$MYSQL_PASSWORD'/g' /etc/mysql/startup

# COPY my.cnf /etc/mysql/my.cnf
COPY my.cnf /var/lib/mysql/conf.d/my.cnf

#####################################
# Set Timezone
#####################################

ARG TZ=CST
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN mysql_upgrade

# USER mysql
CMD ["mysqld", "--init-file=/etc/mysql/startup"]

EXPOSE 3306
