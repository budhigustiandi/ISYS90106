#!/bin/bash

echo ""
echo "#######################################################"
echo "# RAspberry-based automaTIsation for sensortHings API #"
echo "# Creator: Budhi Gustiandi                            #"
echo "#######################################################"
echo ""

function main_menu_prompt {
	echo ""
	echo "Please select an option:"
	echo "1) Run the thing.       3) Create a new thing.      5) Reset datastream(s)."
	echo "2) Update the thing.    4) Update datastream(s).    6) Quit."
	echo ""
}
function sub_menu_prompt {
	echo ""
	echo "#############################################"
	echo "# Do you want to delete the existing thing? #"
	echo "# 1) Yes    2) No    3) Back to main menu   #"
	echo "#############################################"
	echo ""
}
function quit_prompt {
	echo ""
	echo "####################################"
	echo "# Thank you for using the program. #"
	echo "####################################"
	echo ""
}
function invalid_prompt {
	echo ""
	echo "###################"
	echo "# Invalid option. #"
	echo "###################"
	echo ""
}
function create_new_thing {
	bash create_thing.sh
	location_name=`cat configuration.txt | grep location_name | cut -d "=" -f 2`
        location_description=`cat configuration.txt | grep location_description | cut -d "=" -f 2`
        location_longitude=`cat configuration.txt | grep location_longitude | cut -d "=" -f 2`
        location_latitude=`cat configuration.txt | grep location_latitude | cut -d "=" -f 2`
        if [[ "$location_name" != "" && "$location_description" != "" && "$location_longitude" != "" && "$location_latitude" != "" ]]; then
                bash create_update_location.sh
        fi
	bash create_datastream.sh
	bash create_visualisation.sh
}

thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
while [[ "$thing_id" == "" ]]; do
	echo ""
	echo "##########################################"
	echo "# Thing is not registered to the server. #"
	echo "# Registering the thing to the server... #"
	echo "##########################################"
	echo ""
	create_new_thing
	thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
done

echo ""
echo "############################################"
echo "# Thing has been registered to the server. #"
echo "############################################"
echo ""
echo "Please select an option:"
select main_menu in "Run the thing." "Update the thing." "Create a new thing." "Update datastream(s)." "Reset datastream(s)." "Quit."; do
	case $main_menu in
		"Run the thing.")
			echo "Start observation..."
			observation_interval=`cat configuration.txt | grep observation_interval | cut -d "=" -f 2`
			second=$observation_interval
			minute=0
			hour=0
			while (( $second >= 60 )); do
				(( second-=60 ))
				(( minute++ ))
			done
			while (( $minute >= 60 )); do
				(( minute-=60 ))
				(( hour++ ))
			done
			echo "Observation interval is set to $hour hour(s) $minute minute(s) $second second(s)."
			location_status=`cat configuration.txt | grep location_status | cut -d "=" -f 2`
			while [[ True ]]; do
				bash sync_configuration.sh
				bash create_update_location.sh
				bash create_observation.sh
				sleep $observation_interval
			done
			break;;
		"Update the thing.")
			bash update_thing.sh
			bash create_visualisation.sh
			main_menu_prompt;;
		"Create a new thing.")
			echo ""
			echo "#############################################"
			echo "# Do you want to delete the existing thing? #"
			echo "#############################################"
			echo ""
			select sub_menu in "Yes" "No" "Back to main menu"; do
				case $sub_menu in
					"Yes")
						bash delete_thing.sh
						echo ""
						echo "###################################"
						echo "# Existing thing has been deleted #"
						echo "###################################"
						echo ""
						create_new_thing
						echo ""
						echo "##############################"
						echo "# New thing has been created #"
						echo "##############################"
						echo ""
						break;;
					"No")
						thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
						echo "Previous thing ID is $thing_id" >> historical_thing.data
						create_new_thing
						break;;
					"Back to main menu")
						break;;
					*)	invalid_prompt
						sub_menu_prompt;;
				esac
			done
			main_menu_prompt;;
		"Update datastream(s).")
			bash update_datastream.sh
			bash create_visualisation.sh
			main_menu_prompt;;
		"Reset datastream(s).")
			bash delete_datastream.sh
			bash create_datastream.sh
			bash create_visualisation.sh
			main_menu_prompt;;
		"Quit.")
			quit_prompt
			break;;
		*)	invalid_prompt
			main_menu_prompt;;
	esac
done
