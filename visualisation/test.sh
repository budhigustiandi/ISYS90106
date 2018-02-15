#!/bin/bash

location_name="Location Name"
location_description="Location Description"
location_longitude="Location Longitude"
location_latitude="Location Latitude"
function location {
	location='{"name": "'$location_name'",
			  "description": "'$location_description'",
			  "encodingType": "application/vnd.geo+json",
			  "location": {
				"type": "Point",
					"coordinates": ['$location_longitude', '$location_latitude']
			  }}'
	location_name=Berubah1
	location_description=Berubah2
}
location
echo $location_name
echo $location_description
echo ''$location''