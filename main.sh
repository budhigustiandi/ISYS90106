#!/bin/bash

############
# FUNCTION #
############

function update_thing_id {
        number_of_line=`cat configuration.txt | wc -l`
        echo "There are $number_of_line lines in configuration.txt"
        for (( i=1; i<=$number_of_line; i++ )); do
                string=`cat configuration.txt | head -$i | tail -1 | grep thing_id`
                if [[ $? -eq 0 ]]; then
                        echo "thing_id=773288" >> temporary_configuration.txt
                else
                        cat configuration.txt | head -$i | tail -1 >> temporary_configuration.txt
                fi
        done
        mv temporary_configuration.txt configuration.txt
}

########
# MAIN #
########

# Search whether the thing is already exist in the server based on the thing_id existence
# If not, create a new thing.

thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
if [[ "$thing_id" == "" ]]; then
	echo "No thing exist, a new thing will be created."
	#bash create_thing.sh
	# Retrieve the new thing id
	thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2 | sed 's/ /%20/g'`
	echo $thing_name
	curl -X GET -H "Content-Type: application/json" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things?\$filter=name%20eq%20%27$thing_name%27"
	# Update the thing_id in the configuration.txt file
else
	echo "There is a thing exist matched with the configuration.txt file in the server."
fi

# If yes, ask user whether he/she want to create a new thing or modify an existing one

# If he/she want to use an existing one, updated the thing
