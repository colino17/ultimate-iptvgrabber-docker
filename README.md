# WHAT IS IT?

A docker container running various IPTV Grabber services designed to be used either standalone or in conjunction with a TVHeadEnd instance using API calls.

# COMPOSE

```yaml
version: '2'
services:
  iptvgrabber:
    container_name: iptvgrabber
    image: ghcr.io/colino17/ultimate-iptvgrabber-docker:latest
    network_mode: host
    restart: always
    volumes:
      - /path/to/playlists:/playlists
      - /path/to/xmltv:/xmltv
      - /path/to/extras:/extras
    environment:
      ### USTVGO ###
      - USTV=true
      - USTV_UUID=tvheadendnetworkuuid
      ### TOONAMI ###
      - TOONAMI=true
      ### DUMMY XMLTV instance
      - DUMMY=true
      ### TVHEADEND ###
      - TVH=true
      - TVH_USER=username
      - TVH_PASS=password
      - TVH_IP=ipaddress
      ### LAZYSTREAM ###
      - NHL=true
      - NHL_UUID=tvheadendnetworkuuid
```

# TO DO

- Add explanatory notes to readme for each function
- Explore youtube to m3u integration
- Explore pluto tv integration

# CREDITS AND SOURCES

- https://github.com/benmoose39/ustvgo_to_m3u
- https://github.com/yurividal/dummyepgxml
- https://github.com/chris102994/docker-toonamiaftermath
- https://github.com/tarkah/lazystream
