#!/bin/bash

# Visualisation server parameters
username=`cat configuration.txt | grep username | cut -d "=" -f 2`
password=`cat configuration.txt | grep password | cut -d "=" -f 2`
site=`cat configuration.txt | grep site | cut -d "=" -f 2`

#########################
# Create index.htm file #
#########################

echo '<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Project RATIH Main Page</title>
	<link rel="stylesheet" href="main.css">
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin="">
	<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>' > visualisation/index.htm

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
observation_interval=`cat configuration.txt | grep observation_interval | cut -d "=" -f 2`
(( observation_interval*=1000 ))

echo '<p>Click <a href="'$base_url'/Things('$thing_id')?$expand=Locations,Datastreams" target="_blank"><button>here</button></a> to show data in JSON format</p>
	<h1>Thing</h1>
	<p><span class="bold">ID in the server: </span>'$thing_id'</p>
	<p><span class="bold">Name: </span><span id="thing_name"></span></p>
	<p><span class="bold">Description: </span><span id="thing_description"></span></p>
	<p><span class="bold">Properties: </span><span id="thing_property"></span></p>
	<a href="read_update_thing.htm"><button>Update Thing</button></a>
	<h1>Location</h1>
	<p><span class="bold">Name: </span><span id="location_name"></span></p>
	<p><span class="bold">Description: </span><span id="location_description"></span></p>
	<p><span class="bold">Encoding: </span><span id="location_encoding"></span></p>
	<p><span class="bold">Type: </span><span id="location_type"></span></p>
	<p><span class="bold">Location: </span></p>
	<ul>
		<li><span class="bold">Longitude: </span><span id="location_longitude"></span></li>
		<li><span class="bold">Latitude: </span><span id="location_latitude"></li>
	</ul>
	<div id="mapid"></div>
	<script>
		var thing = $.ajax({
			url: "'$base_url'/Things('$thing_id')?$expand=Locations,Datastreams",
			type: "GET",
			contentType: "application/json; charset=utf-8",
			success: function(data){
				console.log("Thing Name: " + thing.responseJSON.name);
				document.querySelector("#thing_name").textContent = thing.responseJSON.name;
				console.log("Thing Description: " + thing.responseJSON.description);
				document.querySelector("#thing_description").textContent = thing.responseJSON.description;
				console.log("Thing Properties: " + JSON.stringify(thing.responseJSON.properties));
				document.querySelector("#thing_property").textContent = JSON.stringify(thing.responseJSON.properties);
				var location = JSON.stringify(thing.responseJSON.Locations);
				location = location.slice(1,location.length-1);
				console.log("Location: " + location);
				location = JSON.parse(location);
				console.log("Location Name: " + location.name);
				document.querySelector("#location_name").textContent = location.name;
				console.log("Location Description: " + location.description);
				document.querySelector("#location_description").textContent = location.description;
				console.log("Location Encoding: " + location.encodingType);
				document.querySelector("#location_encoding").textContent = location.encodingType;
				console.log("Location Type: " + location.location.type);
				document.querySelector("#location_type").textContent = location.location.type;
				var location_longitude = location.location.coordinates[0];
				console.log("Location Longitude: " + location_longitude);
				document.querySelector("#location_longitude").textContent = location_longitude;
				var location_latitude = location.location.coordinates[1];
				console.log("Location Latitude: " + location_latitude);
				document.querySelector("#location_latitude").textContent = location_latitude;
				var mymap = L.map('"'"'mapid'"'"').setView([location_latitude, location_longitude], 17);
				L.tileLayer('"'"'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw'"'"', {
					attribution: '"'"'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'"'"',
					maxZoom: 18,
					id: '"'"'mapbox.streets'"'"'
				}).addTo(mymap);
				var marker = L.marker([location_latitude, location_longitude]).addTo(mymap);
				marker.bindPopup("Thing'"'"'s location.").openPopup();
			},
			error: function(response, status){
				console.log(response);
				console.log(status);
			}
		});
	</script>
	<h1>Datastream</h1>' >> visualisation/index.htm

#datastream_query=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
datastream_query='{"@iot.count":3,"value":[{"@iot.id":1684201,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)","description":"Datastream for recording light intensity","name":"Room Light Intensity","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"lx","name":"Lux","definition":"http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Lux"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Thing"},{"@iot.id":1684198,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)","description":"Datastream for recording humidity","name":"Room Humidity","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"%","name":"Percentage","definition":"1 part of 100"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Thing"},{"@iot.id":1684195,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)","description":"Datastream for recording temperature","name":"Room Temperature","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"degC","name":"Degree Celcius","definition":"http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelcius"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Thing"}]}'
number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
for (( i=1; i<=$number_of_datastream; i++ )); do
		datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
		datastream_name=`cat configuration.txt | grep datastream_name | head -$i | tail -1 | cut -d "=" -f 2`
		datastream_description=`cat configuration.txt | grep datastream_description | head -$i | tail -1 | cut -d "=" -f 2`
		datastream_observation_type=`cat configuration.txt | grep datastream_observation_type | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_name=`cat configuration.txt | grep unit_of_measurement_name | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_symbol=`cat configuration.txt | grep unit_of_measurement_symbol | head -$i | tail -1 | cut -d "=" -f 2`
		unit_of_measurement_definition=`cat configuration.txt | grep unit_of_measurement_definition | head -$i | tail -1 | cut -d "=" -f 2`
		echo '<h2>'$datastream_name' <span>show <a href="datastream_'$datastream_id'_chart.htm" target="_blank">chart</a> | <a href="datastream_'$datastream_id'_gauge.htm" target="_blank">gauge</a></span></h2>
		<p><span class="bold">ID: </span>'$datastream_id'</p>
		<p><span class="bold">Description: </span>'$datastream_description'</p>
		<p><span class="bold">Observation Type: </span>'$datastream_observation_type'</p>
		<p><span class="bold">Unit of Measurement: </span>'$unit_of_measurement_name'</p>
		<p><span class="bold">Symbol: </span>'$unit_of_measurement_symbol'</p>
		<p><span class="bold">Definition: </span>'$unit_of_measurement_definition'</p>' >> visualisation/index.htm

		observed_property_name=`cat configuration.txt | grep observed_property_name | head -$i | tail -1 | cut -d "=" -f 2`
		observed_property_description=`cat configuration.txt | grep observed_property_description | head -$i | tail -1 | cut -d "=" -f 2`
		observed_property_definition=`cat configuration.txt | grep observed_property_definition | head -$i | tail -1 | cut -d "=" -f 2`

		echo '<h3>Observed Property</h3>
			<ul>
				<li><span class="bold">Name: </span>'$observed_property_name'</li>
				<li><span class="bold">Description: </span>'$observed_property_description'</li>
				<li><span class="bold">Definition: </span>'$observed_property_definition'</li>
			</ul>' >> visualisation/index.htm

		sensor_name=`cat configuration.txt | grep sensor_name | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_description=`cat configuration.txt | grep sensor_description | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_encoding_type=`cat configuration.txt | grep sensor_encoding_type | head -$i | tail -1 | cut -d "=" -f 2`
		sensor_metadata=`cat configuration.txt | grep sensor_metadata | head -$i | tail -1 | cut -d "=" -f 2`

		echo '<h3>Sensor</h3>
			<ul>
				<li><span class="bold">Name: </span>'$sensor_name'</li>
				<li><span class="bold">Description: </span>'$sensor_description'</li>
				<li><span class="bold">Encoding Type: </span>'$sensor_encoding_type'</li>
				<li><span class="bold">Metadata: </span>'$sensor_metadata'</li>
			</ul>' >> visualisation/index.htm
done
echo '</body>
</html>' >> visualisation/index.htm

# Put index.htm file into the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/index.htm"

########################
# Create main.css file #
########################

echo 'h2 {
	color: blue;
}
.bold {
	font-weight: bold;
}
#mapid {
	height: 300px;
}
h2 span {
	color: black;
	font-weight: normal;
	font-size: 0.75em;
}' > visualisation/main.css

