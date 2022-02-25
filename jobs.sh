#!/bin/sh

# DUMMY XMLTV
if [ $DUMMY=true ]; then
echo "Creating DUMMY XMLTV data..."
/bin/bash /dummy/dummyxmltv.sh
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
python3 /ustv/ustv.py
sleep 1
fi

# UPDATE TVH VIA API
if [ $TVH=true ] && [ $USTV=true ]; then
echo "Scanning Channels..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/mpegts/network/scan?uuid=$USTV_UUID
sleep 5
fi

if [ $TVH=true ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
