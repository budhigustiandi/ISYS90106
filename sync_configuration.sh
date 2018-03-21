#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

########################################
# Extract thing entity from the server #
########################################

thing=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)"`
echo "Thing: "$thing

# Extract thing name
thing_name=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/"@iot.selfLink":/"@iot.selfLink":/g' -e 's/"name":/\n"name":/g' -e 's/"description":/\n"description":/g' -e 's/"properties":/\n"properties":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' -e 's/"Locations@iot.navigationLink":/\n"Locations@iot.navigationLink":/g' | grep '"name":'`
thing_name=`echo $thing_name | cut -d "\"" -f 4`
echo "Thing Name: "$thing_name

# Extract thing description
thing_description=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"name":/\n"name":/g' -e 's/"description":/\n"description":/g' -e 's/"properties":/\n"properties":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' -e 's/"Locations@iot.navigationLink":/\n"Locations@iot.navigationLink":/g' | grep '"description":'`
thing_description=`echo $thing_description | cut -d "\"" -f 4`
echo "Thing Description: "$thing_description

# Extract thing properties
thing_properties=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"name":/\n"name":/g' -e 's/"description":/\n"description":/g' -e 's/"properties":/\n"properties":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' -e 's/"Locations@iot.navigationLink":/\n"Locations@iot.navigationLink":/g' | grep '"properties":'`
thing_properties=`echo $thing_properties | cut -d "{" -f 2`
thing_properties=`echo $thing_properties | cut -d "}" -f 1`
echo "Thing Properties: "$thing_properties

number_of_thing_properties=`echo $thing_properties | sed 's/,/\n/g' | wc -l`
echo "Number of Thing Properties: "$number_of_thing_properties
echo ""

###########################################
# Extract location entity from the server #
###########################################

location=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Locations"`
location=`echo $location | sed -e 's/^{//g' -e 's/}$//g' -e 's/"@iot.count":/\n"@iot.count":/g' -e 's/"value":/\n"value":/g'| grep '"value":'`
location=`echo $location | sed -e 's/"value":\[{//g' -e 's/}\]$//g'`
echo "Location: "$location

# Extract location name
location_name=`echo $location | sed -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"location":/\n"location":/g' -e 's/"Things@iot.navigationLink":/\n"Things@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' | grep '"name":'`
location_name=`echo $location_name | cut -d "\"" -f 4`
echo "Location Name: "$location_name

# Extract location description
location_description=`echo $location | sed -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"location":/\n"location":/g' -e 's/"Things@iot.navigationLink":/\n"Things@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' | grep '"description":'`
location_description=`echo $location_description | cut -d "\"" -f 4`
echo "Location Description: "$location_description

location_coordinate=`echo $location | sed -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"location":/\n"location":/g' -e 's/"Things@iot.navigationLink":/\n"Things@iot.navigationLink":/g' -e 's/"HistoricalLocations@iot.navigationLink":/\n"HistoricalLocations@iot.navigationLink":/g' | grep '"location":'`
location_coordinate=`echo $location_coordinate | sed -e 's/"location":{//g' -e 's/}$//g' -e 's/"coordinates":/\n"coordinates":/g' -e 's/"type":/\n"type":/g' | grep '"coordinates":'`

# Extract location longitude
location_longitude=`echo $location_coordinate | cut -d ":" -f 2`
location_longitude=`echo $location_longitude | cut -d "," -f 1`
location_longitude=`echo $location_longitude | cut -d "[" -f 2`
echo "Location Longitude: "$location_longitude

# Extract location latitude
location_latitude=`echo $location_coordinate | cut -d ":" -f 2`
location_latitude=`echo $location_latitude | cut -d "," -f 2`
location_latitude=`echo $location_latitude | cut -d "]" -f 1`
echo "Location Latitude: "$location_latitude
echo ""

#############################################
# Extract datastream entity from the server #
#############################################

datastream=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Datastreams"`

# Extract number of datastream
datastream_count=`echo $datastream | cut -d ":" -f 2`
datastream_count=`echo $datastream_count | cut -d "," -f 1`
echo "Datastream Count: "$datastream_count

