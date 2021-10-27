#!/bin/bash

sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;"| while read -a Datos_Consulta ; do

DATO1=${Datos_Consulta}

if [[ ("$DATO1" != "datname" && "$DATO1" != "-----------------" && "${DATO1:0:1}" != "(" && "$DATO1" != "")]]; then
	echo "DATO 1: $DATO1"
fi

done

bbdds=(`sudo -u postgres psql -c "SELECT datname FROM pg_database WHERE datistemplate = false;"`)

for val in $bbdds; do
    echo $val
done


declare -A caracteristicas
car[0]=1
car[1]=2
for i in "${car[@]}"
do
   echo "$i"
   # or do whatever with individual element of the array
done
