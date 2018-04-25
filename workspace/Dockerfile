#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#
# To edit the 'workspace' base Image, visit its repository on Github
#    https://github.com/LaraDock/workspace
#
# To change its version, see the available Tags on the Docker Hub:
#    https://hub.docker.com/r/laradock/workspace/tags/
#

FROM centos:6.9

MAINTAINER Darko Stanimirovic <darko.stanimirovic@gmail.com>

#####################################
# Crontab
#####################################
USER root

COPY ./crontab /var/spool/cron/crontabs

# Upgrade
RUN yum upgrade -y
RUN yum install -y wget tar gcc vim curl unzip telnet lsof

#####################################
# Set Timezone
#####################################

ARG TZ=CDT
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Additional Repos
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm \
    http://rpms.famillecollet.com/enterprise/remi-release-6.rpm \
    yum-utils wget unzip && \
    yum-config-manager --enable remi,remi-php56,remi-php56-debuginfo

# install supervisord
RUN yum --enablerepo=epel install -y supervisor
RUN mv -f /etc/supervisord.conf /etc/supervisord.conf.org

# install rsyslog, crond
RUN yum install -y rsyslog cronie-noanacron && \
    cp -a /etc/pam.d/crond /etc/pam.d/crond.org && \
    sed -i -e 's/^\(session\s\+required\s\+pam_loginuid\.so\)/#\1/' /etc/pam.d/crond

# Make ssh, scp work
ENV ROOT_PASS password
RUN yum install -y openssh-server openssh-clients shadow-utils sudo && \
    sed -i 's/UsePAM\syes/UsePAM no/' /etc/ssh/sshd_config && \
    ssh-keygen -q -b 1024 -N '' -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -b 1024 -N '' -t dsa -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -b 521 -N '' -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    sed -i -r 's/.?UseDNS\syes/UseDNS no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?ChallengeResponseAuthentication.+/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    sed -i -r 's/.?PermitRootLogin.+/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "root:${ROOT_PASS}" | chpasswd && \
    echo -e '\nDefaults:root   !requiretty' >> /etc/sudoers
ADD start_sshd.sh /start_sshd.sh
ADD info.php /var/www/info.php

# Webserver with php
RUN yum groupinstall "Web Server" "PHP Support" "MySQL Database client" -y
ADD start_httpd.sh /start_httpd.sh

#
#--------------------------------------------------------------------------
# mysql-client
#--------------------------------------------------------------------------
#
USER root

RUN yum -y install mysql-server mysql php-pdo_mysql; yum clean all


# Clean up, reduces container size
RUN rm -rf /var/cache/yum/* && yum clean all

EXPOSE 80 22

ADD supervisord.conf /etc/
#CMD ["/usr/bin/supervisord"]

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# Clean up
USER root
# RUN apt-get clean && \
#     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default work directory
WORKDIR /var/www
