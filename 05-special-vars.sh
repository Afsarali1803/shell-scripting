#!/bin/bash 

### Special Variables in Linux are : $0 to $n , $* , $@ , $# , $$ 

echo "Name of the executed script is: $0"       # Prints the script name that you're running
echo "First Argument from command line: $1"
echo "Second Argument from command line: $2"

# On command you can supply 9 variables 
# Ex  
#  sh abc.sh 10 20 30 40