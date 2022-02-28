#!/bin/sh

# DUMMY XMLTV
if [ $DUMMY=true ]; then
echo "Creating DUMMY XMLTV data..."
/bin/bash /dummy/dummyxmltv.sh
sleep 1
fi

# UPDATE TVH VIA API
if [ $TVH=true ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
