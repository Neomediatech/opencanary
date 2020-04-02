FROM neomediatech/ubuntu-base:latest

ENV VERSION=0.5.2 \
    DEBIAN_FRONTEND=noninteractive \
    SERVICE=opencanary

LABEL maintainer="docker-dario@neomediatech.it" \ 
      org.label-schema.version=$VERSION \
      org.label-schema.vcs-type=Git \
      org.label-schema.vcs-url=https://github.com/Neomediatech/${SERVICE} \
      org.label-schema.maintainer=Neomediatech

RUN rm /bin/sh && ln -s /bin/bash /bin/sh 
RUN apt update && apt -y dist-upgrade && \
    apt install -y --no-install-recommends sudo build-essential tcpdump libpcap-dev libffi-dev \
    libssl-dev python-dev python-setuptools python-pip python-virtualenv virtualenv && \
    mkdir -p /opt/opencanary && \
    virtualenv -p python /opt/opencanary/virtualenv && \
    source /opt/opencanary/virtualenv/bin/activate && \
    pip install pip --upgrade && \
    pip install opencanary && \
    pip install scapy pcapy && \
    pip install rdpy && \
    mkdir -p /opt/opencanary/scripts /data && touch /data/opencanary.log && chmod 666 /data/opencanary.log && \
    apt -y purge build-essential libpcap-dev libffi-dev libssl-dev python-dev && \
    apt -y autoremove --purge && \
    rm -rf /var/lib/apt/lists*

COPY conf/opencanary.conf /root/.opencanary.conf
COPY scripts/startcanary.sh /opt/opencanary/scripts/startcanary.sh
COPY scripts/logger.py /opt/opencanary/virtualenv/lib/python2.7/site-packages/opencanary/logger.py
COPY scripts/tcpbanner.py /opt/opencanary/virtualenv/lib/python2.7/site-packages/opencanary/modules/tcpbanner.py
RUN chmod +x /opt/opencanary/scripts/startcanary.sh && chmod 777 /data

CMD ["/tini","--","/opt/opencanary/scripts/startcanary.sh"]
