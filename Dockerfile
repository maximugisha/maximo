# Use the latest Ubuntu image as a parent
FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive TZ=Africa/Kampala

# Initial updates and install core utilities
# net-tools = ifconfig, ip
RUN apt-get update -qq -y && \
    apt-get upgrade -y && \
    apt-get install -y \
       wget \
       curl \
       apt-transport-https \
       lsb-release \ 
       ca-certificates \
       gnupg2 \
       software-properties-common \
       locales \
       cron    \
       net-tools \
       vim \
       docker \ 
       docker-compose
RUN dpkg-reconfigure locales

# Install Webmin
RUN apt-get update -qq -y && \ 
    echo root:password | chpasswd && \
    echo "Acquire::GzipIndexes \"false\"; Acquire::CompressionTypes::Order:: \"gz\";" >/etc/apt/apt.conf.d/docker-gzip-indexes && \
    update-locale LANG=C.UTF-8 && \
    echo deb https://download.webmin.com/download/repository sarge contrib >> /etc/apt/sources.list && \
    wget http://www.webmin.com/jcameron-key.asc && \
    apt-key add jcameron-key.asc && \
    apt-get update && \
    apt-get install -y webmin && \
    apt-get clean && \
    echo "$(cat /etc/webmin/webmin.acl) docker" > /etc/webmin/webmin.acl \
    echo "referers=max-cbf9425e-ea49-42b4-af53.renu-01.cranecloud.io" > /etc/webmin/config

EXPOSE 10000
ENV LC_ALL C.UTF-8

WORKDIR /home
RUN echo "#! /bin/bash" > entrypoint.sh && \
    echo "sed -i 's;ssl=1;ssl=0;' /etc/webmin/miniserv.conf && systemctl enable cron && service webmin start && tail -f /dev/null" >> entrypoint.sh && \
    chmod 755 entrypoint.sh

CMD /home/entrypoint.sh