# WHAT IS IT?

A docker container running various IPTV Grabber services designed to be used either standalone or in conjunction with a TVHeadEnd instance using API calls.

# USAGE OPTIONS

There are several grabbers and functions included. Most of them can be toggled using environment variables.

### USTVGO
The USTVGO grabber will pull a master M3U from the USTVGO service every 3 hours. It will also parse the master M3U and create individual static M3U8 files for each channel in the /playlists directory. It is recommended that you serve these individual M3U8 files locally using https://github.com/colino17/file-server-docker so that you can provide TVHeadEnd (or any other service) with a static source.

### TOONAMI AFTERMATH
The Toonami Aftermath grabber will parse the Toonami Aftermath website and create an M3U and XMLTV of the main channels every 12 hours. The XMLTV file will be merged with the XMLTV files from the Dummy and Lazystream grabbers and be placed in the /xmltv directory. The M3U will be placed in the /playlists directory.

### DUMMY
The Dummy grabber will create an XMLTV file with Dummy data for your predefined channels. Custom channels can be defined by placing a "channels" file in the /extras directory. The format of this file can be seen in the sample provided in the repo. The XMLTV file will be merged with the XMLTV files from the Toonami and Lazystream grabbers and be placed in the /xmltv directory.

### LAZYSTREAM
The Lazystream grabber will pull a master M3U and XMLTV from the Lazystream service every hour. It will also parse the master M3U and create individual M3U files for each channel in the /playlists directory. It is recommended that you serve these individual M3U files locally using https://github.com/colino17/file-server-docker so that you can provide TVHeadEnd (or any other service) with a static source.

### TVHEADEND
This project is designed to work with TVHeadEnd. The details of your TVHeadEnd instance are provided using environment variables.


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
      - USTV=true
      - TOONAMI=true
      - NHL=true
      - DUMMY=true
      - TVH=true
      - TVH_USER=username
      - TVH_PASS=password
      - TVH_IP=ipaddress
```

# TO DO

- Explore youtube to m3u integration
- Explore pluto tv integration
- Reassess current use of API calls
- Remove UUID ENV variables

# CREDITS AND SOURCES

- https://github.com/benmoose39/ustvgo_to_m3u
- https://github.com/yurividal/dummyepgxml
- https://github.com/chris102994/docker-toonamiaftermath
- https://github.com/tarkah/lazystream
