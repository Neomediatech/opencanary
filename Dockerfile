FROM debian:jessie
LABEL maintainer="docker-dario@neomediatech.it" 

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

RUN echo $TZ > /etc/timezone && \ 
    rm /bin/sh && ln -s /bin/bash /bin/sh && \
    apt-get update && \
    apt-get install -y tzdata sudo vim build-essential tcpdump libpcap-dev libffi-dev \
    libssl-dev python-dev python-setuptools python-pip python-virtualenv supervisor && \
    rm -rf /var/lib/apt/lists*

RUN mkdir -p /opt/opencanary && virtualenv -p python /opt/opencanary/virtualenv && \
    source /opt/opencanary/virtualenv/bin/activate && \
    pip install pip --upgrade && \
    pip install opencanary && \
    pip install scapy pcapy && \
    pip install rdpy && \
    mkdir -p /opt/opencanary/scripts /data && touch /data/opencanary.log && chmod 666 /data/opencanary.log

COPY conf/opencanary.conf /root/.opencanary.conf
COPY conf/supervise-opencanary.conf /etc/supervisor/conf.d/supervise-opencanary.conf
COPY scripts/startcanary.sh /opt/opencanary/scripts/startcanary.sh

RUN chmod +x /opt/opencanary/scripts/startcanary.sh && chmod 777 /data

#CMD ["/usr/bin/supervisord", "-n"]
CMD ["/opt/opencanary/scripts/startcanary.sh"]