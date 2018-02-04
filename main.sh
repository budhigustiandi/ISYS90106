#!/bin/bash

# Search whether the thing is already exist in the server based on the thing_id existence
# If not, create a new thing.

thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
if [[ "$thing_id" == "" ]]; then
	echo "No thing exist, a new thing will be created."
	#bash create_thing.sh
	bash retrieve_thing.sh
else
	# If yes, ask user whether he/she want to use existing thing or create a new one
	echo "There already a thing that matches with the configuration.txt file in the server."
	echo "Do you want to use the existing one, update it, or create a new thing?"
	select option in "Use existing one." "Update existing one." "Create a new one." "quit"; do
		case $option in
			"Use existing one.") echo "You want to use existing one"
					     break;;
			"Update existing one.") #bash update_thing.sh
						break;;
			"Create a new one.") #bash create_thing.sh
					     bash retrieve_thing.sh
					     break;;
			quit) break;;
			*) echo "Undefined option.";;
		esac
	done
fi
