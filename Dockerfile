FROM        debian:8
MAINTAINER  Frederic Perrouin "frederic@fredprod.com"
ENV REFRESHED_AT 2016-09-14

# Update system
RUN apt-get update && \
	apt-get install -y wget curl dnsutils python-pip python-dev python-apt software-properties-common dmidecode sudo

# Add Debian Jessie backports
RUN echo deb http://ftp.debian.org/debian jessie-backports main | tee /etc/apt/sources.list.d/jessie-backports.list 

# Install salt master/minion/cloud/api
RUN apt-get update && \
	apt-get install -y -t jessie-backports salt-master salt-minion \
	salt-cloud salt-api

# Setup halite
RUN pip install cherrypy docker-py halite

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor /etc/salt/master.d/reactor

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/logs/salt", "/srv/salt"]

# Exposing salt master and api ports
EXPOSE 4505 4506 8080 8081

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
