FROM        ubuntu:18.04
MAINTAINER  Frederic Perrouin "frederic@fredprod.com"
ENV REFRESHED_AT 2019-12-17

# Update system
RUN apt-get update && \
	apt-get install -y wget software-properties-common sudo

# Add Salt Ubuntu 16.04 repository
RUN echo deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic  main | tee /etc/apt/sources.list.d/saltstack.list 
RUN wget -qO - http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

# Install salt master/minion/cloud/api
RUN apt-get update && \
	apt-get install -y salt-master salt-minion

# Add salt config files
ADD etc/master /etc/salt/master
ADD etc/minion /etc/salt/minion
ADD etc/reactor /etc/salt/master.d/reactor

# Expose volumes
VOLUME ["/etc/salt", "/var/cache/salt", "/var/log/salt", "/srv/salt"]

# Exposing salt master and api ports
EXPOSE 4505 4506

# Add and set start script
ADD start.sh /start.sh
CMD ["bash", "start.sh"]
