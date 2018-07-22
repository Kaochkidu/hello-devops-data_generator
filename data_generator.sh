#!/bin/bash
######################################################## 
# Data_generator
#
# Utility script to generate hexadecimal random data.
#
# Write by Kaochkidu.
#
########################################################
#Configuration variables

#Output file path
data_out=./data_out

#Max size of hexadecimal words
word_size_max=32

#Number of lines of data
line_max=10

########################################################
#log function
log()
{
LOG_LEVEL=$1
	
case $LOG_LEVEL in

1)	echo -e "\033[1;31mlog("$LOG_LEVEL", \"This is a fatal error\")\n["$(date +"%F %T")"] [FATAL] This is a fatal error\033[0m"
	;;

2)	echo -e "\033[1;31mlog("$LOG_LEVEL", \"This is an error\")\n["$(date +"%F %T")"] [ERROR] This is an error\033[0m"
	;;

3)	echo -e "\033[1;33mlog("$LOG_LEVEL", \"This is a warning\")\n["$(date +"%F %T")"] [WARN] This is a warning\033[0m"
	;;

4)	echo -e "\033[1;32mlog("$LOG_LEVEL", \"This is an information\")\n["$(date +"%F %T")"] [INFO] This is an information\033[0m"
	;;

5)	echo -e "\033[1;35mlog("$LOG_LEVEL", \"This is a debug\")\n["$(date +"%F %T")"] [DEBUG] This is a debug\033[0m"
	;;

6)	echo -e "\033[1;36mlog("$LOG_LEVEL", \"This is a trace\")\n["$(date +"%F %T")"] [TRACE] This is a trace\033[0m"
	;;

esac

}

########################################################
#Call log function with info
log 4

########################################################
#Generate data_out file

#-------------------------------------------------------
#Initialization of the variables

#Initialize the line counter to 0
line_size=0

#String of characters for hexadecimal conversion
hex_char=0123456789ABCDEF

#-------------------------------------------------------
#Header generation
echo "line_number;data" > $data_out

#-------------------------------------------------------	
#Data generation
while (( $line_size < $line_max )); do

	line_size=$(cat $data_out | wc -l)			#calculate the number of lines in the output file

	word=""
	word_size=$(( $RANDOM % $word_size_max + 1))		#random calculation of the word size
	
	while (( ${#word} <= $word_size )); do

		word=$word${hex_char:(($RANDOM % 16)):1} 	#random calculation of a hexadecimal value between 0 and F and concatenation to the word
	done

	echo $line_size";"$word >> $data_out			#writing the data line in the output file
done

########################################################
#Call log function with trace
log 6

#EOF