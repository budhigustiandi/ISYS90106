#!/bin/bash

echo '<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Thing Name</title>
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin=""/>
	<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
   <script src="https://cdn.plot.ly/plotly-1.17.3.min.js"></script>
   <script src="http://sdk.sensorup.com/sta-chart/sta-chart-0.0.5.min.js"></script>
	<style>
	h2 {
		color: blue;
	}
	.bold {
		font-weight: bold;
	}
	#mapid {
		height: 300px;
	}
	</style>
</head>
<body>' > index.htm

base_url=`cat ../configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat ../configuration.txt | grep thing_id | cut -d "=" -f 2`

echo '<p>Click <a href="'$base_url'/Things('$thing_id')?$expand=Locations,Datastreams" target="_blank">here</a> to show data in JSON format</p>' >> index.htm

thing_name=`cat ../configuration.txt | grep thing_name | cut -d "=" -f 2`
thing_description=`cat ../configuration.txt | grep thing_description | cut -d "=" -f 2`
	
echo '<h1>Thing</h1>
	<p><span class="bold">ID in the server: </span>'$thing_id'</p>
	<p><span class="bold">Name: </span>'$thing_name'</p>
	<p><span class="bold">Description: </span>'$thing_description'</p>
	<p><span class="bold">Properties: </span></p>
	<ul>' >> index.htm

number_of_property=`cat ../configuration.txt | grep ^property_name | wc -l`
for (( i=1; i<=$number_of_property; i++ )); do
	property_name=`cat ../configuration.txt | grep ^property_name | head -$i | tail -1 | cut -d "=" -f 2`
	property_description=`cat ../configuration.txt | grep ^property_description | head -$i | tail -1 | cut -d "=" -f 2`
	echo '<li><span class="bold">'$property_name': </span>'$property_description'</li>' >> index.htm
done

location_name=`cat ../configuration.txt | grep location_name | cut -d "=" -f 2`
location_description=`cat ../configuration.txt | grep location_description | cut -d "=" -f 2`
location_longitude=`cat ../configuration.txt | grep location_longitude | cut -d "=" -f 2`
location_latitude=`cat ../configuration.txt | grep location_latitude | cut -d "=" -f 2`

echo '</ul>
	<h1>Location</h1>
	<p><span class="bold">Name: </span>'$location_name'</p>
	<p><span class="bold">Description: </span>'$location_description'</p>
	<p><span class="bold">Encoding Type: </span>"application/vnd.geo+json"</p>
	<p><span class="bold">Location: </span></p>
	<ul>
		<li><span class="bold">Longitude: </span>'$location_longitude'</li>
		<li><span class="bold">Latitude: </span>'$location_latitude'</li>
	</ul>' >> index.htm
	
echo '<div id="mapid"></div>
	<script>
		var mymap = L.map('"'mapid'"').setView(['$location_latitude', '$location_longitude'], 17);
		L.tileLayer('"'"'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw'"'"', {
			attribution: '"'"'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'"'"',
			maxZoom: 18,
			id: '"'"'mapbox.streets'"'"'
		}).addTo(mymap);
		var marker = L.marker(['$location_latitude', '$location_longitude']).addTo(mymap);
		marker.bindPopup("Thing'"'"'s location.").openPopup();
	</script>
	<h1>Datastream</h1>' >> index.htm

datastream_query=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
number_of_datastream=`cat ../configuration.txt | grep datastream_name | wc -l`
for (( i=1; i<=$number_of_datastream; i++ )); do
		datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
		datastream_name=`cat ../configuration.txt | grep datastream_name | head -$i | tail -1 | cut -d "=" -f 2`
		datastream_description=`cat ../configuration.txt | grep datastream_description | head -$i | tail -1 | cut -d "=" -f 2`
		datastream_observation_type=`cat ../configuration.txt | grep datastream_observation_type | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_name=`cat ../configuration.txt | grep unit_of_measurement_name | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_symbol=`cat ../configuration.txt | grep unit_of_measurement_symbol | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_definition=`cat ../configuration.txt | grep unit_of_measurement_definition | head -$i | tail -1 | cut -d "=" -f 2`
		echo '<h2>'$datastream_name'</h2>
		
		<p><span class="bold">Description: </span>'$datastream_description'</p>
		<p><span class="bold">Observation Type: </span>'$datastream_observation_type'</p>
		<p><span class="bold">Unit of Measurement: </span>'$unit_of_measurement_name'</p>
		<p><span class="bold">Symbol: </span>'$unit_of_measurement_symbol'</p>
		<p><span class="bold">Definition: </span>'$unit_of_measurement_definition'</p>' >> index.htm
		
		observed_property_name=`cat ../configuration.txt | grep observed_property_name | head -$i | tail -1 | cut -d "=" -f 2`
		observed_property_description=`cat ../configuration.txt | grep observed_property_description | head -$i | tail -1 | cut -d "=" -f 2`
		observed_property_definition=`cat ../configuration.txt | grep observed_property_definition | head -$i | tail -1 | cut -d "=" -f 2`
		
		echo '<h3>Observed Property</h3>
			<ul>
				<li><span class="bold">Name: </span>'$observed_property_name'</li>
				<li><span class="bold">Description: </span>'$observed_property_description'</li>
				<li><span class="bold">Definition: </span>'$observed_property_definition'</li>
			</ul>' >> index.htm
			
		sensor_name=`cat ../configuration.txt | grep sensor_name | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_description=`cat ../configuration.txt | grep sensor_description | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_encoding_type=`cat ../configuration.txt | grep sensor_encoding_type | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_metadata=`cat ../configuration.txt | grep sensor_metadata | head -$i | tail -1 | cut -d "=" -f 2`
		
		echo '<h3>Sensor</h3>
			<ul>
				<li><span class="bold">Name: </span>'$sensor_name'</li>
				<li><span class="bold">Description: </span>'$sensor_description'</li>
				<li><span class="bold">Encoding Type: </span>'$sensor_encoding_type'</li>
				<li><span class="bold">Metadata: </span>'$sensor_metadata'</li>
			</ul>' >> index.htm
		
		echo '<div id="datastream_'$datastream_id'"></div>
		<script>
			stachart.generateChart({
				'"'"'targetId'"'"': '"'"'datastream_'$datastream_id''"'"',
			    '"'"'staBaseUrl'"'"': '"'"''$base_url''"'"',
			    '"'"'datastreamId'"'"': '"'"''$datastream_id''"'"'
			});
		 </script>' >> index.htm
		
		
		
done
echo '</body>
<html>' >> index.htm