datastream=`echo $datastream | sed -e 's/^{//g' -e 's/}$//g' -e 's/"value":/\n"value":/g' | grep '"value":'`
datastream=`echo $datastream | sed -e 's/"value":\[//g' -e 's/\]$//g'`
echo ""

#######################################
# Create a new configuration.txt file #
#######################################

echo '############
# BASE URL #
############

base_url='$base_url'

################
# THING ENTITY #
################

# Thing ID (DO NOT CHANGE! It will only be generated automatically by the system)

thing_id='$thing_id'

# Mandatory

thing_name='$thing_name'
thing_description='$thing_description'
thing_url='$base_url'/Things

# Optional' > temporary_configuration.txt
echo "" >> temporary_configuration.txt

# Extract thing properties
for (( i=1; i<=$number_of_thing_properties; i++ )); do
	properties_detail=`echo $thing_properties | sed 's/,/\n/g' | head -$i | tail -1`
	property_name=`echo $properties_detail | cut -d "\"" -f 2`
	echo "Property Name $i: "$property_name
	echo "property_name="$property_name >> temporary_configuration.txt
	property_description=`echo $properties_detail | cut -d "\"" -f 4`
	echo "Property Description $i: "$property_description
	echo "property_description="$property_description >> temporary_configuration.txt
done

echo "" >> temporary_configuration.txt

echo '###################
# LOCATION ENTITY #
###################

# If the thing will be put in a fixed location, choose static
# If the thing will be used in mobile location, choose dynamic
# If the thing does not use GPS receiver, choose no_gps
location_status=no_gps

location_name='$location_name'
location_description='$location_description'
location_longitude='$location_longitude'
location_latitude='$location_latitude'

# Add as many as datastream(s) and associated observed property(ies), sensor(s) and observation(s) that are needed to be connected to the thing' >> temporary_configuration.txt
echo "" >> temporary_configuration.txt

for (( i=1; i<=$datastream_count; i++ )); do
	echo '######################
