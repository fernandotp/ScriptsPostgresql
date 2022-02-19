#!/bin/bash
# Este script realiza un pg_dumpall y lo guarda en el directorio especificado.
# El argumento que se le pasa es ($1) el usuario con el que se realiza el backup

DIRBACKUPS=/root/clusterBackups/postgresql

if [ -n "$1" ];
then 
	echo -e "\nRealizando backup de $1..."
	today=`date '+%Y_%m_%d__%H_%M_%S'`;
	nombreBackup="backup_postgresql_$1Cluster_`date '+%Y-%m-%d_%H:%M:%S'`.sql"

		#------------REALIZAR BACKUP--------------

	[ ! -d "${DIRBACKUPS}" ] && mkdir -p "${DIRBACKUPS}"
	ultimoBackup=$(find $DIRBACKUPS -name "*_$1Cluster_*" -type f -mtime -9 | tail -1)
	tamanoUltimoBck=$(du -sh $ultimoBackup)
	espacioSistemaPrebck=$(df -h $DIRBACKUPS)
	pg_dumpall -U $1 > $DIRBACKUPS/$nombreBackup
	tamanoNuevoBck=$(du -sh  $DIRBACKUPS/$nombreBackup)
	bckVacio=${tamanoNuevoBck:0:1}

	if [ $bckVacio -eq 0 ]
	then
		echo -e "\nError. No se pudo realizar el backup de $1\n"
		rm $DIRBACKUPS/$nombreBackup
	else
		FICHERO=$DIRBACKUPS/$nombreBackup
		cd $DIRBACKUPS

		if [ -f $DIRBACKUPS/$nombreBackup ]
		then
			echo -e "\n--------------- Espacio file system backups ---------------"
			echo -e "$espacioSistemaPrebck \n"	
			if [ "$(ls $DIRBACKUPS)" ]
			then
				if [ "$ultimoBackup" ]
				then
					echo -e "\nTamaño del ultimo backup de $1:\n"
					echo -e "$tamanoUltimoBck\n"
				fi
			fi
			echo -e "\nTamaño del nuevo backup de $1:\n"
			echo -e "$tamanoNuevoBck"
			echo ""
			echo -e "\n--------------- Espacio file system backups ---------------"
			df -h $DIRBACKUPS
			echo ""
		else
 			echo -e "\nERROR. No se pudo realizar el backup de $1\n"
		fi

	fi
else
	echo -e "\nSe debe especificar el usuario.\nFormato: ./clusterBackup.sh -'usuario de Postgresql' \n"
fi
