#!/bin/bash

# USTVGO
if [ $USTV = "true" ]; then
echo "Retrieving M3U from USTVGO..."
python3 /ustv/ustv.py
sleep 1
echo "Creating individual channels M3Us..."
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
fi

# UPDATE TVH VIA API
#if [ $TVH = "true" ] && [ $USTV=true ]; then
#echo "Scanning Channels..."
#curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/mpegts/network/scan?uuid=$USTV_UUID
#sleep 5
#fi

if [ $TVH = "true" ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
