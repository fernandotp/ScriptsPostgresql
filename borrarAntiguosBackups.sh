#!/bin/bash

declare -A nombresBBDD
dirBackups=/home/fernando/backups
#find $dirBackups/* -mtime +30 -exec rm {} \;

        while read -a Datos_Consulta;
        do
                DATO1=${Datos_Consulta}
                if [[ ("$DATO1" != "datname" && "${DATO1:1:2}" != "--" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
                        let j=j+1
                        nombresBBDD[$j]=$DATO1
                fi
        done <temp.txt

                for i in ${nombresBBDD[@]}
                do
			recentBackups=$(find $dirBackups -name "*$i*" -type f -mtime -3)

                        if [ "$recentBackups" ]
                        then
				#BORRAR BACKUPS DE MAS DE 30 DIAS
				#find $dirBackups -mtime +30 -exec rm {} \;
                                #echo -e "\n$recentBackups\n"
				echo ""
                        else
				#BORRAR TODOS MENOS UNO O NO BORRAR NINGUNO
				ultimoBackup=$(find $dirBackups -name "*$i*" -type f -mtime +3 | tail -1)
				find $dirBackups -name "*$i*" -type f -mtime +3 > nombresBackupsAntiguos.txt
				if [ "$ultimoBackup" ]
				then
					echo ""
				fi
                        fi
                done
	rm nombresBackupsAntiguos.txt
