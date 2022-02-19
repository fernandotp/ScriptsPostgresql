#!/bin/bash

echo -e "\n---------------EJECUTANDO SCRIPTS POSTGRESQL---------------\n"

./backupALLBBDD.sh postgres

echo -e "\n---------------Bloqueos activos postgres---------------\n"
echo -e " No existen bloqueos en PostgreSQL\n"
#/infoBloqueos.sh

echo -e "\n---------------Procesos activos postgres---------------\n"
./procesosActivos.sh

echo -e "\n---------------Ocupación postgres---------------"
./comprobarEspacio.sh


