#!/bin/bash

echo "Update location..."
location_name=`cat configuration.txt | grep location_name | cut -d "=" -f 2`
echo "Location name is $location_name"
location_description=`cat configuration.txt | grep location_description | cut -d "=" -f 2`
echo "Location description is $location_description"
location_longitude=`cat configuration.txt | grep location_longitude | cut -d "=" -f 2`
echo "Location longitude is $location_longitude"
location_latitude=`cat configuration.txt | grep location_latitude | cut -d "=" -f 2`
echo "Location latitude is $location_latitude"
location="\"name\": \"$location_name\",
          \"description\": \"$location_description\",
          \"encodingType\": \"application/vnd.geo+json\",
          \"location\": {
                \"type\": \"Point\",
                \"coordinates\": [$location_longitude, $location_latitude]
          }"
content="{$location}"
base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
location_url="$base_url/Things($thing_id)/Locations"
location_id=`curl -X GET -H "Content-Type: application/json" "$location_url" | cut -d ":" -f 4 | cut -d "," -f 1`
url="$base_url/Locations($location_id)"
curl -X PATCH -H "Content-Type: application/json" -d "$content" "$url"
