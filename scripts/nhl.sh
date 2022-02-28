#!/bin/sh

# LAZYSTREAM
if [ $NHL=true ]; then
echo "Retrieving M3U and XMLTV data from LAZYSTREAM..."
lazystream generate xmltv /tmp/nhl.xml --sport nhl --exclude-feeds "COMPOSITE" --channel-prefix "NHL LIVE" --start-channel "1000"
sleep 5
cp /tmp/nhl.xml /xmltv/nhl.xml
cp /tmp/nhl.m3u /playlists/nhl.m3u
fi

# UPDATE TVH VIA API
if [ $TVH=true ] && [ $USTV=true ]; then
echo "Scanning Channels..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/mpegts/network/scan?uuid=$NHL_UUID
sleep 5
fi

if [ $TVH=true ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
