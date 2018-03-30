#!/bin/bash

base_url=https://scratchpad.sensorup.com/OGCSensorThings/v1.0
thing_id=1913825

# Create a thing entity
#thing='{"name":"Project RATIH - Tasking Capability",
#        "description":"Virtual thing to test tasking capability for Project RATIH"}'
# Register the thing to the server
#curl -XPOST -H "Content-type: application/json" -d "$thing" "$base_url/Things"

# Create location entity
#location='{"name": "Virtual Location",
#           "description": "Internet-based Location",
#           "encodingType": "application/vnd.geo+json",
#           "location": {"type": "Point",
#                        "coordinates": [0, 0]
#                       }
#          }'
#curl -XPOST -H "Content-type: application/json" -d "$location" "$base_url/Things($thing_id)/Locations"

# Create a datastream and associated entities
datastream='{"name": "Buzzer Status",
             "description": "Tasking Capability to sound or mute a buzzer",
             "observationType": "Actuator",
             "unitOfMeasurement": {
             	"name": "Status",
             	"definition": "Specifies to turn the buzzer on or off",
                "symbol": "On | Off"
             }}'
#             "Thing":{"@iot.id":'$thing_id'},
#             "ObservedProperty": {
#             	"name": "none",
#                "description": "none",
#                "definition": "none"
#             },"Sensor": {
#             	"name": "Duinotech Buzzer",
#                "description": "A varian of buzzer that is usually used in Arduino or Raspberry",
#                "encodingType": "application/pdf",
#                "metadata": "https://www.jaycar.com.au/medias/sys_master/images/8922936410142/XC4288-manualMain.pdf"
#             }}'
# Register the datastream and associated entities to the server and associate them with the thing that has been registered in the server
curl -X PATCH -H "Content-Type: application/json" -d "$datastream" "$base_url/Datastreams(1914024)"

# Create an observation
time=`date +"%Y-%m-%dT%H:%M:%S.000Z"`
observation_result=Off
curl -X PATCH -H "Content-Type: application/json" -d "{
\"phenomenonTime\": \"$time\",
\"resultTime\": \"$time\",
\"result\": \"$observation_result\",
\"Datastream\":{\"@iot.id\":1914024}
}" "https://scratchpad.sensorup.com/OGCSensorThings/v1.0/Observations(1914327)"
