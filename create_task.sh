#!/bin/bash

# Find the number of tasking capability available in the tasking directory

tasking_capability_count=`ls tasking | wc -l`

# Iterate through each tasking capability and execute

for (( i=1; i<=$tasking_capability_count; i++ )); do
	tasking_capability=`ls tasking | head -i | tail -1`
	
	# Conditional flow for python and bash script type of tasking capability
	tasking_capability_extention=`echo $tasking_capability | cut -d "." -f 2`
	if [[ "$tasking_capability_extention" == "py" ]]; then
		sudo python tasking/$tasking_capability
	elif [[ "$tasking_capability_extention" = "sh" ]]; then
		sudo bash tasking/$tasking_capability
	fi
done