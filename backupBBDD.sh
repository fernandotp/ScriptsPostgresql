#!/bin/bash
# This script performs a pg_dump, saving the file the specified dir.
# The first arg ($1) is the database user to connect with.
# The second arg ($2) is the database to backup and is included in the file name.
# $(date +"%Y_%m_%d") includes the current system date into the actual file name.

echo ''
today=`date '+%Y_%m_%d__%H_%M_%S'`;
echo $today
nombreBackup="`date '+%Y_%m_%d__%H_%M_%S'`_$2.sql"
#nombreBackup="$today_$2.sql"
echo $nombreBackup
echo 'Tamaño backup anterior:' 
du -sh ~/Example_Dumps/2021_10_11_$2.sql
echo ''
pg_dump -U $1 -W -C -d $2 > ~/Example_Dumps/$nombreBackup
echo 'Tamaño nuevo backup:'
du -sh  ~/Example_Dumps/$nombreBackup

