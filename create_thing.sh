#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`

echo "#########################"
echo "# Create a new thing... #"
echo "#########################"
echo ""

# Get mandatory property(ies) from the configuration.txt file

thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2`
echo "Thing's name is $thing_name."
thing_description=`cat configuration.txt | grep thing_description | cut -d "=" -f 2`
echo "Thing's description is $thing_description."
thing='"name": "'$thing_name'",
      "description": "'$thing_description'"'

# Get optional property(ies) from the configuration.txt file

number_of_optional_property=`cat configuration.txt | grep ^property_name | wc -l`
if [[ $number_of_optional_property -gt 0 ]]; then
	if [[ $number_of_optional_property -eq 1 ]]; then
		echo "There is 1 optional property."
	else
		echo "There are $number_of_optional_property optional properties."
	fi
	optional_content='"properties": {'
	for (( i=1; i<=$number_of_optional_property; i++ )); do
		property_name=`cat configuration.txt | grep ^property_name | head -$i | tail -1 | cut -d "=" -f 2`
		echo "Optional property name $i is $property_name."
		property_description=`cat configuration.txt | grep ^property_description | head -$i | tail -1 | cut -d "=" -f 2`
		echo "Optional property description $i is $property_description."
		optional_content=$optional_content'"'$property_name'": "'$property_description'"'
		if (( i<$number_of_optional_property )); then
			echo ","
		fi
	done
	optional_content=$optional_content}
	thing="$thing, $optional_content"
fi

curl -XPOST -H "Content-type: application/json" -d "$thing" "$base_url/Things"

echo ""
echo "#############################"
echo "# A thing has been created. #"
echo "#############################"
echo ""
echo "######################################"
echo "# Updating configuration.txt file... #"
echo "######################################"
echo ""

# Get thing ID from the server based on the thing name

thing_name=`cat configuration.txt | grep thing_name | cut -d "=" -f 2 | sed 's/ /%20/g'`
thing_id=`curl -X GET -H "Content-Type: application/json" "$base_url/Things?\$filter=name%20eq%20%27$thing_name%27" | cut -d ":" -f 4 | cut -d "," -f 1`

# Update the configuration.txt file

while read line; do
	echo $line | grep thing_id
	if [[ $? -eq 0 ]]; then
		echo "thing_id=$thing_id" >> temporary_configuration.txt
	else
		echo $line >> temporary_configuration.txt
	fi
done < configuration.txt
mv temporary_configuration.txt configuration.txt

# Set back configuration.txt file so that it can be modified by pi user

chmod 666 configuration.txt
chown pi:pi configuration.txt

echo "############################################"
echo "# configuration.txt file has been updated. #"
echo "############################################"
echo ""