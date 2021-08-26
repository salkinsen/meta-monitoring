#!/bin/bash

usage() {
  printf "Usage:
    use -s flag to give name for scenario name, e.g. scenario01 (required).
    use -t flag to give number of times the scenario should be run (required).
    e.g $0 -s scenari01 -t 5 \n"
}

check_reports_folder() {
    if [ -z "$(ls ./reports)" ]; then
        return    
    fi
    echo "Directory ./reports contains visible files. They might get overwritten."
    echo "Do you want to continue anyway? (Press y/Y to continue or something else to abort.)"
    read -n 1 -r
    echo    # new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
}


#-----------------------------
# --- Get flag arguments -----
#-----------------------------

while getopts 's:t:' flag; do
    case "${flag}" in
        s)  scenario="${OPTARG}";;
        t)  times=("${OPTARG}");;
        *)  usage
            exit 1 ;;
    esac
done

if [ -z "$scenario" ] || [ -z "$times" ]; then
    printf 'Missing -s or -t\n' >&2
    usage
    exit 1
fi

#-----------------------------
# ------ Run scenario  -------
#-----------------------------

check_reports_folder

for (( i=1; i <= $times; i++ ))
do
    if [ $i != 1 ]; then
        printf "Waiting 1 minute before starting next pass ...\n"
        sleep 1m
    fi

    echo "------------------------Running $scenario, pass $i------------------------"
    ./"$scenario".sh

    if [ $? -eq 1 ]; then
        printf "failed to start scenario\n"
        exit 1
    fi

    # rename loadgen csv file, so it doesn't get overwritten during next pass
    mv ./reports/loadgen-"$scenario".csv ./reports/loadgen-"$scenario"-"$i".csv
    if [ $? -eq 1 ]; then
        printf "failed to rename loadgen csv file, aborting ...\n"
        exit 1
    fi

done