#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/pi
influxUsername=
influxPw=

declare -a inputValues
declare -a inputValues
declare -a outputValuesDigital
declare -a networkAnalog
declare -a networkDigital
#wget --user= --password= 'http://cmiIP/INCLUDE/api.cgi?jsonnode=1&jsonparam=I,O,Na,Nd' -O /home/pi/cmi.json
curl -o /home/pi/cmi.json -u login:pw 'http://cmiIP/INCLUDE/api.cgi?jsonnode=1&jsonparam=I,O,Na,Nd'
for i in {0..15}
	do
		inputValues[$i+1]=$( cat /home/pi/cmi.json | jq '.Data.Inputs['$i'].Value["Value"]' )
	done
for i in {0..15}
	do
		outputValuesAnalog[$i+1]=$( cat /home/pi/cmi.json | jq '.Data.Outputs['$i'].Value["Value"]' )
	done
for i in {0..15}
	do
		outputValuesDigital[$i+1]=$( cat /home/pi/cmi.json | jq '.Data.Outputs['$i'].Value["State"]' )
	done
for i in {0..15}
	do
		networkAnalog[$i+1]=$( cat /home/pi/cmi.json | jq '.Data."Network Analog"['$i'].Value["Value"]' )
	done
for i in {0..15}
	do
		networkDigital[$i+1]=$( cat /home/pi/cmi.json | jq '.Data."Network Digital"['$i'].Value["Value"]' )
	done


i=0
for f in "${inputValues[@]}"; do	
	if [ "$f" != "null" ]; then
		inputValuesString=""
		inputValuesString+="inputValues,"
		inputValuesString+="nr="
		inputValuesString+=$i
		inputValuesString+=" "
		inputValuesString+="value="			
		inputValuesString+=$f				
		curl -i -XPOST -u $influxUsername:$influxPw 'http://localhost:8086/write?db=cmi' --data-binary "${inputValuesString}"		
	fi 
		i=$(( i + 1 ))
done

i=0
for f in "${outputValuesAnalog[@]}"; do	
	if [ "$f" != "null" ]; then
		outputValuesAnalogString=""
		outputValuesAnalogString+="outputValuesAnalog,"
		outputValuesAnalogString+="nr="
		outputValuesAnalogString+=$i
		outputValuesAnalogString+=" "
		outputValuesAnalogString+="value="
		outputValuesAnalogString+=$f		
		curl -i -XPOST -u $influxUsername:$influxPw 'http://localhost:8086/write?db=cmi' --data-binary "${outputValuesAnalogString}"
	fi 	
		i=$(( i + 1 ))
done
i=0

for f in "${outputValuesDigital[@]}"; do
	if [ "$f" != "null" ]; then	
		outputValuesDigitalString=""
		outputValuesDigitalString+="outputValuesDigital,"
		outputValuesDigitalString+="nr="
		outputValuesDigitalString+=$i
		outputValuesDigitalString+=" "
		outputValuesDigitalString+="value="
		outputValuesDigitalString+=$f			
		curl -i -XPOST -u $influxUsername:$influxPw 'http://localhost:8086/write?db=cmi' --data-binary "${outputValuesDigitalString}"
	fi 
	i=$(( i + 1 ))	
done
	i=0
for f in "${networkAnalog[@]}"; do	
	if [ "$f" != "null" ]; then	
		networkAnalogString=""
		networkAnalogString+="networkAnalog,"
		networkAnalogString+="nr="
		networkAnalogString+=$i
		networkAnalogString+=" "
		networkAnalogString+="value="
		networkAnalogString+=$f			
		curl -i -XPOST -u $influxUsername:$influxPw 'http://localhost:8086/write?db=cmi' --data-binary "${networkAnalogString}"
	fi	
	i=$(( i + 1 ))
done
	for f in "${networkDigital[@]}"; do	
	if [ "$f" != "null" ]; then	
		networkDigitalString=""
		networkDigitalString+="networkDigital,"
		networkDigitalString+="nr="
		networkDigitalString+=$i
		networkDigitalString+=" "
		networkDigitalString+="value="	
		networkDigitalString+=$f			
		curl -i -XPOST -u $influxUsername:$influxPw 'http://localhost:8086/write?db=cmi' --data-binary "${networkDigitalString}"
		i=$(( i + 1 ))
	fi
done
