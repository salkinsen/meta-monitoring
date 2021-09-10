#!/bin/bash

# scenarios=(
#     scenario01.sh
#     scenario02.sh
#     scenario03.sh
#     scenario04.sh
#     scenario05.sh
#     scenario06.sh
#     scenario07.sh
#     scenario08.sh
# )

# scenarios=(
#     scenario09.sh
#     scenario10.sh
#     scenario11.sh
#     scenario12.sh
#     scenario13.sh
#     scenario14.sh
# )

# scenarios=(
#     scenario15.sh
#     scenario16.sh
#     scenario17.sh
# )

scenarios=(
    scenario18.sh
    scenario19.sh
    scenario20.sh
)

check_reports_folder() {
    if [ -z "$(ls ./reports)" ]; then
        return    
    fi
    echo "Directory ./reports contains visible files. They might get overwritten."
    echo "Do you want to continue anyway? (Press y/Y to continue or something else to abort.)"
    read -n 1 -r
    echo    # move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}

check_reports_folder

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
