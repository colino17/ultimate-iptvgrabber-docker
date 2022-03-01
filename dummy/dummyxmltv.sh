#!/bin/bash

# CHANNELS ARE DEFINED IN THE "channels" FILE
if [ -f "/extras/channels" ]; then
    source /extras/channels
else
    source /dummy/channels
fi

starttimes=("000000" "010000" "020000" "030000" "040000" "050000" "060000" "070000" "080000" "090000" "100000" "110000" "120000" "130000" "140000" "150000" "160000" "170000" "180000" "190000" "200000" "210000" "220000" "230000")
endtimes=("010000" "020000" "030000" "040000" "050000" "060000" "070000" "080000" "090000" "100000" "110000" "120000" "130000" "140000" "150000" "160000" "170000" "180000" "190000" "200000" "210000" "220000" "230000" "235900")
BASEPATH="/xmltv"
DUMMYFILENAME=dummy.xml

		today=$(date +%Y%m%d)
		tomorrow=$(date --date="+1 day" +%Y%m%d)
		# tomorrow=$(date -v+1d +%Y%m%d)  ## if running on MAC or BSD
		echo '<?xml version="1.0" encoding="UTF-8"?>' > $BASEPATH/$DUMMYFILENAME
		echo '<tv generator-info-name="mydummy" generator-info-url="https://null.null/">' >> $BASEPATH/$DUMMYFILENAME
        numberofiterations=$(($numberofchannels - 1))
        echo "Creating Dummy Epg ..."


		for i in $(seq 0 $numberofiterations); do # Number of Dummys -1 
			tvgid=a$i[0]
			name=a$i[1]
			echo '    <channel id="'${!tvgid}'">' >> $BASEPATH/$DUMMYFILENAME
			echo '        <display-name lang="en">'${!name}'</display-name>' >> $BASEPATH/$DUMMYFILENAME
			echo '    </channel>' >> $BASEPATH/$DUMMYFILENAME
		done

		for i in $(seq 0 $numberofiterations) ;do
			tvgid=a$i[0]
			title=a$i[2]
			desc=a$i[3]
			for j in {0..23}; do
					echo '    <programme start="'$today${starttimes[$j]}' +0000" stop="'$today${endtimes[$j]}' +0000" channel="'${!tvgid}'">' >> $BASEPATH/$DUMMYFILENAME
					echo '        <title lang="en">'${!title}'</title>' >> $BASEPATH/$DUMMYFILENAME
					echo '        <desc lang="en">'${!desc}'</desc>' >> $BASEPATH/$DUMMYFILENAME
					echo '    </programme>' >> $BASEPATH/$DUMMYFILENAME
			done
			for j in {0..23}; do
					echo '    <programme start="'$tomorrow${starttimes[$j]}' +0000" stop="'$tomorrow${endtimes[$j]}' +0000" channel="'${!tvgid}'">' >> $BASEPATH/$DUMMYFILENAME
					echo '        <title lang="en">'${!title}'</title>' >> $BASEPATH/$DUMMYFILENAME
					echo '        <desc lang="en">'${!desc}'</desc>' >> $BASEPATH/$DUMMYFILENAME
					echo '    </programme>' >> $BASEPATH/$DUMMYFILENAME
			done
		done

		echo '</tv>' >> $BASEPATH/$DUMMYFILENAME

echo "Done!"
sleep 2
