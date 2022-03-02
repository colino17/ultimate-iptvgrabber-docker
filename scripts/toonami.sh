#!/bin/sh

# TOONAMI AFTERMATH
if [ $TOONAMI=true ]; then
echo "Retrieving M3U and XMLTV data from TOONAMI AFTERMATH..."
python3 /toonami/toonami.py
sleep 5
fi

# DUMMY XMLTV
if [ $DUMMY=true ]; then
echo "Creating DUMMY XMLTV data..."
/bin/bash /dummy/dummyxmltv.sh
sleep 1
fi

# MERGE DUMMY AND TOONAMI
if [ $DUMMY=true ] && [ $TOONAMI=true ]; then
echo "Merging XMLTV data..."
tv_merge -i /tmp/dummy.xml -m toonami.xml -o /tmp/tmp.xml
TMP=true
sleep 1
elif [ $DUMMY=true ] && [ $TOONAMI=false ]; then
echo "Moving XMLTV data..."
cp /tmp/dummy.xml  /tmp/tmp.xml
TMP=true
sleep 1
elif [ $DUMMY=false ] && [ $TOONAMI=true ]; then
echo "Moving XMLTV data..."
cp /tmp/toonami.xml  /tmp/tmp.xml
TMP=true
sleep 1
fi

# MERGE TMP AND NHL
if [ $NHL=true ] && [ $TMP=true ]; then
echo "Merging XMLTV data..."
tv_merge -i /tmp/nhl.xml -m /tmp/tmp.xml -o /xmltv/xmltv.xml
sleep 1
elif [ $NHL=true ] && [ $TMP=false ]; then
echo "Moving XMLTV data..."
cp /tmp/nhl.xml  /xmltv/nhl.xml
sleep 1
fi

# UPDATE TVH VIA API
if [ $TVH=true ]; then
echo "Updating EPG..."
curl http://$TVH_USER:$TVH_PASS@$TVH_IP:9981/api/epggrab/internal/rerun?rerun=1
sleep 5
fi

exit