for (( i=1; i<=$number_of_datastream; i++ )); do
	datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	echo '	#datastream_'$datastream_id' {
		min-width: 300px;
		max-width: 555px;
		height: 250px;
		margin: 0 auto;
	}' >> visualisation/main.css
done

echo 'textarea {
	width: 100%;
}' >> visualisation/main.css

# Put main.css into the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/main.css"

####################################################
# Create individual chart page for each datastream #
####################################################

#########
# Chart #
#########

for (( i=1; i<=$number_of_datastream; i++ )); do
	datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_name=`cat configuration.txt | grep datastream_name | head -$i | tail -1 | cut -d "=" -f 2`
	echo '<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>'$datastream_name'</title>
		<link rel="stylesheet" href="main.css">
		<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
		<script src="https://code.highcharts.com/stock/highstock.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://sdk.sensorup.com/sensorthings-hcdt/v0.1/sensorthings-hcdt.js"></script>
	</head>
	<body>' > visualisation/datastream_${datastream_id}_chart.htm
	echo '<div id="datastream_'$datastream_id'_chart"></div>
	<script>
		$(function() {
			var sensorthingsHCDT_'$i' = new SensorthingsHCDT('"'"$base_url"'"', {
				'"'"dataStreamId"'"': ['$datastream_id']
			});
			var request_'$i' = sensorthingsHCDT_'$i'.request();
			if (request_'$i'.status == '"'"success"'"') {
				sensorthingsHCDT_'$i'.chart('"'"datastream_${datastream_id}_chart"'"', request_'$i', false, '$observation_interval');
			}
		});
	</script>' >> visualisation/datastream_${datastream_id}_chart.htm
	echo '</body>
	</html>' >> visualisation/datastream_${datastream_id}_chart.htm

	# Put each datastream_chart.htm to the visualisation server

	lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/datastream_${datastream_id}_chart.htm"
