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
ENV NHL=true
ENV NHL_UUID=

# BASICS
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates coreutils shadow gnutls-utils curl bash busybox-suid su-exec tzdata xmltv
RUN apk add --no-cache perl-compress-raw-zlib perl-date-manip perl-file-slurp perl-io-gzip perl-libwww perl-lingua-en-numbers-ordinate perl-lingua-preferred perl-term-progressbar perl-term-readkey perl-timedate perl-unicode-string perl-xml-libxml perl-xml-parser perl-xml-treepp perl-xml-twig perl-xml-writer

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
ADD scripts scripts/
ADD crontab /
RUN crontab crontab

# PERMISSIONS
RUN chmod +x /scripts/dummy.sh
RUN chmod +x /scripts/toonami.sh
RUN chmod +x /scripts/ustv.sh
RUN chmod +x /scripts/nhl.sh
RUN chmod +x /dummy/dummyxmltv.sh

# ENTRYPOINT
#ENTRYPOINT ["./startup.sh"]
CMD ["crond", "-f"]
