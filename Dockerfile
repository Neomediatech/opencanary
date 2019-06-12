FROM debian:jessie
LABEL maintainer="docker-dario@neomediatech.it"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Rome

RUN echo $TZ > /etc/timezone && \
    rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && \
    apt-get install -y tzdata sudo vim build-essential tcpdump libpcap-dev libffi-dev \
    libssl-dev python-dev python-setuptools python-pip python-virtualenv supervisor && \
    rm -rf /var/lib/apt/lists* && \
    mkdir -p /opt/opencanary && virtualenv -p python /opt/opencanary/virtualenv && \
    source /opt/opencanary/virtualenv/bin/activate && \
    pip install pip --upgrade && \
    pip install opencanary && \
    pip install scapy pcapy && \
    pip install rdpy && \
    mkdir -p /opt/opencanary/scripts /data && touch /data/opencanary.log && chmod 666 /data/opencanary.log && \
    apt-get -y purge build-essential libpcap-dev libffi-dev libssl-dev python-dev && \
    apt-get -y autoremove --purge && \
    rm -rf /var/lib/apt/lists*

COPY conf/opencanary.conf /root/.opencanary.conf
COPY conf/supervise-opencanary.conf /etc/supervisor/conf.d/supervise-opencanary.conf
COPY scripts/startcanary.sh /opt/opencanary/scripts/startcanary.sh
COPY scripts/logger.py /opt/opencanary/virtualenv/lib/python2.7/site-packages/opencanary/logger.py
COPY scripts/tcpbanner.py /opt/opencanary/virtualenv/lib/python2.7/site-packages/opencanary/modules/tcpbanner.py
#COPY scripts/vnc.py /opt/opencanary/virtualenv/lib/python2.7/site-packages/opencanary/modules/vnc.py
RUN chmod +x /opt/opencanary/scripts/startcanary.sh && chmod 777 /data

#CMD ["/usr/bin/supervisord", "-n"]
CMD ["/opt/opencanary/scripts/startcanary.sh"]
