#!/bin/bash
# Este script realiza un pg_dump, guardando el backup en el directorio especificado. 
# El primer argumento ($1) es el usuario de postgresql con ek que nos conectamos.
# El segundo argumento ($2) es la base de datos de la que se realiza el backup.

DIRBACKUPS=/root/backups/postgresql

if [[ (-n "$1") && (-n "$2")]];
then # If first parameter passed
	echo -e "\nRealizando backup de $2..."
	today=`date '+%Y_%m_%d__%H_%M_%S'`;
	nombreBackup="backup_$2_`date '+%Y-%m-%d_%H:%M:%S'`.sql"


		#------------REALIZAR BACKUP--------------

	ultimoBackup=$(find $DIRBACKUPS -name "*_$2_*" -type f -mtime -9 | tail -1)
	tamanoUltimoBck=$(du -sh $ultimoBackup)
	pg_dump -h localhost -U $1 -d $2 > $DIRBACKUPS/$nombreBackup
	tamanoNuevoBck=$(du -sh  $DIRBACKUPS/$nombreBackup)
	bckVacio=${tamanoNuevoBck:0:1}

	if [ $bckVacio -eq 0 ]
	then
		echo -e "\nError. No se pudo realizar el backup de $2\n"
		rm $DIRBACKUPS/$nombreBackup
	else
		FICHERO=$DIRBACKUPS/$nombreBackup
		cd  $DIRBACKUPS

		if [ -f $nombreBackup ]
		then
			if [ "$(ls $DIRBACKUPS)" ]
			then
				if [ "$ultimoBackup" ]
				then
					echo -e "\nTamaño del ultimo backup de $2: $tamanoUltimoBck\n"
				fi
			fi
			echo -e "\nTamaño del nuevo backup de $2: $tamanoNuevoBck"
			echo ""
			echo -e "\n--------------- Espacio file system backups ---------------"
			df -h $DIRBACKUPS
			echo ""
		else
 			echo -e "\nERROR. No se pudo realizar el bakup de $2\n"
		fi

		#psql -U $1 -d $2 -c "SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS SIZE FROM pg_database WHERE pg_database.datname='$2';"
	fi
else
	echo -e "\nSe debe especificar el usuario y la base de datos.\nFormato: ./backupBBDD.sh -'usuario de Postgresql' -'Base de datos'\n"
fi
