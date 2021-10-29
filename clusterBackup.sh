#!/bin/bash
# This script performs a pg_dump, saving the file the specified dir.
# The first arg ($1) is the database user to connect with.
# The second arg ($2) is the database to backup and is included in the file name.
# $(date +"%Y_%m_%d") includes the current system date into the actual file name.

dirBackups=~/backups

if [[ (-n "$1") && (-n "$2")]];
 then # If first parameter passed
	echo -e "\nRealizando backup de $2..."
	today=`date '+%Y_%m_%d__%H_%M_%S'`;
	nombreBackup="backup_postgresql_$2_`date '+%Y-%m-%d_%H:%M:%S'`.sql"
	
	#echo -e "\n---------- Espacio file system backups ----------"
	#fileSystemBackups=$(df -T ~/backups)
	#echo -e "$fileSystemBackups"

		#------------REALIZAR BACKUP--------------		
	
	pg_dump -U $1 $2 > ~/backups/$nombreBackup

	FICHERO=~/backups/$nombreBackup	
	cd ~/backups

	if [ -f $nombreBackup ]
	then
		if [ "$(ls $dirBackups)" ]
		then

			ultimoBackup=$(find ~/backups/ -name "*_$2_*" -type f -mtime -9 | tail -1)

			if [ "$ultimoBackup" ]
			then
				tamanoUltimoBck=$(du -sh $ultimoBackup)
				echo -e "\nTamaño del ultimo backup de $2: $tamanoUltimoBck\n"
			fi	
			
		fi

		echo -e "\nTamaño del nuevo backup:"
		du -sh  $dirBackups/$nombreBackup
		echo ""
   		
	else
 		echo -e "\nERROR. No se pudo realizar el bakup de $2\n"
	fi

	#psql -U $1 -d $2 -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS SIZE FROM pg_database WHERE pg_database.datname='$2';"

	#pg_dumpall -U $1 > ~/backups/$nombreBackup

else

	echo -e "\nSe debe especificar el usuario y la base de datos específica.\nFormato: ./backupBBDD.sh -'usuario de Postgresql' -'Base de datos'\n"

fi
