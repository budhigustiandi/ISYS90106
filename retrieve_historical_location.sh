#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
historical_location_url="$base_url/Things($thing_id)/HistoricalLocations?\$expand=Locations"
query_result=`curl -X GET -H "Content-Type: application/json" "$historical_location_url"`
number_of_historical_location=`echo $query_result | cut -d "," -f 1 | cut -d ":" -f 2`
if [[ $number_of_historical_location -eq 0 ]]; then
	echo "There is historical location available."
elif [[ $number_of_historical_location -eq 1 ]]; then
	echo "There is one historical location."
else
	echo "There are $number_of_historical_location historical locations."
fi
for (( i=1; i<=$number_of_historical_location; i++ )); do
	time=`echo $query_result | sed 's/"time"/\n"time"/g' | grep time | head -$i | tail -1 | cut -d "\"" -f 4`
	longitude=`echo $query_result | sed 's/"coordinates"/\n"coordinates"/g' | grep coordinates | head -$i | tail -1 | cut -d "[" -f 2 | cut -d "," -f 1`
	latitude=`echo $query_result | sed 's/"coordinates"/\n"coordinates"/g' | grep coordinates | head -$i | tail -1 | cut -d "," -f 2 | cut -d "]" -f 1`
	if [[ $i -eq 1 ]]; then
		echo "Time,Longitude,Latitude" > historical_location.csv
	fi
	echo $time,$longitude,$latitude >> historical_location.csv
done
