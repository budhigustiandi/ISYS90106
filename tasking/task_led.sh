#!/bin/bash

##############################################
# Configuration:                             #
# VCC pin is connected to pin #17 (3.3v)     #
# RED LED is connected to pin #21 (GPIO09)   #
# GREEN LED is connected to pin #19 (GPIO10) #
# BLUE LED is connected to pin #23 (GPIO11)  #
##############################################

# Exports GPIO pins to userspace
echo "9" > /sys/class/gpio/export
echo "10" >> /sys/class/gpio/export
echo "11" >> /sys/class/gpio/export

# Sets pin GPIO09, GPIO10, GPIO11 as outputs
echo "out" > /sys/class/gpio/gpio9/direction
echo "out" > /sys/class/gpio/gpio10/direction
echo "out" > /sys/class/gpio/gpio11/direction


function turn_on_red_LED {
	turn_off_all_LED
	# Sets pin GPIO09 to low
	echo "0" > /sys/class/gpio/gpio9/value
}
function turn_off_red_LED {
        # Sets pin GPIO09 to high
        echo "1" > /sys/class/gpio/gpio9/value
}
function turn_on_green_LED {
	turn_off_all_LED
        # Sets pin GPIO10 to low
        echo "0" > /sys/class/gpio/gpio10/value
}
function turn_off_green_LED {
        # Sets pin GPIO10 to low
        echo "1" > /sys/class/gpio/gpio10/value
}
function turn_on_blue_LED {
        turn_off_all_LED
	# Sets pin GPIO10 to low
        echo "0" > /sys/class/gpio/gpio11/value
}
function turn_off_blue_LED {
        # Sets pin GPIO10 to low
        echo "1" > /sys/class/gpio/gpio11/value
}
function turn_off_all_LED {
	turn_off_red_LED
	turn_off_green_LED
	turn_off_blue_LED
}

turn_off_all_LED
