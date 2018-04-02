#!/usr/bin/python
from gpiozero import Buzzer
from time import sleep
'''
Connect ground pin of buzzer to GND pin of Raspberry Pi 3
Connect SGN pin of buzzer to GP18 pin of Raspberry Pi 3
'''
buzzer = Buzzer(18)
time = 10
while (time > 0):
	buzzer.on()
	time--
