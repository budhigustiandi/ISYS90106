#!/bin/bash

# Set the baud rate for serial 0 port to 9600
#stty -F /dev/serial0 9600

# Read line by line the input from serial port 0
while read -r  line < /dev/serial0; do

	# Find line with $GPGGA information
	echo $line | grep GPGGA

	# If the line is found, extract the longitude and latitude information, convert to standard longitude and latitude
	if [[ $? -eq 0 ]]; then
		longitude_raw=`echo $line | cut -d "," -f 5`
		latitude_raw=`echo $line | cut -d "," -f 3`

		longitude_degree=${longitude_raw:0:3}

		# Delete leading zero number in the longitude degree
		if [[ "${longitude_degree:0:1}" == "0" ]]; then
			longitude_degree=${longitude_degree:1:2}
			if [[ "${longitude_degree:0:1}" == "0" ]]; then
				longitude_degree=${longitude_degree:1:1}
				if [[ "${longitude_degree:0:1}" == "0" ]]; then
					longitude_degree=0
				fi
			fi
		fi
		longitude_minute=`echo ${longitude_raw:3:8}/60 | bc -l`
		longitude=$longitude_degree$longitude_minute
		longitude=${longitude:0:9}
		longitude_position=`echo $line | cut -d "," -f 6`
		if [[ "$longitude_position" == "W" ]]; then
			longitude=-$longitude
		fi

		latitude_degree=${latitude_raw:0:2}

		# Delete leading zero number in the latitude degree
		if [[ "${latitude_degree:0:1}" == "0" ]]; then
			latitude_degree=${latitude_degree:1:1}
			if [[ "${latitude_degree:0:1}" == "0" ]]; then
				latitude_degree=0
			fi
		fi
		latitude_minute=`echo ${latitude_raw:2:8}/60 | bc -l`
		latitude=$latitude_degree$latitude_minute
		latitude=${latitude:0:8}
		latitude_position=`echo $line | cut -d "," -f 4`
		if [[ "$latitude_position" == "S" ]]; then
			latitude=-$latitude
		fi

		# Update the longitude and latitude information in the configuration.txt file
		while read configuration; do
			echo $configuration | grep location_longitude
			if [[ $? -eq 0 ]]; then
				echo "location_longitude=$longitude" >> temporary_configuration.txt
			elif [[ $? -eq 1 ]]; then
				echo $configuration | grep location_latitude
					if [[ $? -eq 0 ]]; then
						echo "location_latitude=$latitude" >> temporary_configuration.txt
					else
						echo $configuration >> temporary_configuration.txt
					fi
		fi
		done < configuration.txt
		mv temporary_configuration.txt configuration.txt
		chmod 666 configuration.txt
		chown pi:pi configuration.txt
		break
	fi
done
