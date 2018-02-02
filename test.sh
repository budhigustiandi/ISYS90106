#!/bin/bash
cat configuration.txt | grep thing_name | cut -d ":" -f 2
