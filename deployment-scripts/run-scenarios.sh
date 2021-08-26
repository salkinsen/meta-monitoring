#!/bin/bash

scenarios=(
    scenario01.sh
    scenario02.sh
    scenario03.sh
    scenario04.sh
    scenario05.sh
    scenario06.sh
    scenario07.sh
    scenario08.sh
)

for i in ${!scenarios[@]}
do
    if [ $i != 0 ]; then
        printf "Waiting 1 minute before starting next scenario ...\n"
        sleep 1m
    fi

    ./"${scenarios[$i]}"

    if [ $? -eq 1 ]; then
        printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        printf "$s went wrong! Check state of cluster! Aborting!"
        printf "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        exit 1
    fi
done
