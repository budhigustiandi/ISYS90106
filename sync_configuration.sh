#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`

############################
# Synchronize thing entity #
############################

# Read thing entity from the server
#thing=`curl -X GET -H "Content-Type: application/json" "$base_url/Things($thing_id)"`
thing={"@iot.id":1684190,"@iot.selfLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)","description":"Test device used to implement RAspberry-based automaTIon for sensortHings API","name":"Project RATIH version 3","properties":{"Position Status":"Static Non-GPS","Last Update":"17 March 2018 5:23 p.m.","Version 3":"Visual Control Automation","Version 2":"Visualisation automation","Version 1":"Processing automation","Creator":"Budhi Gustiandi","Hardware Used":"Raspberry Pi 3"},"Datastreams@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/Datastreams","HistoricalLocations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/HistoricalLocations","Locations@iot.navigationLink":"http://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things(1684190)/Locations"}
echo $thing
echo ""

# Extract the thing name
thing_name=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.id/\n@iot.id/g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep name`
thing_name=`echo $thing_name | cut -d ":" -f 2`
thing_name=`echo $thing_name | cut -d "," -f 1`
echo "Thing Name: "$thing_name

# Extract the thing description
thing_description=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.id/\n@iot.id/g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep description`
thing_description=`echo $thing_description | cut -d ":" -f 2`
thing_description=`echo $thing_description | cut -d "," -f 1`
echo "Thing Description: "$thing_description

# Update the configuration.txt file
while read line; do
	echo $line | grep thing_name
	if [[ $? -eq 0 ]]; then
		echo "thing_name="$thing_name >> temporary_configuration.txt
	else
		echo $line | grep thing_description
		if [[ $? -eq 0 ]]; then
			echo "thing_description="$thing_description >> temporary_configuration.txt
		else
			echo $line | grep ^property_name
			if [[ $? -eq 0 ]]; then
				echo ""
			else
				echo $line | grep ^property_description
				if [[ $? -eq 0 ]]; then
					echo ""
				else
					echo $line >> temporary_configuration.txt
				fi
			fi
		fi
	fi
done < configuration_test.txt
mv temporary_configuration.txt configuration_test.txt

# Extract the thing properties
thing_properties=`echo $thing | sed -e 's/^{//g' -e 's/}$//g' -e 's/@iot.id/\n@iot.id/g' -e 's/@iot.selfLink/\n@iot.selfLink/g' -e 's/name/\nname/g' -e 's/description/\ndescription/g' -e 's/properties/\nproperties/g' -e 's/Datastreams@iot/\nDatastreams@iot/g' -e 's/HistoricalLocations@iot/\nHistoricalLocations@iot/g' -e 's/,Locations@iot/,\nLocations@iot/g' | grep properties`
thing_properties=`echo $thing_properties | cut -d "{" -f 2`
thing_properties=`echo $thing_properties | cut -d "}" -f 1`
echo "Thing Properties: "$thing_properties
number_of_thing_properties=`echo $thing_properties | sed 's/,/\n/g' | wc -l`
echo "Number of Thing Properties: "$number_of_thing_properties

# Update the configuration.txt file
while read line; do
	echo $line | grep "# Optional"
	if [[ $? -eq 0 ]]; then
		echo "# Optional" >> temporary_configuration.txt
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
	else
		echo $line >> temporary_configuration.txt
	fi
done < configuration_test.txt
mv temporary_configuration.txt configuration_test.txt

###############################
# Synchronize location entity #
###############################

#################################
# Synchronize datastream entity #
#################################

########################################
# Synchronize observed property entity #
########################################

#############################
# Synchronize sensor entity #
#############################