#!/bin/bash

# Read location from GPS
bash observation/read_gps.sh

function get_location {
	location_longitude=`cat configuration.txt | grep location_longitude | cut -d "=" -f 2`
	echo "Location longitude is $location_longitude"
	location_latitude=`cat configuration.txt | grep location_latitude | cut -d "=" -f 2`
	echo "Location latitude is $location_latitude"
	location='{"name": "'$location_name'",
			  "description": "'$location_description'",
			  "encodingType": "application/vnd.geo+json",
			  "location": {
				"type": "Point",
					"coordinates": ['$location_longitude', '$location_latitude']
			  }}'
}

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
location_status=`cat configuration.txt | grep location_status | cut -d "=" -f 2`
if [[ "$location_status" == "static" ]]; then
	echo "Updating existing location..."
	location_name=`cat configuration.txt | grep location_name | cut -d "=" -f 2`
	echo "Location name is $location_name"
	location_description=`cat configuration.txt | grep location_description | cut -d "=" -f 2`
	echo "Location description is $location_description"
	get_location
	location_id=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Locations" | cut -d ":" -f 4 | cut -d "," -f 1`
	curl -X PATCH -H "Content-Type: application/json" -d "$content" "$base_url/Locations($location_id)"
elif [[ "$location_status" == "dynamic" ]]; then
	echo "Creating a new location..."
	location_name="Mobile"
	echo "Location name is $location_name"
	location_description="Location is based on the GPS measurement."
	echo $location_description
	get_location
	curl -XPOST -H "Content-type: application/json" -d ''$location'' "$base_url/Things($thing_id)/Locations"
else
	echo "Please choose a mode (static/dynamic) in the configuration.txt file."