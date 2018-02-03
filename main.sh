#!/bin/bash

############
# FUNCTION #
############

function create_thing {
	#bash create_thing.sh
        # Retrieve the new thing id
        thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2 | sed 's/ /%20/g'`
        curl -X GET -H "Content-Type: application/json" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Things?\$filter=name%20eq%20%27$thing_name%27" | cut -d ":" -f 4 | cut -d "," -f 1 > thing_id
        thing_id=`cat thing_id`
        rm thing_id
        # Update the thing_id in the configuration.txt file
        update_thing_id
}
function update_thing_id {
        number_of_line=`cat configuration.txt | wc -l`
        for (( i=1; i<=$number_of_line; i++ )); do
                string=`cat configuration.txt | head -$i | tail -1 | grep thing_id`
                if [[ $? -eq 0 ]]; then
                        echo "thing_id=$thing_id" >> temporary_configuration.txt
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
	create_thing
else
	# If yes, ask user whether he/she want to use existing thing or create a new one
	echo "There already a thing that matches with the configuration.txt file in the server."
	echo "Do you want to use the existing one or create a new thing?"
	select option in "Use existing one." "Create a new one." "quit"; do
		case $option in
			"Use existing one.") echo "You want to use existing one"
					     break;;
			"Create a new one.") create_thing
					     break;;
			quit) break;;
			*) echo "Undefined option.";;
		esac
	done
fi
