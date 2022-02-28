#!/bin/sh

# TOONAMI AFTERMATH
if [ $TOONAMI=true ]; then
echo "Retrieving M3U and XMLTV data from TOONAMI AFTERMATH..."
python3 /toonami/toonami.py
sleep 5
fi

# UPDATE TVH VIA API
if [ $TVH=true ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
