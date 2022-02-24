FROM alpine:latest

# ENVIRONMENT
ENV USTV=true
ENV DUMMY=true
ENV TOONAMI=true
ENV TVH=true
ENV TVH_USER=
ENV TVH_PASS=
ENV TVH_IP=
ENV USTV_UUID=
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

# DUMMY XMLTV
ADD dummyxmltv.sh /
ADD extras /

# TIMEZONE
RUN apk update && apk add --no-cache tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ASSORTED DEPENDENCIES
RUN apk add --no-cache curl bash busybox-suid su-exec

# VOLUMES
VOLUME /extras
VOLUME /playlists
VOLUME /xmltv

# CRON
ADD jobs.sh /
ADD startup.sh /
ADD crontab /
RUN crontab crontab

# PERMISSIONS
RUN chmod +x /startup.sh
RUN chmod +x /jobs.sh
RUN chmod +x /dummyxmltv.sh

# ENTRYPOINT
ENTRYPOINT ["./startup.sh"]
