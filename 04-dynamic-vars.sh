#!/bin/bash 

TODAY_DATE="$(date +%F)"
NO_OF_USERS="$(who | wc -l)"

echo "Good Morning, Todays date is ${TODAY_DATE}"

