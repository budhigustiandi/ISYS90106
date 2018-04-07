#!/bin/bash

# Visualisation server parameters
username=`cat configuration.txt | grep username | cut -d "=" -f 2`
password=`cat configuration.txt | grep password | cut -d "=" -f 2`
site=`cat configuration.txt | grep site | cut -d "=" -f 2`

# Main variables
base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
observation_interval=`cat configuration.txt | grep observation_interval | cut -d "=" -f 2`
(( observation_interval*=1000 ))
datastream_query=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`
#datastream_query={"@iot.count":3,"value":[{"@iot.id":1684201,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)","description":"Datastream for recording light intensity","name":"Room Light Intensity","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"lx","name":"Lux","definition":"http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Lux"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684201)/Thing"},{"@iot.id":1684198,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)","description":"Datastream for recording humidity","name":"Room Humidity","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"%","name":"Percentage","definition":"1 part of 100"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684198)/Thing"},{"@iot.id":1684195,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)","description":"Datastream for recording temperature","name":"Room Temperature","observationType":"http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement","unitOfMeasurement":{"symbol":"degC","name":"Degree Celcius","definition":"http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelcius"},"Observations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Observations","ObservedProperty@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/ObservedProperty","Sensor@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Sensor","Thing@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Datastreams(1684195)/Thing"}]}

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
<body>
<p>Click <a href="https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)?$expand=Locations,Datastreams" target="_blank"><button>here</button></a> to show data in JSON format</p>
<h1>Thing</h1>
	<p><span class="bold">ID in the server: </span>1684190</p>
	<p><span class="bold">Name: </span><span id="thing_name"></span></p>
	<p><span class="bold">Description: </span><span id="thing_description"></span></p>
	<p><span class="bold">Properties: </span><span id="thing_property"></span></p>
	<a href="read_update_thing.htm"><button>Update Thing</button></a>
	<h1>Location</h1>
	<p><span class="bold">Name: </span><span id="location_name"></span></p>
	<p><span class="bold">Description: </span><span id="location_description"></span></p>
	<p><span class="bold">Encoding: </span><span id="location_encoding"></span></p>
	<p><span class="bold">Type: </span><span id="location_type"></span></p>
	<p><span class="bold">Coordinates: </span></p>
	<ul>
		<li><span class="bold">Longitude: </span><span id="location_longitude"></span></li>
		<li><span class="bold">Latitude: </span><span id="location_latitude"></li>
	</ul>
	<a href="read_update_location.htm"><button>Update Location</button></a>
	<div id="mapid"></div>
	<h1>Datastream</h1>
	<script>
		// Functions to create a new element with certain class(es) or text(s) inside a parent element
		function create_element(parentElement,newElement,newText,newAttribute1,attributeValue1,newAttribute2,attributeValue2){
			if (newElement !== null){
				let element = document.createElement(newElement);
				if (newAttribute1 !== null && attributeValue1 !== null){
					let attribute = document.createAttribute(newAttribute1);
					attribute.value = attributeValue1;
					element.setAttributeNode(attribute);
				}
				if (newAttribute2 !== null && attributeValue2 !== null){
					let attribute = document.createAttribute(newAttribute2);
					attribute.value = attributeValue2;
					element.setAttributeNode(attribute);
				}
				if (newText !== null){
					let text = document.createTextNode(newText);
					element.appendChild(text);
				}
				document.querySelector(parentElement).appendChild(element);
			} else {
				let text = document.createTextNode(newText);
				document.querySelector(parentElement).appendChild(text);
			}
		};
		// Read the data in JSON format from the SensorUp server then update the page based on the data
		var thing_id = '$thing_id';
		console.log("Thing ID: " + thing_id);
		var thing = $.ajax({
			url: "'$base_url'/Things(" + thing_id + ")?$expand=Locations,Datastreams",
			type: "GET",
			contentType: "application/json; charset=utf-8",
			success: function(data){
				// Read Thing entity
				console.log("Thing Name: " + thing.responseJSON.name);
				document.querySelector("#thing_name").textContent = thing.responseJSON.name;
				console.log("Thing Description: " + thing.responseJSON.description);
				document.querySelector("#thing_description").textContent = thing.responseJSON.description;
				console.log("Thing Properties: " + JSON.stringify(thing.responseJSON.properties));
				document.querySelector("#thing_property").textContent = JSON.stringify(thing.responseJSON.properties);
				// Read Location entity
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
				// Create map visualisation
				var mymap = L.map('"'"'mapid'"'"').setView([location_latitude, location_longitude], 17);
				L.tileLayer('"'"'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw'"'"', {
					attribution: '"'"'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'"'"',
					maxZoom: 18,
					id: '"'"'mapbox.streets'"'"'
				}).addTo(mymap);
				var marker = L.marker([location_latitude, location_longitude]).addTo(mymap);
				marker.bindPopup("Thing'"'"'s location.").openPopup();
				// Read Datastream(s) entity(ies)
				datastream = thing.responseJSON.Datastreams;
				console.log("Number of datastream: " + datastream.length);
				for (let i = 0; i < datastream.length; i++) {
					let datastream_id = datastream[i]["@iot.id"];
					console.log("Datastream ID: " + datastream_id);
					let datastream_name = datastream[i].name
					console.log("Datastream Name: " + datastream_name);
					// Create unique div to contain each datastream
					create_element("body","div",null,"id","container_" + datastream_id,null,null);
					// Create h2 element
					create_element("#container_" + datastream_id,"h2",datastream_name,"id","h2_" + datastream_id,null,null);
					create_element("#h2_" + datastream_id,"span"," show ",null,null,null,null);
					create_element("#h2_" + datastream_id + " span","a","chart","href","datastream_" + datastream_id + "_chart.htm","target","_blank");
					create_element("#h2_" + datastream_id + " span",null," | ",null,null,null,null);
					create_element("#h2_" + datastream_id + " span","a","gauge","href","datastream_" + datastream_id + "_gauge.htm","target","_blank");
					//Create Datastream ID
					create_element("#container_" + datastream_id,"p",null,"id","datastream_id_" + datastream_id,null,null);
					create_element("#datastream_id_" + datastream_id,"span","ID: ","class","bold",null,null);
					create_element("#datastream_id_" + datastream_id,null,datastream_id,null,null,null,null);
					// Create Datastream Description
					console.log("Datastream Description: " + datastream[i].description);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_description_" + datastream_id,null,null);
					create_element("#datastream_description_" + datastream_id,"span","Description: ","class","bold",null,null);
					create_element("#datastream_description_" + datastream_id,null,datastream[i].description,null,null,null,null);
					// Create Datastream Observation Type
					console.log("Datastream Observation Type: " + datastream[i].observationType);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_observation_type_" + datastream_id,null,null);
					create_element("#datastream_observation_type_" + datastream_id,"span","Observation Type: ","class","bold",null,null);
					create_element("#datastream_observation_type_" + datastream_id,null,datastream[i].observationType,null,null,null,null);
					// Create Datastream Unit of Measurement Name
					console.log("Datastream Unit of Measurement Name: " + datastream[i].unitOfMeasurement.name);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_name_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_name_" + datastream_id,"span","Unit of Measurement: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_name_" + datastream_id,null,datastream[i].unitOfMeasurement.name,null,null,null,null);
					// Create Datastream Unit of Measurement Symbol
					console.log("Datastream Unit of Measurement Symbol: " + datastream[i].unitOfMeasurement.symbol);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_symbol_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_symbol_" + datastream_id,"span","Symbol: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_symbol_" + datastream_id,null,datastream[i].unitOfMeasurement.symbol,null,null,null,null);
					// Create Datastream Unit of Measurement Definition
					console.log("Datastream Unit of Measurement Definition: " + datastream[i].unitOfMeasurement.definition);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_definition_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_definition_" + datastream_id,"span","Definition: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_definition_" + datastream_id,null,datastream[i].unitOfMeasurement.definition,null,null,null,null);
					// Create Observed Property heading
					create_element("#container_" + datastream_id,"h3","Observed Property",null,null,null,null);
					// Create unordered list elements under Observed Property
					create_element("#container_" + datastream_id,"ul",null,"class","observed_property",null,null);
					// Create Sensor heading
					create_element("#container_" + datastream_id,"h3","Sensor",null,null,null,null);
					// Create unordered list elements under Sensor
					create_element("#container_" + datastream_id,"ul",null,"class","sensor",null,null);
					print_datastream_detail(datastream_id);
				}
				create_element("body","a",null,"href","read_update_datastream.htm","id","update_datastream");
				create_element("#update_datastream","button","Update Datastream",null,null,null,null);
				// Add some lines to escape link in the bottom of the page
				create_element("body","br",null,null,null,null,null);
				create_element("body","br",null,null,null,null,null);
			},
			error: function(response, status){
				console.log(response);
				console.log(status);
			}
		});
		function print_datastream_detail(datastream_id){
			var datastream_detail = $.ajax({
				url: "'$base_url'/Datastreams(" + datastream_id + ")?$expand=ObservedProperty,Sensor",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					function create_list(listTitle,listSource,listMode,listDisplay){
						console.log(listTitle + listSource);
						create_element("#container_" + datastream_id + " ul." + listMode,"li",null,null,null,null,null);
						create_element("#container_" + datastream_id + " ul." + listMode + " li:last-child","span",listDisplay,"class","bold",null,null);
						create_element("#container_" + datastream_id + " ul." + listMode + " li:last-child",null,listSource,null,null,null,null);
					};
					// Observed Property Name
					create_list("Observed Property Name: ",datastream_detail.responseJSON.ObservedProperty.name,"observed_property","Name: ");
					// Observed Property Description
					create_list("Observed Property Description: ",datastream_detail.responseJSON.ObservedProperty.description,"observed_property","Description: ");
					// Observed Property Definition
					create_list("Observed Property Definition: ",datastream_detail.responseJSON.ObservedProperty.definition,"observed_property","Definition: ");
					// Sensor Name
					create_list("Sensor Name: ",datastream_detail.responseJSON.Sensor.name,"sensor","Name: ");
					// Sensor Description
					create_list("Sensor Description: ",datastream_detail.responseJSON.Sensor.description,"sensor","Description: ");
					// Sensor Encoding Type
					create_list("Sensor Encoding Type: ",datastream_detail.responseJSON.Sensor.encodingType,"sensor","Encoding Type: ");
					// Sensor Metadata
					create_list("Sensor Metadata: ",datastream_detail.responseJSON.Sensor.metadata,"sensor","Metadata: ");
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		}
	</script>
</body>
</html>' > visualisation/index.htm

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
}
textarea {
	width: 100%;
}
h2 textarea {
	color: blue;
	font-weight: bold;
	font-size: 1em;
}
img:hover {
	cursor: pointer;
}' > visualisation/main.css

number_of_datastream=`cat configuration.txt | grep datastream_name | wc -l`
for (( i=1; i<=$number_of_datastream; i++ )); do
	datastream_id=`echo $datastream_query | sed 's/@iot.id/\n@iot.id/g' | grep @iot.id | tail -$i | head -1 | cut -d ":" -f 2 | cut -d "," -f 1`
	echo '	#datastream_'$datastream_id' {
		min-width: 300px;
		max-width: 555px;
		height: 250px;
		margin: 0 auto;
	}' >> visualisation/main.css
done

# Put main.css into the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/main.css"

####################################################
# Create individual chart page for each datastream #
####################################################

#=======#
# Chart #
#=======#

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

#=======#
# Gauge #
#=======#

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
			url: "'$base_url'/Things(" + thing_id + ")",
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
				url: "'$base_url'/Things(" + thing_id + ")",
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

########################################
# Create read_update_location.htm page #
########################################

echo '<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Project RATIH - Update Location</title>
	<link rel="stylesheet" href="main.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>
	<h1>Update Location</h1>
	<p class="bold">name</p>
	<textarea id="location_name" rows="1" placeholder="String"></textarea>
	<p class="bold">description</p>
	<textarea id="location_description" rows="1" placeholder="String"></textarea>
	<p class="bold">coordinates</p>
	<ul>
		<li><p class="bold">longitude</p><textarea id="location_longitude" rows="1" placeholder="Number"></textarea></li>
		<li><p class="bold">latitude</p><textarea id="location_latitude" rows="1" placeholder="Number"></textarea></li>
	</ul>
	<button id="update_thing" onclick="updateLocation();">Update Location</button>
	<a href="index.htm"><button>Back to main page</button></a>
	<script>
		var thing = $.ajax({
			url: "'$base_url'/Things('$thing_id')?$expand=Locations,Datastreams",
			type: "GET",
			contentType: "application/json; charset=utf-8",
			success: function(data){
				var location = JSON.stringify(thing.responseJSON.Locations);
				location = location.slice(1,location.length-1);
				console.log("Location: " + location);
				location = JSON.parse(location);
				var location_id = location["@iot.id"];
				console.log("Location ID: " + location_id);
				console.log("Location Name: " + location.name);
				document.querySelector("#location_name").textContent = location.name;
				console.log("Location Description: " + location.description);
				document.querySelector("#location_description").textContent = location.description;
				var location_longitude = location.location.coordinates[0];
				console.log("Location Longitude: " + location_longitude);
				document.querySelector("#location_longitude").textContent = location_longitude;
				var location_latitude = location.location.coordinates[1];
				console.log("Location Latitude: " + location_latitude);
				document.querySelector("#location_latitude").textContent = location_latitude;
			},
			error: function(response, status){
				console.log(response);
				console.log(status);
			}
		});
		function updateLocation(){
			var thing = $.ajax({
				url: "'$base_url'/Things('$thing_id')?$expand=Locations,Datastreams",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					var location = JSON.stringify(thing.responseJSON.Locations);
					location = location.slice(1,location.length-1);
					location = JSON.parse(location);
					var location_id = location["@iot.id"];
					var location_name = document.querySelector("#location_name").value;
					console.log("Location Name: " + location_name);
					var location_description = document.querySelector("#location_description").value;
					console.log("Location Description: " + location_description);
					var location_longitude = document.querySelector("#location_longitude").value;
					console.log("Longitude: " + location_longitude);
					var location_latitude = document.querySelector("#location_latitude").value;
					console.log("Latitude: " + location_latitude);
					location = '"'"'{'"'"';
					location = location + '"'"'"name": "'"'"' + location_name + '"'"'", "description": "'"'"' + location_description + '"'"'", "encodingType": "application/vnd.geo+json", "location": {"type": "Point", "coordinates": ['"'"' + location_longitude + '"'"','"'"' + location_latitude + '"'"']}}'"'"';
					console.log("Location: " + location);
					$.ajax({
						url: "'$base_url'/Locations(" + location_id + ")",
						type: "PATCH",
						data: location,
						contentType: "application/json; charset=utf-8",
						success: function(data){
							console.log(data);
							var user_info_node = document.createElement("p");
							var user_info_text = document.createTextNode("Location has been updated!");
							user_info_node.appendChild(user_info_text);
							document.querySelector("body").appendChild(user_info_node);
						},
						error: function(response, status){
							console.log(response);
							console.log(status);
						}
					});
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		}
	</script>
</body>
</html>' > visualisation/read_update_location.htm

# Put read_update_location.htm file to the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/read_update_location.htm"

##########################################
# Create read_update_datastream.htm page #
##########################################

echo '<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Project RATIH - Update Datastream</title>
	<link rel="stylesheet" href="main.css">
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.3.1/dist/leaflet.css"
   integrity="sha512-Rksm5RenBEKSKFjgI3a41vrjkw4EVPlJ3+OiI65vTjIdo9brlAacEuKOiQ5OFh7cOI1bkDwLqdLw3Zg0cRJAAQ=="
   crossorigin="">
	<script src="https://unpkg.com/leaflet@1.3.1/dist/leaflet.js"
   integrity="sha512-/Nsx9X4HebavoBvEBuyp3I7od5tA0UzAxs+j83KgC8PU0kgB4XiK4Lfe4y4cgBtaRJQEIFCW+oC506aPT2L1zw=="
   crossorigin=""></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
</head>
<body>
	<h1>Datastream</h1>
	<script>
		// Functions to create a new element with certain class(es) or text(s) inside a parent element
		function create_element(parentElement,newElement,newText,newAttribute1,attributeValue1,newAttribute2,attributeValue2){
			if (newElement !== null){
				let element = document.createElement(newElement);
				if (newAttribute1 !== null && attributeValue1 !== null){
					let attribute = document.createAttribute(newAttribute1);
					attribute.value = attributeValue1;
					element.setAttributeNode(attribute);
				}
				if (newAttribute2 !== null && attributeValue2 !== null){
					let attribute = document.createAttribute(newAttribute2);
					attribute.value = attributeValue2;
					element.setAttributeNode(attribute);
				}
				if (newText !== null){
					let text = document.createTextNode(newText);
					element.appendChild(text);
				}
				document.querySelector(parentElement).appendChild(element);
			} else {
				let text = document.createTextNode(newText);
				document.querySelector(parentElement).appendChild(text);
			}
		};
		// Read the data in JSON format from the SensorUp server then update the page based on the data
		var thing_id = '$thing_id';
		console.log("Thing ID: " + thing_id);
		var thing = $.ajax({
			url: "'$base_url'/Things(" + thing_id + ")?$expand=Locations,Datastreams",
			type: "GET",
			contentType: "application/json; charset=utf-8",
			success: function(data){
				// Read Datastream(s) entity(ies)
				datastream = thing.responseJSON.Datastreams;
				console.log("Number of datastream: " + datastream.length);
				for (let i = 0; i < datastream.length; i++) {
					let datastream_id = datastream[i]["@iot.id"];
					console.log("Datastream ID: " + datastream_id);
					let datastream_name = datastream[i].name
					console.log("Datastream Name: " + datastream_name);
					// Create unique div to contain each datastream
					create_element("body","div",null,"id","container_" + datastream_id,null,null);
					// Create h2 element
					create_element("#container_" + datastream_id,"h2",null,"id","h2_" + datastream_id,null,null);
					create_element("#h2_" + datastream_id,"textarea",datastream_name,"placeholder","String",null,null);
					//Create Datastream ID
					create_element("#container_" + datastream_id,"p",null,"id","datastream_id_" + datastream_id,null,null);
					create_element("#datastream_id_" + datastream_id,"span","ID: ","class","bold",null,null);
					create_element("#datastream_id_" + datastream_id,null,datastream_id,null,null,null,null);
					// Create Datastream Description
					console.log("Datastream Description: " + datastream[i].description);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_description_" + datastream_id,null,null);
					create_element("#datastream_description_" + datastream_id,"span","Description: ","class","bold",null,null);
					create_element("#datastream_description_" + datastream_id,"textarea",datastream[i].description,"placeholder","String",null,null);
					// Create Datastream Observation Type
					console.log("Datastream Observation Type: " + datastream[i].observationType);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_observation_type_" + datastream_id,null,null);
					create_element("#datastream_observation_type_" + datastream_id,"span","Observation Type: ","class","bold",null,null);
					create_element("#datastream_observation_type_" + datastream_id,"textarea",datastream[i].observationType,"placeholder","String",null,null);
					// Create Datastream Unit of Measurement Name
					console.log("Datastream Unit of Measurement Name: " + datastream[i].unitOfMeasurement.name);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_name_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_name_" + datastream_id,"span","Unit of Measurement: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_name_" + datastream_id,"textarea",datastream[i].unitOfMeasurement.name,"placeholder","String",null,null);
					// Create Datastream Unit of Measurement Symbol
					console.log("Datastream Unit of Measurement Symbol: " + datastream[i].unitOfMeasurement.symbol);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_symbol_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_symbol_" + datastream_id,"span","Symbol: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_symbol_" + datastream_id,"textarea",datastream[i].unitOfMeasurement.symbol,"placeholder","String",null,null);
					// Create Datastream Unit of Measurement Definition
					console.log("Datastream Unit of Measurement Definition: " + datastream[i].unitOfMeasurement.definition);
					create_element("#container_" + datastream_id,"p",null,"id","datastream_unit_of_measurement_definition_" + datastream_id,null,null);
					create_element("#datastream_unit_of_measurement_definition_" + datastream_id,"span","Definition: ","class","bold",null,null);
					create_element("#datastream_unit_of_measurement_definition_" + datastream_id,"textarea",datastream[i].unitOfMeasurement.definition,"placeholder","String",null,null);
					// Create Observed Property heading
					create_element("#container_" + datastream_id,"h3","Observed Property",null,null,null,null);
					// Create unordered list elements under Observed Property
					create_element("#container_" + datastream_id,"ul",null,"class","observed_property",null,null);
					// Create Sensor heading
					create_element("#container_" + datastream_id,"h3","Sensor",null,null,null,null);
					// Create unordered list elements under Sensor
					create_element("#container_" + datastream_id,"ul",null,"class","sensor",null,null);
					print_datastream_detail(datastream_id);
				}
				create_element("body","a",null,"id","update_datastream",null,null);
				create_element("#update_datastream","button","Update Datastream(s)","onclick","update_datastream();",null,null);
				create_element("body","span"," ",null,null,null,null);
				create_element("body","a",null,"href","index.htm","id","back_to_main_page");
				create_element("#back_to_main_page","button","Back to main page",null,null,null,null);
				// Add line break to escape linkn in the bottom of the page
				create("body","br",null,null,null,null,null);
				create("body","br",null,null,null,null,null);
			},
			error: function(response, status){
				console.log(response);
				console.log(status);
			}
		});
		function print_datastream_detail(datastream_id){
			var datastream_detail = $.ajax({
				url: "'$base_url'/Datastreams(" + datastream_id + ")?$expand=ObservedProperty,Sensor",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					function create_list(listTitle,listSource,listMode,listDisplay,idList){
						console.log(listTitle + listSource);
						create_element("#container_" + datastream_id + " ul." + listMode,"li",null,"id",idList + datastream_id,null,null);
						create_element("#container_" + datastream_id + " ul." + listMode + " li:last-child","span",listDisplay,"class","bold",null,null);
						create_element("#container_" + datastream_id + " ul." + listMode + " li:last-child","textarea",listSource,"placeholder","String",null,null);
					};
					// Observed Property Name
					create_list("Observed Property Name: ",datastream_detail.responseJSON.ObservedProperty.name,"observed_property","Name: ","name_");
					// Observed Property Description
					create_list("Observed Property Description: ",datastream_detail.responseJSON.ObservedProperty.description,"observed_property","Description: ","description_");
					// Observed Property Definition
					create_list("Observed Property Definition: ",datastream_detail.responseJSON.ObservedProperty.definition,"observed_property","Definition: ","definition_");
					// Sensor Name
					create_list("Sensor Name: ",datastream_detail.responseJSON.Sensor.name,"sensor","Name: ","name_");
					// Sensor Description
					create_list("Sensor Description: ",datastream_detail.responseJSON.Sensor.description,"sensor","Description: ","description_");
					// Sensor Encoding Type
					create_list("Sensor Encoding Type: ",datastream_detail.responseJSON.Sensor.encodingType,"sensor","Encoding Type: ","encoding_type_");
					// Sensor Metadata
					create_list("Sensor Metadata: ",datastream_detail.responseJSON.Sensor.metadata,"sensor","Metadata: ","metadata_");
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		};
		function update_datastream(){
			let thing = $.ajax({
				url: "'$base_url'/Things(" + thing_id + ")?$expand=Locations,Datastreams",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					// Read Datastream(s) entity(ies)
					datastream = thing.responseJSON.Datastreams;
					console.log("Number of datastream: " + datastream.length);
					for (let i = 0; i < datastream.length; i++) {
						let datastream_id = datastream[i]["@iot.id"];
						console.log("Datastream ID: " + datastream_id);
						let datastream_name = document.querySelector("#h2_" + datastream_id + " textarea").value;
						console.log("New Datastream Name: " + datastream_name);
						let datastream_description = document.querySelector("p#datastream_description_" + datastream_id + " textarea").value;
						console.log("New Datastream Description: " + datastream_description);
						let datastream_observation_type = document.querySelector("p#datastream_observation_type_" + datastream_id + " textarea").value;
						console.log("New Datastream Observation Type: " + datastream_observation_type);
						let datastream_unit_of_measurement_name = document.querySelector("p#datastream_unit_of_measurement_name_" + datastream_id + " textarea").value;
						console.log("New Unit of Measurement Name: " + datastream_unit_of_measurement_name);
						let datastream_unit_of_measurement_symbol = document.querySelector("p#datastream_unit_of_measurement_symbol_" + datastream_id + " textarea").value;
						console.log("New Unit of Measurement Symbol: " + datastream_unit_of_measurement_symbol);
						let datastream_unit_of_measurement_definition = document.querySelector("p#datastream_unit_of_measurement_definition_" + datastream_id + " textarea").value;
						console.log("New Unit of Measurement Definition: " + datastream_unit_of_measurement_definition);
						let new_datastream = JSON.stringify({
							"name": datastream_name,
							"description": datastream_description,
							"observationType": datastream_observation_type,
							"unitOfMeasurement": {
								"name": datastream_unit_of_measurement_name,
								"symbol": datastream_unit_of_measurement_symbol,
								"definition": datastream_unit_of_measurement_definition
							}
						});
						console.log("New datastream: " + new_datastream);
						$.ajax({
							url: "'$base_url'/Datastreams(" + datastream_id + ")",
							type: "PATCH",
							data: new_datastream,
							contentType: "application/json; charset=utf-8",
							success: function(data){
								update_observed_property(datastream_id);
								update_sensor(datastream_id);
							},
							error: function(response, status){
								console.log(response);
								console.log(status);
							}
						});
					}
					create_element("body","p","Datastream has been updated.",null,null,null,null);
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		};
		function update_observed_property(datastream_id){
			var observed_property_detail = $.ajax({
				url: "'$base_url'/Datastreams(" + datastream_id + ")?$expand=ObservedProperty,Sensor",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					let observed_property_id = observed_property_detail.responseJSON.ObservedProperty["@iot.id"];
					console.log("Observed Property ID: " + observed_property_id);
					let observed_property_name = document.querySelector("ul.observed_property li#name_" + datastream_id + " textarea").value;
					console.log("New Observed Property Name: " + observed_property_name);
					let observed_property_description = document.querySelector("ul.observed_property li#description_" + datastream_id + " textarea").value;
					console.log("New Observed Property Description: " + observed_property_description);
					let observed_property_definition = document.querySelector("ul.observed_property li#definition_" + datastream_id + " textarea").value;
					console.log("New Observed Property Definition: " + observed_property_definition);
					let new_observed_property = JSON.stringify({
						"name": observed_property_name,
						"description": observed_property_description,
						"definition": observed_property_definition
					});
					console.log("New Observed Property: " + new_observed_property);
					$.ajax({
						url: "'$base_url'/ObservedProperties(" + observed_property_id + ")",
						type: "PATCH",
						data: new_observed_property,
						contentType: "application/json; charset=utf-8",
						success: function(data){
							console.log("Observed property with id " + observed_property_id + " has been updated.");
						},
						error: function(response, status){
							console.log(response);
							console.log(status);
						}
					});
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		};
		function update_sensor(datastream_id){
			var sensor_detail = $.ajax({
				url: "'$base_url'/Datastreams(" + datastream_id + ")?$expand=ObservedProperty,Sensor",
				type: "GET",
				contentType: "application/json; charset=utf-8",
				success: function(data){
					let sensor_id = sensor_detail.responseJSON.Sensor["@iot.id"];
					console.log("Sensor ID: " + sensor_id);
					let sensor_name = document.querySelector("ul.sensor li#name_" + datastream_id + " textarea").value;
					console.log("New Sensor Name: " + sensor_name);
					let sensor_description = document.querySelector("ul.sensor li#description_" + datastream_id + " textarea").value;
					console.log("New Sensor Description: " + sensor_description);
					let sensor_encoding_type = document.querySelector("ul.sensor li#encoding_type_" + datastream_id + " textarea").value;
					console.log("New Sensor Encoding Type: " + sensor_encoding_type);
					let sensor_metadata = document.querySelector("ul.sensor li#metadata_" + datastream_id + " textarea").value;
					console.log("New Sensor Metadata: " + sensor_metadata);
					let new_sensor = JSON.stringify({
						"name": sensor_name,
						"description": sensor_description,
						"encodingType": sensor_encoding_type,
						"metadata": sensor_metadata
					});
					console.log("New Sensor: " + new_sensor);
					$.ajax({
						url: "'$base_url'/Sensors(" + sensor_id + ")",
						type: "PATCH",
						data: new_sensor,
						contentType: "application/json; charset=utf-8",
						success: function(data){
							console.log("Sensor with id " + sensor_id + " has been updated.");
						},
						error: function(response, status){
							console.log(response);
							console.log(status);
						}
					});
				},
				error: function(response, status){
					console.log(response);
					console.log(status);
				}
			});
		};
	</script>
</body>
</html>' > visualisation/read_update_datastream.htm

# Put read_update_location.htm file to the visualisation server

lftp -c "open -p 21 -u $username,$password $site; cd public_html; put visualisation/read_update_datastream.htm"
