#!/bin/bash

# RUN LAZYSTREAM
if [ $NHL = "true" ]; then
echo "Retrieving M3U and XMLTV data from LAZYSTREAM..."
lazystream generate xmltv /tmp/nhl.xml --sport nhl --exclude-feeds "COMPOSITE" --channel-prefix "NHL" --start-channel "1001"
sleep 5
# CREATE INDIVIDUAL M3U8 FOR EACH CHANNEL WITH FAILOVER PATH FOR EMPTY STREAMS
echo "Creating static individual M3U8 for each channel..."
for i in {2..200..2}
do
  B=$((i+1))
  lineA=$(sed -n "${i}p" "/tmp/nhl.m3u")
  lineB=$(sed -n "${B}p" "/tmp/nhl.m3u")
  name=$(cut -d "," -f2- <<< "$lineA")
# FAILOVER INSTANCE
  if [ $lineB = "." ]; then
  echo "#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=3500000
$FAILOVER_PATH" > "/playlists/$name.m3u8"
# SUCCESSFUL INSTANCE
  else
  echo "#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=3500000
$lineB" > "/playlists/$name.m3u8"
  fi
done
sleep 5
cp /tmp/nhl.m3u /playlists/nhl.m3u
fi

# UPDATE EPG VIA TVH API CALL
if [ $TVH = "true" ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
