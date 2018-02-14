#!/bin/bash

while read -r  line < /dev/serial0; do
	echo $line | grep GPGGA
	if [[ $? -eq 0 ]]; then
		echo $line > gps_log.dat
	fi
done
