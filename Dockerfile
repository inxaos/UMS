
FROM ubuntu:16.04

MAINTAINER Damon Prater <damon@inxaos.com>

# Update and install transmission packages
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y openjdk-8-jre mediainfo dcraw vlc lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386 zlib.i686 ncurses-libs.i686 bzip2-libs.i686 libstdc++.i686 && \
    apt-get clean

VOLUME ["/audio", "/video"]

ENV UMS_Version=6.5.1

RUN wget https://sourceforge.net/projects/unimediaserver/files/Offical%20Releases/Linux/UMS-$UMS_Version.Java8.tgz/download && \
    mv download UMS-$UMS_Version.Java8.tgz && \
    tar xvf UMS-$UMS_Version-Java8.tgz -C /opt && \
    ln -s ums ums-$UMS_Version/ && \
    chmod +x /opt/ums-$UMS_Version/UMS.sh

ADD UMS.service /etc/systemd/system/UMS.service
ADD UMS.conf /etc/ums/UMS.conf

RUN systemctl enable UMS
#RUN systemctl start UMS

CMD bash -c 'systemctl restart UMS' && tail -f /var/log/dmesg

