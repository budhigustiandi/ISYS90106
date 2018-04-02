from gpiozero import LED
from time import sleep
red_led = LED(9)
green_led = LED(10)
blue_led = LED(11)
while True:
	red_led.off()
	green_led.on()
	blue_led.on()
