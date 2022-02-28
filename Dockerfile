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
RUN apk add --no-cache ca-certificates coreutils shadow gnutls-utils curl bash busybox-suid su-exec tzdata

# LAZYSTREAM
RUN wget https://github.com/tarkah/lazystream/releases/download/v1.12.0/lazystream-v1.12.0-x86_64-unknown-linux-musl.tar.gz -O lazystream.tar.gz; \
    tar xzf lazystream.tar.gz; \
    mv ././lazystream /usr/bin/lazystream; \
    rm lazystream.tar.gz; \
    rm -rf lazystream/
    
# USTVGO
RUN apk add --no-cache python3 py3-pip
ADD requirements.txt /
RUN pip install -r requirements.txt
ADD ustv /ustv
ADD logos /logos
RUN mkdir /playlists

# TOONAMI
ADD toonami toonami/
RUN mkdir /toonami/config

# DUMMY XMLTV
ADD dummy /dummy
ADD extras /

# TIMEZONE
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

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
RUN chmod +x /dummy/dummyxmltv.sh

# ENTRYPOINT
ENTRYPOINT ["./startup.sh"]
#CMD ["crond", "-f"]
