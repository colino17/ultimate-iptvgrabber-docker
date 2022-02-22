# WHAT IS IT?

A docker container running XTEVE which also allows for two separate instances of ZAP2XML and the retrieval of playlists from USTVGO using environment variables.

The chosen services (ZAP2XML, USTVGO, etc) are run every three hours as part of a cronjob. Once they are completed XTEVE's playlists and XMLTV will be updated via an API call (API must be enabled in XTEVE's settings).

The XTEVE webui can be accessed via http://XIP:34400/web.

# COMPOSE

```
version: '2'
services:
  xteve:
    container_name: xteve
    image: ghcr.io/colino17/ultra-xteve-docker:latest
    ports:
      - 34400:34400
    volumes:
      - /path/to/config:/config
      - /path/to/tmp:/tmp/xteve
      - /path/to/extras:/extras
    environment:
      ### Primary ZAP2XML instance
      - Z1=true
      - ZUSER1=username
      - ZPASS1=password
      - ZXML1=zap1.xml
      - ZARG1=
      ### Secondary ZAP2XML instance
      - Z2=true
      - ZUSER2=username
      - ZPASS2=password
      - ZXML2=zap2.xml
      - ZARG2=
      ### XTEVE API information
      - XIP=local ip address
      - XPORT=34400
      ### USTVGO instance
      - USTV=true
      ### TOONAMI AFTERMATH instance
      - TOONAMI=true
      ### DUMMY XMLTV instance
      - DUMMY=true
```

# TO DO

- Clean Up Cron Function
- Add default XTEVE settings
- Determine best zap2xml defaults
- Add lazystream options

# CREDITS AND SOURCES

- https://github.com/xteve-project/xTeVe
- https://github.com/alturismo/xteve
- https://github.com/shuaiscott/zap2xml
- https://github.com/benmoose39/ustvgo_to_m3u
- https://github.com/yurividal/dummyepgxml
- https://github.com/chris102994/docker-toonamiaftermath
