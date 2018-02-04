#!/bin/bash

echo "Add a new location..."
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
content_placeholder="{$location}"
location_url=`cat configuration.txt | grep location_url | cut -d "=" -f 2`
curl -XPOST -H "Content-type: application/json" -d "$content_placeholder" "$location_url"
