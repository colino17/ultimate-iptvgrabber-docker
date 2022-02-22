FROM alpine:latest

# ENVIRONMENT
ENV Z1=true
ENV ZUSER1=none
ENV ZPASS1=none
ENV Z2=true
ENV ZUSER2=none
ENV ZPASS2=none
ENV ZXML1=zap1.xml
ENV ZXML2=zap2.xml
ENV ZARG1=
ENV ZARG2=
ENV XIP=
ENV XPORT=34400
ENV USTV=true
ENV DUMMY=true
ENV TOONAMI=true
ENV TZ=Canada/Atlantic

# BASICS
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

# USTVGO
RUN apk add --no-cache python3 py3-pip
ADD requirements.txt /
RUN pip install -r requirements.txt
ADD ustv.py /
ADD ustvchannels.txt /
ADD logos /logos
RUN mkdir /playlists

# TOONAMI
ADD toonami toonami/
RUN mkdir /toonami/config

# ZAP2XML
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "@edgetesting http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache perl@edge perl-html-parser@edge perl-http-cookies@edge perl-lwp-useragent-determined@edge perl-json@edge perl-json-xs@edge
RUN apk add --no-cache perl-lwp-protocol-https@edge perl-uri@edge ca-certificates@edge perl-net-libidn@edge perl-net-ssleay@edge perl-io-socket-ssl@edge perl-libwww@edge perl-mozilla-ca@edge perl-net-http@edge
ADD zap2xml.pl /
RUN mkdir /xmltv

# DUMMY XMLTV
ADD dummyxmltv.sh /
ADD extras /

# TIMEZONE
RUN apk update && apk add --no-cache tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ASSORTED DEPENDENCIES
RUN apk add --no-cache curl bash busybox-suid su-exec

# VOLUMES
VOLUME /config
VOLUME /root/.xteve
VOLUME /tmp/xteve
VOLUME /extras
VOLUME /playlists
VOLUME /xmltv

# FFMPEG AND VLC
RUN apk add ffmpeg
RUN apk add vlc
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

# XTEVE
RUN wget https://github.com/xteve-project/xTeVe-Downloads/raw/beta/xteve_linux_amd64.zip -O temp.zip; unzip temp.zip -d /usr/bin/; rm temp.zip

# CRON
ADD jobs.sh /
ADD startup.sh /
ADD crontab /
RUN crontab crontab

# PERMISSIONS
RUN chmod +x /startup.sh
RUN chmod +x /jobs.sh
RUN chmod +x /usr/bin/xteve
RUN chmod +x /zap2xml.pl
RUN chmod +x /dummyxmltv.sh

# PORTS
EXPOSE 34400

# ENTRYPOINT
ENTRYPOINT ["./startup.sh"]
