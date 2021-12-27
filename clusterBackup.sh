#!/bin/bash
# This script performs a pg_dumpall, saving the file the specified dir.
# The first arg ($1) is the database user to connect with.
# $(date +"%Y_%m_%d") includes the current system date into the actual file name.

dirBackups=/home/fernando/clusterBackups

if [ -n "$1" ];
then # If first parameter passed
	echo -e "\nRealizando backup de $1..."
	today=`date '+%Y_%m_%d__%H_%M_%S'`;
	nombreBackup="backup_postgresql_$1Cluster_`date '+%Y-%m-%d_%H:%M:%S'`.sql"
	
	#echo -e "\n---------- Espacio file system backups ----------"
	#fileSystemBackups=$(df -T ~/backups)
	#echo -e "$fileSystemBackups"

		#------------REALIZAR BACKUP--------------		
	
	ultimoBackup=$(find $dirBackups -name "*_$1Cluster_*" -type f -mtime -9 | tail -1)
	tamanoUltimoBck=$(du -sh $ultimoBackup)
	pg_dumpall -U $1 > $dirBackups/$nombreBackup
	tamanoNuevoBck=$(du -sh  $dirBackups/$nombreBackup)	
	bckVacio=${tamanoNuevoBck:0:1}
	
	if [ $bckVacio -eq 0 ]
	then
		echo -e "\nError. No se pudo realizar el backup de $1\n"
		rm $dirBackups/$nombreBackup	
	else
		FICHERO=$dirBackups/$nombreBackup	
		cd $dirBakups

		if [ -f $dirBackups/$nombreBackup ]
		then
			if [ "$(ls $dirBackups)" ]
			then
				if [ "$ultimoBackup" ]
				then
					echo -e "\nTamaño del ultimo backup de $1: $tamanoUltimoBck\n"
				fi				
			fi
			echo -e "\nTamaño del nuevo backup de $1: $tamanoNuevoBck"
			echo ""
			df -h $dirBackups
			echo ""
		else
 			echo -e "\nERROR. No se pudo realizar el backup de $1\n"
		fi

		#psql -U $1 -d $2 -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS SIZE FROM pg_database WHERE pg_database.datname='$2';"

	fi
else
	echo -e "\nSe debe especificar el usuario.\nFormato: ./clusterBackup.sh -'usuario de Postgresql' \n"
fi
