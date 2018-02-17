#!/bin/bash

base_url=`cat configuration.txt | grep base_url | cut -d "=" -f 2`

echo "#########################"
echo "# Create a new thing... #"
echo "#########################"
echo ""
bash read_thing.sh
thing=`cat thing`
rm thing
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
# thing_url variable have to be used to parse "$filter" in the query
thing_url="$base_url/Things?\$filter=name%20eq%20%27$thing_name%27"
thing_id=`curl -X GET -H "Content-Type: application/json" "$thing_url" | cut -d ":" -f 4 | cut -d "," -f 1`
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
