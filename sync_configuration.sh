#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

########################################
# Extract thing entity from the server #
########################################

#thing=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)"`
thing={"@iot.id":1684190,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)","description":"Test device used to implement RAspberry-based automaTIon for sensortHings API","name":"Project RATIH version 3","properties":{"Position Status":"Static Non-GPS","Last Update":"17 March 2018 5:23 p.m.","Version 3":"Visual Control Automation","Version 2":"Visualisation automation","Version 1":"Processing automation","Creator":"Budhi Gustiandi","Hardware Used":"Raspberry Pi 3"},"Datastreams@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/Datastreams","HistoricalLocations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/HistoricalLocations","Locations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/Locations"}
echo "Thing: "$thing
echo ""

# Extract the thing name
thing_name=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep name`
thing_name=`echo $thing_name | cut -d ":" -f 2`
thing_name=`echo $thing_name | cut -d "," -f 1`
echo "Thing Name: "$thing_name

# Extract the thing description
thing_description=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.id/\n@iot.id/g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep description`
thing_description=`echo $thing_description | cut -d ":" -f 2`
thing_description=`echo $thing_description | cut -d "," -f 1`
echo "Thing Description: "$thing_description

# Extract the thing properties
thing_properties=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.id/\n@iot.id/g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep properties`
thing_properties=`echo $thing_properties | cut -d "{" -f 2`
thing_properties=`echo $thing_properties | cut -d "}" -f 1`
echo "Thing Properties: "$thing_properties
number_of_thing_properties=`echo $thing_properties | sed 's/,/\n/g' | wc -l`
echo "Number of Thing Properties: "$number_of_thing_properties
echo ""

###########################################
# Extract location entity from the server #
###########################################

#location=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)/Locations"`
location={"@iot.count":1,"value":[{"@iot.id":1684192,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Locations(1684192)","description":"Workspace at home built into an operating laboratory","name":"SensorThings Laboratory","encodingType":"application/vnd.geo+json","location":{"coordinates":[144.960282,-37.808569],"type":"Point"},"Things@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Locations(1684192)/Things","HistoricalLocations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Locations(1684192)/HistoricalLocations"}]}
location=`echo $location | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.count/\n@iot.count/g' -e 's/value/\nvalue/g'| grep value`
location=`echo $location | sed -e 's/value:\[{//g' -e 's/}\]$//g'`
echo "Location: "$location
echo ""

# Extract the location name
location_name=`echo $location | sed -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/description/\ndescription/g' -e 's/name/\nname/g' -e 's/encodingType/\nencodingType/g' -e 's/location/\nlocation/g' -e 's/Things@iot.navigationLink/\nThings@iot.navigationLink/g' -e 's/HistoricalLocations@iot.navigationLink/\nHistoricalLocations@iot.navigationLink/g' | grep ^name`
location_name=`echo $location_name | cut -d ":" -f 2`
location_name=`echo $location_name | cut -d "," -f 1`
echo "Location Name: "$location_name

# Extract the location description
location_description=`echo $location | sed -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/description/\ndescription/g' -e 's/name/\nname/g' -e 's/encodingType/\nencodingType/g' -e 's/location/\nlocation/g' -e 's/Things@iot.navigationLink/\nThings@iot.navigationLink/g' -e 's/HistoricalLocations@iot.navigationLink/\nHistoricalLocations@iot.navigationLink/g' | grep ^description`
location_description=`echo $location_description | cut -d ":" -f 2`
location_description=`echo $location_description | cut -d "," -f 1`
echo "Location Description: "$location_description

# Extract the location longitude
location_longitude=`echo $location | sed -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/description/\ndescription/g' -e 's/name/\nname/g' -e 's/encodingType/\nencodingType/g' -e 's/location/\nlocation/g' -e 's/Things@iot.navigationLink/\nThings@iot.navigationLink/g' -e 's/HistoricalLocations@iot.navigationLink/\nHistoricalLocations@iot.navigationLink/g' | grep ^location`
location_longitude=`echo $location_longitude | sed -e 's/location:{//g' -e 's/}$//g' -e 's/type/\type/g' | grep ^coordinates`
location_longitude=`echo $location_longitude | cut -d ":" -f 2`
location_longitude=`echo $location_longitude | cut -d "," -f 1`
location_longitude=`echo $location_longitude | cut -d "[" -f 2`
echo "Location Longitude: "$location_longitude

# Extract the location latitude
location_latitude=`echo $location | sed -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/description/\ndescription/g' -e 's/name/\nname/g' -e 's/encodingType/\nencodingType/g' -e 's/location/\nlocation/g' -e 's/Things@iot.navigationLink/\nThings@iot.navigationLink/g' -e 's/HistoricalLocations@iot.navigationLink/\nHistoricalLocations@iot.navigationLink/g' | grep ^location`
location_latitude=`echo $location_latitude | sed -e 's/location:{//g' -e 's/}$//g' -e 's/type/\type/g' | grep ^coordinates`
location_latitude=`echo $location_latitude | cut -d ":" -f 2`
location_latitude=`echo $location_latitude | cut -d "," -f 2`
location_latitude=`echo $location_latitude | cut -d "]" -f 1`
echo "Location Latitude: "$location_latitude
echo ""

#############################################
# Extract datastream entity from the server #
#############################################

####################################################
# Extract observed property entity from the server #
####################################################

#########################################
# Extract sensor entity from the server #
#########################################

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

for (( i=1; i<=$number_of_thing_properties; i++ )); do
	properties_detail=`echo $thing_properties | sed 's/,/\n/g' | head -$i | tail -1`
	property_name=`echo $properties_detail | cut -d ":" -f 1`
	echo "Property Name $i: "$property_name
	echo "property_name="$property_name >> temporary_configuration.txt
	property_description=`echo $properties_detail | cut -d ":" -f 2`
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

#####################
# DATASTREAM ENTITY #
#####################

# Add as many as datastream(s) and associated observed property(ies), sensor(s) and observation(s) that are needed to be connected to the thing

datastream_name=Room Temperature
datastream_description=Datastream for recording temperature
datastream_observation_type=http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement
unit_of_measurement_name=Degree Celcius
unit_of_measurement_symbol=degC
unit_of_measurement_definition=http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#DegreeCelcius

#####################
# OBSERVED PROPERTY #
#####################

observed_property_name=Area Temperature
observed_property_description=A physical quantity expressing hot and cold
observed_property_definition=http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AreaTemperature

##########
# SENSOR #
##########

sensor_name=DHT11
sensor_description=DHT11 temperature and humidity module
sensor_encoding_type=application/pdf
sensor_metadata=https://akizukidenshi.com/download/ds/aosong/DHT11.pdf

###############
# OBSERVATION #
###############

observation_command=read_temperature.py

datastream_name=Room Humidity
datastream_description=Datastream for recording humidity
datastream_observation_type=http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement
unit_of_measurement_name=Percentage
unit_of_measurement_symbol=%
unit_of_measurement_definition=1 part of 100

#####################
# OBSERVED PROPERTY #
#####################

observed_property_name=Absolute Humidity
observed_property_description=Absolute humidity is the mass of water in a particular volume of air. It is a measure of the density of water vapor in an atmosphere.
observed_property_definition=http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#AbsoluteHumidity

##########
# SENSOR #
##########

sensor_name=DHT11
sensor_description=DHT11 temperature and humidity module
sensor_encoding_type=application/pdf
sensor_metadata=https://akizukidenshi.com/download/ds/aosong/DHT11.pdf

###############
# OBSERVATION #
###############

observation_command=read_humidity.py

datastream_name=Room Light Intensity
datastream_description=Datastream for recording light intensity
datastream_observation_type=http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement
unit_of_measurement_name=Lux
unit_of_measurement_symbol=lx
unit_of_measurement_definition=http://www.qudt.org/qudt/owl/1.0.0/unit/Instances.html#Lux

#####################
# OBSERVED PROPERTY #
#####################

observed_property_name=Luminous Flux
observed_property_description=Luminous Flux or Luminous Power is the measure of the perceived power of light. It differs from radiant flux, the measure of the total power of light emitted, in that luminous flux is adjusted to reflect the varying sensitivity of the human eye to different wavelengths of light.
observed_property_definition=http://www.qudt.org/qudt/owl/1.0.0/quantity/Instances.html#LuminousFlux

##########
# SENSOR #
##########

sensor_name=Photoresistor Light Sensor
sensor_description=A Light Sensor is something that can be used to detect the current ambient light level - i.e. how bright/dark it is. It changes its resistance based on the amount of light that falls upon it.
sensor_encoding_type=application/html
sensor_metadata=http://education.rec.ri.cmu.edu/content/electronics/boe/light_sensor/1.html

###############
# OBSERVATION #
###############

observation_command=read_light.py

########################
# OBSERVATION INTERVAL #
########################

observation_interval=60

##################################
# VISUALISATION SERVER PARAMETER #
##################################

username=budhigustiandi
password=budhigustiandi
site=files.000webhost.com' >> temporary_configuration.txt