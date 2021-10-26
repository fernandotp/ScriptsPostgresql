#!/bin/bash
# This script performs a pg_dump, saving the file the specified dir.
# The first arg ($1) is the database user to connect with.
# The second arg ($2) is the database to backup and is included in the file name.
# $(date +"%Y_%m_%d") includes the current system date into the actual file name.


if [ -n "$1" ]; then # If first parameter passed

	echo -e "\nRealizando backup de $1..."
	today=`date '+%Y_%m_%d__%H_%M_%S'`;
	nombreBackup="backup_postgresql_$1_`date '+%Y-%m-%d_%H:%M:%S'`.sql"

	if [ "$(ls ~/backups)" ]
	then
	
		echo -e '\nTamaño backup anterior:'
		ultimoBackup=$(ls ~/bakups | grep $1 | find ~/backups/ -type f -mtime -5 | tail -1)
		du -sh $ultimoBackup
		#psql -U $1 -d $2 -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS SIZE FROM pg_database WHERE pg_database.datname='$2';"
	fi

	pg_dumpall -U $1 > ~/backups/$nombreBackup

	FICHERO=~/backups/$nombreBackup	
	cd ~/backups

	if [ -f $nombreBackup ]
	then
		echo -e '\nTamaño nuevo backup:'
		du -sh  ~/backups/$nombreBackup
		echo ''
   		
	else
   		echo -e "\nError. No se pudo realizar el bakup de $1\n"
	fi

else

	echo -e '\nSe debe especificar la BBDD\n'

fi