# DATASTREAM ENTITY '$i'#
######################' >> temporary_configuration.txt
	echo "" >> temporary_configuration.txt
	single_datastream=`echo $datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' | grep '{"@iot.id":' | tail -$i | head -1`
	echo "Datastream "$i": "$single_datastream

	# Extract datastream id
	datastream_id=`echo $single_datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"observationType":/\n"observationType":/g' -e 's/"unitOfMeasurement":/\n"unitOfMeasurement":/g' -e 's/"Observations@iot.navigationLink":/\n"Observations@iot.navigationLink":/g' -e 's/"ObservedProperty@iot.navigationLink":/\n"ObservedProperty@iot.navigationLink":/g' -e 's/"Sensor@iot.navigationLink":/\n"Sensor@iot.navigationLink":/g' -e 's/"Thing@iot.navigationLink":/\n"Thing@iot.navigationLink":/g' | grep '"@iot.id":'`
	datastream_id=`echo $datastream_id | cut -d ":" -f 2`
	datastream_id=`echo $datastream_id | cut -d "," -f 1`
	echo "Datastream ID: "$datastream_id

	# Extract datastream name
	datastream_name=`echo $single_datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"observationType":/\n"observationType":/g' -e 's/"unitOfMeasurement":/\n"unitOfMeasurement":/g' -e 's/"Observations@iot.navigationLink":/\n"Observations@iot.navigationLink":/g' -e 's/"ObservedProperty@iot.navigationLink":/\n"ObservedProperty@iot.navigationLink":/g' -e 's/"Sensor@iot.navigationLink":/\n"Sensor@iot.navigationLink":/g' -e 's/"Thing@iot.navigationLink":/\n"Thing@iot.navigationLink":/g' | grep '"name":'`
	datastream_name=`echo $datastream_name | cut -d "\"" -f 4`
	echo "Datastream Name: "$datastream_name

	# Extract datastream description
	datastream_description=`echo $single_datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"observationType":/\n"observationType":/g' -e 's/"unitOfMeasurement":/\n"unitOfMeasurement":/g' -e 's/"Observations@iot.navigationLink":/\n"Observations@iot.navigationLink":/g' -e 's/"ObservedProperty@iot.navigationLink":/\n"ObservedProperty@iot.navigationLink":/g' -e 's/"Sensor@iot.navigationLink":/\n"Sensor@iot.navigationLink":/g' -e 's/"Thing@iot.navigationLink":/\n"Thing@iot.navigationLink":/g' | grep '"description":'`
	datastream_description=`echo $datastream_description | cut -d "\"" -f 4`
	echo "Datastream Description: "$datastream_description

	# Extract datastream observation type
	datastream_observation_type=`echo $single_datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"observationType":/\n"observationType":/g' -e 's/"unitOfMeasurement":/\n"unitOfMeasurement":/g' -e 's/"Observations@iot.navigationLink":/\n"Observations@iot.navigationLink":/g' -e 's/"ObservedProperty@iot.navigationLink":/\n"ObservedProperty@iot.navigationLink":/g' -e 's/"Sensor@iot.navigationLink":/\n"Sensor@iot.navigationLink":/g' -e 's/"Thing@iot.navigationLink":/\n"Thing@iot.navigationLink":/g' | grep '"observationType":'`
	datastream_observation_type=`echo $datastream_observation_type | cut -d "\"" -f 4`
	echo "Datastream Observation Type: "$datastream_observation_type

	# Extract unit of measurement properties
	unit_of_measurement=`echo $single_datastream | sed -e 's/{"@iot.id":/\n{"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"observationType":/\n"observationType":/g' -e 's/"unitOfMeasurement":/\n"unitOfMeasurement":/g' -e 's/"Observations@iot.navigationLink":/\n"Observations@iot.navigationLink":/g' -e 's/"ObservedProperty@iot.navigationLink":/\n"ObservedProperty@iot.navigationLink":/g' -e 's/"Sensor@iot.navigationLink":/\n"Sensor@iot.navigationLink":/g' -e 's/"Thing@iot.navigationLink":/\n"Thing@iot.navigationLink":/g' | grep '"unitOfMeasurement":'`
	unit_of_measurement=`echo $unit_of_measurement | sed -e 's/"unitOfMeasurement":{//g'`
	unit_of_measurement=`echo $unit_of_measurement | sed -e 's/},//g'`
	echo "Unit of Measurement: "$unit_of_measurement
	unit_of_measurement_name=`echo $unit_of_measurement | sed -e 's/"name":/\n"name":/g' | grep '"name":'`
	unit_of_measurement_name=`echo $unit_of_measurement_name | cut -d "\"" -f 4`
	echo "Unit of Measurement Name: "$unit_of_measurement_name
	unit_of_measurement_symbol=`echo $unit_of_measurement | sed -e 's/"symbol":/\n"symbol":/g' | grep '"symbol":'`
	unit_of_measurement_symbol=`echo $unit_of_measurement_symbol | cut -d "\"" -f 4`
	echo "Unit of Measurement Symbol: "$unit_of_measurement_symbol
	unit_of_measurement_definition=`echo $unit_of_measurement | sed -e 's/"definition":/\n"definition":/g' | grep '"definition":'`
	unit_of_measurement_definition=`echo $unit_of_measurement_definition | cut -d "\"" -f 4`
	echo "Unit of Measurement Definition: "$unit_of_measurement_definition
	echo 'datastream_name='$datastream_name'
