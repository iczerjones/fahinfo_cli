#!/bin/bash
# Provides feedback on latest log events, estimated points, and CPU usage

# ------- SET THIS LOCATION --------------#
# Set this to your fahclient log root location
# Script will append /logs where required
# update_frequency is time in seconds

logroot='/var/lib/fahclient'
update_frequency=2


## ---- Functions ----- ##
fahcpu(){
	echo "---------------------------------------------------------"
	cat /proc/cpuinfo | grep -i mhz
	echo "---------------------------------------------------------"
}

fahlog(){
	printf "\n\n"; echo "   FAHClient logs"
	echo "---------------------------------------------------------"
	cat ${logroot}/log.txt | tail -n 8
	echo ""
}

model(){
	cat /proc/cpuinfo | grep -m 1 name | awk -F ':' '{print $2}'
}

points(){
	unset tally
	allpoints=()
	logs=(`find ${logroot}/logs -type f -iname *.log` ${logroot}/log.txt)
	for i in ${logs[@]}; do
		allpoints+=(`process $i`)
	done
	numpoints=$(echo ${#allpoints[@]})
	for i in $(seq 0 $((numpoints-1))); do
		if [[ ${allpoints[i]} == 0 ]]; then
			unset allpoints[i] &>/dev/null
		fi
	done
	if [ $numpoints -eq 1 ]; then
		tally=${allpoints[0]}
	else
		tally=0
		for i in $(seq 0 $((numpoints-1))); do
			tally=$((tally + allpoints[i]))
		done
	fi
	unset numpoints; unset allpoints; unset logs
	temp=$(sensors | grep Physical | awk '{print $4}')
	echo "CPU aggregate temperature: $temp"; unset temp
	echo "Total points earned: $tally"
}

process(){
	cat $1 | grep points | awk '{print $4}' | sed 's/\..*//'
}

## ------ Main loop ------ ##
while true; do
	fahlog; fahlogvar=$?
	model; modelvar=$fahlogvar$?
	fahcpu; fahcpuvar=$modelvar$?
	points; pointvar=$fahcpuvar$?
	fahoutput=${pointvar::-4}
	echo $fahoutput; echo "Press CTRL+C to exit"
	sleep $update_frequency; clear
done