done

#########
# Table #
#########

#########
# Gauge #
#########

for (( i=1; i<=$number_of_datastream; i++ )); do
	datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	datastream_name=`cat configuration.txt | grep datastream_name | head -$i | tail -1 | cut -d "=" -f 2`
	echo '<!doctype html>
	<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>'$datastream_name'</title>
		<link rel="stylesheet" href="main.css">
		<script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script src="https://code.highcharts.com/highcharts-more.js"></script>
		<script src="https://code.highcharts.com/modules/exporting.js"></script>
		<script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
		<script src="https://sdk.sensorup.com/sensorthings-hcdt/v0.1/sensorthings-hcdt.js"></script>
	</head>
	<body>' > visualisation/datastream_${datastream_id}_gauge.htm
	echo '<p>Choose gauge type: <button id="speedometer" onclick="speedometer();">Speedometer</button> | <button id="solid" onclick="solid();">Solid</button></p>
	<div id="datastream_'$datastream_id'_gauge"></div>
	<script>
		$(function() {
			var sensorthingsHCDT_'$i' = new SensorthingsHCDT('"'"$base_url"'"', {
				'"'"dataStreamId"'"': ['$datastream_id']
			});
			var request_'$i' = sensorthingsHCDT_'$i'.request();
			if (request_'$i'.status == '"'"success"'"') {
				sensorthingsHCDT_'$i'.gauge('"'"datastream_${datastream_id}_gauge"'"', request_'$i', '"'"speedometer"'"', 0, 100, '$observation_interval');
			}
		});
	</script>
	<script>
		const SPEEDOMETER = document.querySelector("#speedometer");
		const SOLID = document.querySelector("#solid");
		function speedometer() {
			document.querySelector("body script").innerHTML=$(function() {
				var sensorthingsHCDT_'$i' = new SensorthingsHCDT('"'"$base_url"'"', {
					'"'"dataStreamId"'"': ['$datastream_id']
				});
				var request_'$i' = sensorthingsHCDT_'$i'.request();
				if (request_'$i'.status == '"'"success"'"') {
					sensorthingsHCDT_'$i'.gauge('"'"datastream_${datastream_id}_gauge"'"', request_'$i', '"'"speedometer"'"', 0, 100, '$observation_interval');
				}
			});
		}
		function solid() {
			document.querySelector("body script").innerHTML=$(function() {
				var sensorthingsHCDT_'$i' = new SensorthingsHCDT('"'"$base_url"'"', {
					'"'"dataStreamId"'"': ['$datastream_id']
				});
				var request_'$i' = sensorthingsHCDT_'$i'.request();
				if (request_'$i'.status == '"'"success"'"') {
					sensorthingsHCDT_'$i'.gauge('"'"datastream_${datastream_id}_gauge"'"', request_'$i', '"'"solid"'"', 0, 100, '$observation_interval');
				}
			});
		}
	</script>' >> visualisation/datastream_${datastream_id}_gauge.htm
	echo '</body>
	</html>' >> visualisation/datastream_${datastream_id}_gauge.htm

	# Put each datastream gauge file to the visualisation server

	lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/datastream_${datastream_id}_gauge.htm"
