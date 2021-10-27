#!/bin/bash
# This script performs a pg_dump, saving the file the specified dir.
# The first arg ($1) is the database user to connect with.
# The second arg ($2) is the database to backup and is included in the file name.
# $(date +"%Y_%m_%d") includes the current system date into the actual file name.

dirBackups=~/backups

if [ -n "$1" ]; then # If first parameter passed

	if [ "$(ls ~/backups)" ]
	then
		echo -e "\n---------- Espacio file system backups ----------"
		fileSystemBackups=$(df -T ~/backups)
		echo "$fileSystemBackups"

		ultimoBackup=$(find ~/backups/ -name "*$1*" -type f -mtime -9 | tail -1)

		if [ "$ultimoBackup" ]
		then
			tamanoUltimoBck=$(du -sh $ultimoBackup)
			echo -e "\nTamaño del ultimo backup de $1: $tamanoUltimoBck\n"
		else
			echo -e "\nNo existe ningun backup de $1\n"
		fi
	else	

		echo "El directorio de backups está vacio"

	fi

	FICHERO=~/backups/$nombreBackup	
	cd ~/backups

else

	echo -e '\nSe debe especificar la BBDD\n'

fi
