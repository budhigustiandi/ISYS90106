#!/bin/bash

datastream_id=1653970
echo '<div id="room_temperature"></div>
		<script>
			stachart.generateChart({
				'"'"'targetId'"'"': '"'"'room_temperature'"'"',
			    '"'"'staBaseUrl'"'"': '"'"'http://scratchpad.sensorup.com/OGCSensorThings/v1.0'"'"',
			    '"'"'datastreamId'"'"': '"'"''$datastream_id''"'"'
			});
		 </script>'