done

#####################################
# Create read_update_thing.htm page #
#####################################

echo '<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Project RATIH - Update Thing</title>
	<link rel="stylesheet" href="main.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>
	<h1>Update Thing</h1>
	<p><span class="bold">ID in the server: </span>'$thing_id'</p>
	<p class="bold">name</p>
	<textarea id="thing_name" rows="1" placeholder="String"></textarea>
	<p class="bold">description</p>
	<textarea id="thing_description" rows="1" placeholder="String"></textarea>
	<p class="bold">properties</p>
	<textarea id="thing_property" rows="3" placeholder="JSON"></textarea>
	<button id="update_thing" onclick="updateThing();">Update Thing</button>
	<a href="index.htm"><button>Back to main page</button></a>
	<script>
		// Read the data in JSON format from the SensorUp server then update the page based on the data
		var thing_id = '$thing_id';
		console.log("Thing ID: " + thing_id);
		var thing = $.ajax({
			url: "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(" + thing_id + ")",
			type: "GET",
			contentType: "application/json; charset=utf-8",
			success: function(data){
				var thing_name = thing.responseJSON.name;
				console.log("Thing Name: " + thing_name);
				document.querySelector("#thing_name").textContent = thing_name;
				var thing_description = thing.responseJSON.description;
				console.log("Thing Description: " + thing_description);
				document.querySelector("#thing_description").textContent = thing_description;
				var thing_property = JSON.stringify(thing.responseJSON.properties);
				console.log("Thing Properties: " + thing_property);
				document.querySelector("#thing_property").textContent = thing_property;
			},
			error: function(response, status){
				console.log(response);
				console.log(status);
			}
		});
		function updateThing(){
			var thing_name = document.querySelector("#thing_name").value;
			console.log("Thing Name: " + thing_name);
			var thing_description = document.querySelector("#thing_description").value;
			console.log("Thing Description: " + thing_description);
			var thing_property = document.querySelector("#thing_property").value;
			console.log("Thing Property: " + thing_property);
			var thing = '"'"'{ '"'"';
			if (thing_name !== "") {
				thing = thing + '"'"'"name": "'"'"' + thing_name + '"'"'"'"'"';
			}
			if (thing_description !== "") {
				if (thing_name !== "") {
					thing = thing + '"'"', '"'"';
				}
				thing = thing + '"'"'"description": "'"'"' + thing_description + '"'"'"'"'"';
			}
			if (thing_property !== "") {
				if ((thing_name !== "") || (thing_description !== "")) {
					thing = thing + '"'"', '"'"';
				}
				thing = thing + '"'"'"properties": '"'"' + thing_property;
			}
			thing = thing + '"'"' }'"'"';
			console.log("Thing: " + thing);
			$.ajax({
				url: "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(" + thing_id + ")",
				type: "PATCH",
				data: thing,
				contentType: "application/json; charset=utf-8",
				success: function(data){
					console.log(data);
					var user_info_node = document.createElement("p");
					var user_info_text = document.createTextNode("Thing has been updated!");
					user_info_node.appendChild(user_info_text);
					document.querySelector("body").appendChild(user_info_node);
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		}
	</script>
</body>
</html>' > visualisation/read_update_thing.htm

# Put read_update_thing.htm file to the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/read_update_thing.htm"
