#!/bin/bash

declare -A nombresBBDD 

dirBackups=~/backups

obtenerNombresBBDD(){
echo "hola"
sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;"| while read -a Datos_Consulta ; do

j=0

DATO1=${Datos_Consulta}
if [[ ("$DATO1" != "datname" && "$DATO1" != "-----------------" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
	let j=j+1
	nombresBBDD[$j]=$DATO1
	echo $DATO1 >> temp.txt
fi
done

while read -a Datos_Consulta;
do

DATO1=${Datos_Consulta}
if [[ ("$DATO1" != "datname" && "$DATO1" != "-----------------" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
	let j=j+1
	nombresBBDD[$j]=$DATO1
fi
done <temp.txt
}


obtenerNombresBBDD

if [ -n "$1" ]; then # If first parameter passed

	if [ "$(ls ~/backups)" ]
	then
		echo -e "\n---------- Espacio file system backups ----------"
		fileSystemBackups=$(df -T ~/backups)
		echo "$fileSystemBackups"

		
		for i in ${nombresBBDD[@]}
		do	
			ultimoBackup=$(find ~/backups/ -name "*$i*" -type f -mtime -9 | tail -1)

			if [ "$ultimoBackup" ]
			then
				tamanoUltimoBck=$(du -sh $ultimoBackup)
				echo -e "\nTamaño del ultimo backup de $i: $tamanoUltimoBck\n"
			else
				echo -e "\nNo existe ningun backup de $i\n"
			fi
		done
	else	
		echo "El directorio de backups está vacio"

	fi

	FICHERO=~/backups/$nombreBackup	
	
else

	echo -e '\nSe debe especificar la BBDD\n'

fi
rm temp.txt


