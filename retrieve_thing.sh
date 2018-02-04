#!/bin/bash

############
# FUNCTION #
############

function update_thing_id {
	while read configuration_line; do
		echo $configuration_line | grep thing_id
		if [[ $? -eq 0 ]]; then
			echo "thing_id=$thing_id" >> temporary_configuration.txt
		else
			echo $configuration_line >> temporary_configuration.txt
		fi
	done < configuration.txt
        mv temporary_configuration.txt configuration.txt
}

########
# MAIN #
########

thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2 | sed 's/ /%20/g'`
thing_url=`cat configuration.txt | grep thing_url | cut -d "=" -f 2`
additional_query="?\$filter=name%20eq%20%27$thing_name%27"
url="$thing_url$additional_query"
curl -X GET -H "Content-Type: application/json" "$url" | cut -d ":" -f 4 | cut -d "," -f 1 > thing_id
thing_id=`cat thing_id`
rm thing_id
# Update the thing_id in the configuration.txt file
update_thing_id
