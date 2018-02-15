#!/usr/bin/python
from gpiozero import LightSensor # Use gpiozero library to read light
'''
Connect VCC pin of light sensor to 3.3V pin of Raspberry pi 3
Connect GND pin of light sensor to GND pin of Raspberry Pi 3
Connect OUT pin of light sensor to GPIO17 pin of Raspberry Pi 3
'''
ldr = LightSensor(17)
lightIntensity = round(ldr.value * 1023) # GPIO pin of Raspberry Pi 3 can read 1024 level of input so that measurement is scale to 1023 value
print lightIntensity
