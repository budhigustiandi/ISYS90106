#!/bin/bash

# Search whether the thing is already exist in the server based on the thing_id existence
# If not, create a new thing.

thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
if [[ "$thing_id" == "" ]]; then
	echo "No thing exist, a new thing will be created."
	bash create_thing.sh
	bash create_location.sh
else
	echo "There already a thing that matches with the configuration.txt file in the server."
	echo "Do you want to use the existing one, update it, or create a new thing?"
	select option in "Use existing one." "Update existing one." "Create a new one." "Quit"; do
		case $option in
			"Use existing one.") bash run_observation.sh
					     break;;
			"Update existing one.") bash update_thing.sh
						bash run_observation.sh
						break;;
			"Create a new one.") echo "do you want to delete the exising thing?"
					     select option_2 in "Yes" "No" "Quit"; do
					     	case $option_2 in
							"Yes") bash delete_thing.sh $thing_id
						       	       bash create_thing.sh
							       bash create_location.sh
							       bash create_datastream.sh
							       bash run-observation.sh
						       	       break;;
							"No") thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
							      echo "Previous Thing ID = $thing_id" >> log
							      bash create_thing.sh
							      bash create_location.sh
							      bash create_datastream.sh
							      bash run_observation.sh
						              break;;
							"Quit") break;;
							*) echo "Undefined option.";;
					     	esac
					     done
					     break;;
			"Quit") break;;
			*) echo "Undefined option.";;
		esac
	done
fi
# Run the program normally...
