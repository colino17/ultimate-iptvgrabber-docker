#!/bin/sh

# DUMMY XMLTV
if [ $DUMMY=true ]; then
echo "Creating DUMMY XMLTV data..."
/bin/bash /dummyxmltv.sh
sleep 1
fi

# ZAP2XML - PRIMARY INSTANCE
if [ $Z1=true ]; then
echo "Retrieving XMLTV data for $ZUSER1..."
/zap2xml.pl -u $ZUSER1 -p $ZPASS1 -U -o /xmltv/$ZXML1 $ZARG1
sleep 1
fi

# ZAP2XML - SECONDARY INSTANCE
if [ $Z2=true ]; then
echo "Retrieving XMLTV data for $ZUSER2..."
/zap2xml.pl -u $ZUSER2 -p $ZPASS2 -U -o /xmltv/$ZXML2 $ZARG2
sleep 1
fi

# TOONAMI AFTERMATH
if [ $TOONAMI=true ]; then
echo "Retrieving M3U and XMLTV data from TOONAMI AFTERMATH..."
python3 /toonami/toonami.py
sleep 1
fi

# USTVGO
if [ $USTV=true ]; then
echo "Retrieving M3U and XMLTV data from USTVGO..."
python3 /ustv.py
sleep 1
fi

# UPDATE XTEVE VIA API
echo "Updating XTEVE playlists and XMLTV..."
curl -X POST -d '{"cmd":"update.m3u"}' http://$XIP:$XPORT/api/
sleep 5
curl -X POST -d '{"cmd":"update.xmltv"}' http://$XIP:$XPORT/api/
sleep 5
curl -X POST -d '{"cmd":"update.xepg"}' http://$XIP:$XPORT/api/
sleep 5

exit
