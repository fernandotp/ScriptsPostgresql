#!/bin/bash

procesosActivos=$(ps -ef | grep postmaster | grep postgres/)
if [ "$procesosActivos" ]
then
	echo -e "\n---------- Procesos activos de postgres ----------"
	echo $procesosActivos
else
	echo -e "\nActualmente no hay ningún proceso de postgres activo"
fi
echo ""
