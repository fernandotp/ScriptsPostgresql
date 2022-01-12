#!/bin/bash
# Este Script muestra todos los filesystems que tengan un porcentaje de ocupacion mayor al indicado

OCUPACION=87

numeroLineas=$(df -T | awk '$6>$OCUPACION { print $0}' | wc -l )
if [[ $numeroLineas -gt 1 ]];
then
        df -T | awk '$6>69 { print $0}'
fi

