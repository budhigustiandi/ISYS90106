#!/bin/bash

echo "##################################################"
echo "# RAspberry-based automaTIc for sensortHings API #"
echo "# Creator: Budhi Gustiandi                       #"
echo "##################################################"
echo ""

function select_prompt {
	echo "Please select an option:"
	echo "1) Run the thing.       3) Create a new thing."
	echo "2) Update the thing.    4) Quit."
	echo ""
}

thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
while [[ "$thing_id" == "" ]]; do
	echo "##########################################"
	echo "# Thing is not registered to the server. #"
	echo "# Registering the thing to the server... #"
	echo "##########################################"
	echo ""
	bash create_thing.sh
	bash create_update_location.sh
	bash create_datastream.sh
	thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
done

echo "############################################"
echo "# Thing has been registered to the server. #"
echo "############################################"
echo ""
echo "Please select an option:"
select option in "Run the thing." "Update the thing." "Create a new thing." "Quit."; do
	case $option in
		"Run the thing.")
			observation_interval=`cat configuration.txt | grep observation_interval | cut -d "=" -f 2`
			second=$observation_interval
			minute=0
			hour=0
			while (( $second >= 60 )); do
				(( observation_interval-=60 ))
				(( minute++ ))
			done
			while (( $minute >= 60 )); do
				(( minute-=60 ))
				(( hour++ ))
			done
			echo "Observation interval is set to $hour hour(s) $minute minute(s) $second second(s)."
			location_status=`cat configuration.txt | grep location_status | cut -d "=" -f 2`
			while [[ True ]]; do
				bash create_update_location.sh
				bash create_observation.sh
				sleep $observation_interval
			done
			break;;
		"Update the thing.")
			#bash update_thing.sh
			echo "###########################"
			echo "# Thing has been updated. #"
			echo "###########################"
			echo ""
			select_prompt;;
		"Create a new thing.")
			break;;
		"Quit.")
			echo "####################################"
			echo "# Thank you for using the program. #"
			echo "####################################"
			break;;
		*)
			echo "###################"
			echo "# Invalid option. #"
			echo "###################"
			echo ""
			select_prompt;;
	esac
done
			# "Create a new one.") echo "do you want to delete the exising thing?"
					     # select option_2 in "Yes" "No" "Quit"; do
					     	# case $option_2 in
							# "Yes") bash delete_thing.sh $thing_id
						       	       # bash create_thing.sh
							       # bash create_location.sh
							       # bash create_datastream.sh
						       	       # break;;
							# "No") thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
							      # echo "Previous Thing ID = $thing_id" >> log
							      # bash create_thing.sh
							      # bash create_location.sh
							      # bash create_datastream.sh
						              # break;;