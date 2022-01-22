#!/bin/bash
# Este script realiza un pg_dump de todas las bases de datos existentes, guardando los backups en el directorio especificado. 
# El primer argumento ($1) es el usuario de postgresql con el que nos conectamos.

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


if [[ (-n "$1")]];
then 

	obtenerNombresBBDD

		for i in ${nombresBBDD[@]}
		do
			./backupBBDD.sh $1 $i
		done

else
	echo -e "\nSe debe especificar el usuario de la base de datos.\nFormato: ./backupBBDD.sh -'usuario de Postgresql' \n"
fi

rm temp.txt
