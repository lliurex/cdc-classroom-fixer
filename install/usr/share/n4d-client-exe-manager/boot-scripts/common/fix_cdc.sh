#!/bin/bash

CDC=$(dpkg-query -W -f'${Version}' cdc)
CDC_CLIENTS=$(dpkg-query -W -f'${Version}' cdc-for-clients)

SOURCE_LIST="deb http://lliurex.net/jammy jammy-updates main"


RC=0

dpkg --compare-versions $CDC lt 0.34.1 || RC=1
dpkg --compare-versions $CDC_CLIENTS lt 0.34.1 || RC=1

if [ $RC = 0 ]; then

	echo $SOURCE_LIST > /tmp/fix_cdc.sources.list
	
	apt update -o Dir::Etc::SourceList=/tmp/sources.list.temporal -o Dir::Etc::SourceParts=/dev/null
	apt install 
	apt -o Dir::Etc::SourceList="/tmp/fix_cdc.sources.list" -o Dir::Etc::SourceParts="-" update
	systemd-run --scope --slice=backgroud.slice apt -o Dir::Etc::SourceList="/tmp/fix_cdc.sources.list" -o Dir::Etc::SourceParts="-" install cdc cdc-for-clients


fi



