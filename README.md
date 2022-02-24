# WHAT IS IT?

A docker container running various IPTV Grabber services designed to be used either standalone or in conjunction with a TVHeadEnd instance.

The chosen services (ZAP2XML, USTVGO, etc) are run every three hours as part of a cronjob. Once they are completed XTEVE's playlists and XMLTV will be updated via an API call (API must be enabled in XTEVE's settings).



# COMPOSE

```
version: '2'
services:
  iptvgrabber:
    container_name: iptvgrabber
    image: ghcr.io/colino17/ultimate-iptvgrabber-docker:latest
    volumes:
      - /path/to/playlists:/playlists
      - /path/to/xmltv:/xmltv
      - /path/to/extras:/extras
    environment:
      ### USTVGO instance
      - USTV=true
      - USTV_UUID=tvheadendnetworkuuid
      ### TOONAMI AFTERMATH instance
      - TOONAMI=true
      ### DUMMY XMLTV instance
      - DUMMY=true
      ### TVHeadEnd integration
      - TVH=true
      - TVH_USER=username
      - TVH_PASS=password
      - TVH_IP=ipaddress
```

# TO DO

- Clean Up Cron Function
- Add lazystream options

# CREDITS AND SOURCES

- https://github.com/benmoose39/ustvgo_to_m3u
- https://github.com/yurividal/dummyepgxml
- https://github.com/chris102994/docker-toonamiaftermath
