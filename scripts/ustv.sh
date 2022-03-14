#!/bin/bash

# USTVGO
if [ $USTV = "true" ]; then
echo "Retrieving M3U from USTVGO..."
python3 /ustv/ustv.py
sleep 1
echo "Creating static individual M3U8 for each channel..."
  for i in {2..120..2}
  do
     B=$((i+1))
     lineA=$(sed -n "${i}p" "/playlists/ustvgo.m3u")
     lineB=$(sed -n "${B}p" "/playlists/ustvgo.m3u")
     name=$(cut -d "," -f2- <<< "$lineA")
     echo "#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=1383144,RESOLUTION=640x360
$lineB" > "/playlists/$name.m3u8"
  done
sleep 5
fi

# UPDATE EPG VIA TVH API CALLS
if [ $TVH = "true" ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
