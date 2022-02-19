#!/bin/bash
# Este Script muestra todos los filesystems que tengan un porcentaje de ocupacion mayor al indicado

  numeroLineas=$(df -h | awk '$5>56 { print $0}' | wc -l )
        if [[ $numeroLineas -gt 1 ]];
        then
		echo -e "\n---------------  Filesystems con más de un 56% de ocupación ---------------"
#		echo -e "-------------------------------------------------\n"
                df -h | awk '$5>56 { print $0}'
		echo ""
	else
		echo -e "\n Ningún filesystem supera el 56% de ocupación\n"
        fi

