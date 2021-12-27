#!/bin/bash

numeroLineas=$(df -T | awk '$6>87 { print $0}' | wc -l )
if [[ $numeroLineas -gt 1 ]];
then
        df -T | awk '$6>69 { print $0}'
fi

