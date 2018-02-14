#!/bin/bash

while read -r  line < /dev/serial0; do
	echo $line | grep GPGGA
	if [[ $? -eq 0 ]]; then
		longitude_raw=`echo $line | cut -d "," -f 5`
		longitude_degree=${longitude_raw:0:3}
		longitude_minute=`echo ${longitude_raw:3:8}/60 | bc -l`
		longitude=$longitude_degree$longitude_minute
		longitude=${longitude:0:9}
		longitude_position=`echo $line | cut -d "," -f 6`
		if [[ "$longitude_position" == "W" ]]; then
			longitude=-$longitude
		fi
		latitude_raw=`echo $line | cut -d "," -f 3`
		latitude_degree=${latitude_raw:0:2}
		latitude_minute=`echo ${latitude_raw:3:8}/60 | bc -l`
		latitude=$latitude_degree$latitude_minute
		latitude=${latitude:0:8}
		latitude_position=`echo $line | cut -d "," -f 4`
		if [[ "$latitude_position" == "S" ]]; then
                        latitude=-$latitude
                fi
		break
	fi
done
echo "Longitude: $longitude"
echo "Latitude: $latitude"
