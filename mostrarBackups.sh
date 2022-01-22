#!/bin/bash

declare -A nombresBBDD
DIRBACKUPS=/root/backups/postgresql

obtenerNombresBBDD(){
	cd /tmp
	sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;"| while read -a Datos_Consulta ; do

		j=0
		DATO1=${Datos_Consulta}
		if [[ ("$DATO1" != "datname" && "${DATO1:1:2}" != "--" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
			let j=j+1
			nombresBBDD[$j]=$DATO1
			echo $DATO1 >> temp.txt
		fi
	done

	while read -a Datos_Consulta;
	do
		DATO1=${Datos_Consulta}
		if [[ ("$DATO1" != "datname" && "${DATO1:1:2}" != "--" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
			let j=j+1
			nombresBBDD[$j]=$DATO1
		fi
	done <temp.txt
}

postgresActivo=$(ps -ef | grep postgresql | grep config_file)
#postgresActivo=$(ps -ef | grep postmaster | grep postgres/)

if [ "$postgresActivo" ]
then
	obtenerNombresBBDD
	[ ! -d "${DIRBACKUPS}" ] && mkdir -p "${DIRBACKUPS}"
	if [ "$(ls $DIRBACKUPS)" ]
	then
		echo -e "\n--------------- Espacio file system backups ---------------"
		fileSystemBackups=$(df -T $DIRBACKUPS)
		echo "$fileSystemBackups"

		for i in ${nombresBBDD[@]}
		do
			ultimoBackup=$(find $DIRBACKUPS -name "*$i*" -type f | grep _$i_ | tail -1)

			if [ "$ultimoBackup" ]
			then
				tamanoUltimoBck=$(du -sh $ultimoBackup)
				echo -e "\nTamaño del ultimo backup de $i: $tamanoUltimoBck\n"
			else
				echo -e "\nNo existe ningun backup de $i\n"
			fi
		done
	else
		echo -e "\nEl directorio de backups está vacio\n"
	fi
	#./borrarAntiguosBackups.sh $nombresBBDD
	rm temp.txt
else
	echo -e "\nEl servicio de postgres está inactivo\n"
fi


