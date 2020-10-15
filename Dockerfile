FROM        centos:7
MAINTAINER  Frederic Perrouin "frederic@fredprod.com"
ENV REFRESHED_AT 2020-10-15

# Update system
RUN	yum -y update

# Add Salt Buster repository
RUN yum -y install https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm && \
    yum clean expire-cache && \
    yum -y install salt-master salt-minion

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor /etc/salt/master.d/reactor

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/log/salt", "/srv/salt"]

# Exposing salt master
EXPOSE 4505 4506

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
