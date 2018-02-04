#!/bin/bash

bash create_update_content.sh
content_placeholder=`cat content_placeholder`
rm content_placeholder
thing_url=`cat configuration.txt | grep thing_url | cut -d "=" -f 2`
thing_id=`cat configuration.txt | grep thing_id | cut -d "=" -f 2`
url="$thing_url($thing_id)"
curl -X PATCH -H "Content-Type: application/json" -d "$content_placeholder" "$url"
