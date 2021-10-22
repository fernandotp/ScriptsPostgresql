#!/bin/bash

echo -e "\n---------- Procesos activos de postgres ----------"
ps -ef | grep postmaster | grep postgres/
