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

	obtenerNombresBBDD
	[ ! -d "${DIRBACKUPS}" ] && mkdir -p "${DIRBACKUPS}"

                for i in ${nombresBBDD[@]}
                do
			recentBackups=$(find $DIRBACKUPS -name "*$i*" -type f -mtime -10)

                        if [ "$recentBackups" ]
                        then
				#BORRAR BACKUPS DE MAS DE 30 DIAS
				echo -e "\nLos siguientes backups con más de 10 días han sido eliminados\n"
				find $DIRBACKUPS -name "*$i*" -type f -mtime +10
				#find $DIRBACKUPS -mtime +30 -exec rm {} \;
                                #echo -e "\n$recentBackups\n"
				echo ""
                        else
				#BORRAR TODOS MENOS UNO O NO BORRAR NINGUNO
				ultimoBackup=$(find $DIRBACKUPS -name "*$i*" -type f -mtime +3 | tail -1)
				find $DIRBACKUPS -name "*$i*" -type f -mtime +3 > nombresBackupsAntiguos.txt
				if [ "$ultimoBackup" ]
				then
					echo ""
				fi
                        fi
                done
rm temp.txt
