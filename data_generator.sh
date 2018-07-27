#!/bin/bash
######################################################## 
# data_generator
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

job_etl=./seq_hello_etl_data_permutation*.zip

#Output swapped file path
data_swap=./data_swap

work_tmp=./work_tmp

########################################################
#log function
log()
{
	
url_bot_slack=https://hooks.slack.com/services/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

case $LOG_LEVEL in

1)	echo -e "\033[1;31mlog("$LOG_LEVEL", \"This is a fatal error\")\n["$(date +"%F %T")"] [FATAL] This is a fatal error\033[0m"

	message="log("$LOG_LEVEL', \"This is a fatal error\")\n['$(date +"%F %T")"] [FATAL] This is a fatal error"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

2)	echo -e "\033[1;31mlog("$LOG_LEVEL", \"This is an error\")\n["$(date +"%F %T")"] [ERROR] This is an error\033[0m"

	message="log("$LOG_LEVEL', \"This is an error\")\n['$(date +"%F %T")"] [ERROR] This is an error"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

3)	echo -e "\033[1;33mlog("$LOG_LEVEL", \"This is a warning\")\n["$(date +"%F %T")"] [WARN] This is a warning\033[0m"

	message="log("$LOG_LEVEL', \"This is a warning\")\n['$(date +"%F %T")"] [WARN] This is a warning"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

4)	echo -e "\033[1;32mlog("$LOG_LEVEL", \"This is an information\")\n["$(date +"%F %T")"] [INFO] This is an information\033[0m"

	message="log("$LOG_LEVEL', \"This is an information\")\n['$(date +"%F %T")"] [INFO] This is an information"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

5)	echo -e "\033[1;35mlog("$LOG_LEVEL", \"This is a debug\")\n["$(date +"%F %T")"] [DEBUG] This is a debug\033[0m"

	message="log("$LOG_LEVEL', \"This is a debug\")\n['$(date +"%F %T")"] [DEBUG] This is a debug"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

6)	echo -e "\033[1;36mlog("$LOG_LEVEL", \"This is a trace\")\n["$(date +"%F %T")"] [TRACE] This is a trace\033[0m"

	message="log("$LOG_LEVEL', \"This is a trace\")\n['$(date +"%F %T")"] [TRACE] This is a trace"
	curl -s -X POST --data-urlencode "payload={\"text\": \"$message\"}" $url_bot_slack >/dev/null
	;;

esac

}

########################################################
#Call log function
log

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
while 	(( $line_size <= $line_max )); do

	line_size=$(cat $data_out | wc -l)						#calculate the number of lines in the output file

	word=""
	word_size=$(( $RANDOM % $word_size_max + 1))					#random calculation of the word size
	
	while (( ${#word} <= $word_size )); do

		word=$word${hex_char:(($RANDOM % 16)):1} 				#random calculation of a hexadecimal value 
	done										#between 0 and F and concatenation to the word

	echo $line_size";"$word >> $data_out						#writing the data line in the output file
done

########################################################
#Call of seq_hello_etl_data_permutation_x_x.jar for 
#switch columns line_number and data

if [ -e $job_etl ]; then								#Job etl exist ?

	mkdir $work_tmp									#Creation of a working directory

	unzip $job_etl -d $work_tmp >/dev/null

	properties_path=$(unzip -l $job_etl | grep  "/contexts/Default.properties")	#Define properties path in zip
	properties_path=${properties_path##* }

	echo -e "#this is context properties\n#" > $work_tmp/$properties_path		#Change properties file
	echo "file_in="$(pwd)/${data_out##*/} >> $work_tmp/$properties_path
	echo "file_out="$(pwd)/${data_swap##*/} >> $work_tmp/$properties_path	

	name_job=${job_etl##*/}								
	name_job=${name_job%%\**}	
	chmod +x $work_tmp/$name_job/$name_job"_run.sh"
	$work_tmp/$name_job/$name_job"_run.sh"						#Execute the JOB script

	rm -R $work_tmp

fi
########################################################
#Call log function
log

#EOF