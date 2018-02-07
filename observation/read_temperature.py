#!/usr/bin/python
import sys
import Adafruit_DHT # use Adafruit_DHT library to read temperature using DHT11 sensor
'''
Connect signal pin of DHT11 sensor to GPIO4 pin of Raspberry Pi 3
Connect VCC pin of DHT11 sensor to 5V pin of Raspberry Pi 3
Connect - pin of DHt11 sensor to GND pin of Raspberry Pi 3
'''
humidity, temperature = Adafruit_DHT.read_retry(11,4)
print '{0:0.1f}'.format(temperature, humidity) # Choose 0 if we want to read temperature or 1 if we want to read humidity