datastream_description='$datastream_description'
datastream_observation_type='$datastream_observation_type'
unit_of_measurement_name='$unit_of_measurement_name'
unit_of_measurement_symbol='$unit_of_measurement_symbol'
unit_of_measurement_definition='$unit_of_measurement_definition'

	#####################
	# OBSERVED PROPERTY #
	#####################
	' >> temporary_configuration.txt

	########################################################################
	# Extract observed property entity from the server for each datastream #
	########################################################################

	observed_property=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/ObservedProperty"`
	observed_property=`echo $observed_property | sed -e 's/^{//g' -e 's/}$//g'`

	# Extract observed property name
	observed_property_name=`echo $observed_property | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"definition":/\n"definition":/g' -e 's/"name":/\n"name":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"name":'`
	observed_property_name=`echo $observed_property_name | cut -d "\"" -f 4`
	echo "Observed Property Name: "$observed_property_name

	# Extract observed property description
	observed_property_description=`echo $observed_property | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"definition":/\n"definition":/g' -e 's/"name":/\n"name":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"description":'`
	observed_property_description=`echo $observed_property_description | cut -d "\"" -f 4`
	echo "Observed Property Description: "$observed_property_description

	# Extract observed property definition
	observed_property_definition=`echo $observed_property | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"definition":/\n"definition":/g' -e 's/"name":/\n"name":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"definition":'`
	observed_property_definition=`echo $observed_property_definition | cut -d "\"" -f 4`
	echo "Observed Property Definition: "$observed_property_definition

	echo '	observed_property_name='$observed_property_name'
	observed_property_description='$observed_property_description'
	observed_property_definition='$observed_property_definition'

	##########
	# SENSOR #
	##########
	' >> temporary_configuration.txt

	#############################################################
	# Extract sensor entity from the server for each datastream #
	#############################################################

	sensor=`curl -X GET -H "Content-Type: application/json" "$base_url/Datastreams($datastream_id)/Sensor"`
	sensor=`echo $sensor | sed -e 's/^{//g' -e 's/}$//g'`
	echo "Sensor: "$sensor

	# Extract sensor name
	sensor_name=`echo $sensor | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"metadata":/\n"metadata":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"name":'`
	sensor_name=`echo $sensor_name | cut -d '"' -f 4`
	echo "Sensor Name: "$sensor_name

	# Extract sensor description
	sensor_description=`echo $sensor | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"metadata":/\n"metadata":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"description":'`
	sensor_description=`echo $sensor_description | cut -d '"' -f 4`
	echo "Sensor Description: "$sensor_description

	# Extract sensor encoding type
	sensor_encoding_type=`echo $sensor | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"metadata":/\n"metadata":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"encodingType":'`
	sensor_encoding_type=`echo $sensor_encoding_type | cut -d '"' -f 4`
	echo "Sensor Encoding Type: "$sensor_encoding_type

	# Extract sensor metadata
	sensor_metadata=`echo $sensor | sed -e 's/"@iot.id":/\n"@iot.id":/g' -e 's/"@iot.selfLink":/\n"@iot.selfLink":/g' -e 's/"description":/\n"description":/g' -e 's/"name":/\n"name":/g' -e 's/"encodingType":/\n"encodingType":/g' -e 's/"metadata":/\n"metadata":/g' -e 's/"Datastreams@iot.navigationLink":/\n"Datastreams@iot.navigationLink":/g' | grep '"metadata":'`
	sensor_metadata=`echo $sensor_metadata | cut -d '"' -f 4`
	echo "Sensor Metadata: "$sensor_metadata

	echo '	sensor_name='$sensor_name'
	sensor_description='$sensor_description'
	sensor_encoding_type='$sensor_encoding_type'
	sensor_metadata='$sensor_metadata'

	###############
	# OBSERVATION #
	###############
	' >> temporary_configuration.txt

	observation_command=`cat configuration.txt | grep observation_command | head -$i | tail -1`
	observation_command=`echo $observation_command | cut -d "=" -f 2`
	echo '	observation_command='$observation_command'
	'>> temporary_configuration.txt
done

# Extract observation interval from configuration.txt file
observation_interval=`cat configuration.txt | grep observation_interval`
observation_interval=`echo $observation_interval | cut -d "=" -f 2`

# Extract username from configuration.txt file
username=`cat configuration.txt | grep username`
username=`echo $username | cut -d "=" -f 2`

# Extract password from configuration.txt file
password=`cat configuration.txt | grep password`
password=`echo $password | cut -d "=" -f 2`

# Extract site from configuration.txt file
site=`cat configuration.txt | grep site`
site=`echo $site | cut -d "=" -f 2`

echo '########################
# OBSERVATION INTERVAL #
########################

observation_interval='$observation_interval'

##################################
# VISUALISATION SERVER PARAMETER #
##################################

username='$username'
password='$password'
site='$site >> temporary_configuration.txt

mv temporary_configuration.txt configuration.txt
