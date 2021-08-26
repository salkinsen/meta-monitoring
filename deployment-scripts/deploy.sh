#!/bin/bash

# This script is used to setup and measure the different scenarios.
# It is called from the scenario-scripts.

usage() {
  printf "Usage:
    use -r flag to give name for output-report file (required).
    use -c flag to give name for output-csv file from loadgenerator (required).
    use -o flag to specify file/folder options for observability yaml files (optional).
    use -e flag to specify file/folder options for elasticsearch yaml files (optional).
    use -m flag to specify file/folder options for microservice yaml files (required).
    use -l flag to specify file/folder options for loadgenerator yaml file (required).
    e.g $0 -r scenario1-report.txt -o ../manifests-observability/ -m ../../microservices-demo/kubernetes-manifests/microservices-tracing \n"
}

setup_elasticsearch() {
  for val in "${es[@]}"; do
      deploy_es_str+="-f $val "
  done &&
  kubectl apply $deploy_es_str &&
  printf "Started elasticsearch\n"
}

setup_observability() {
  setup_elasticsearch &&
  for val in "${obs[@]}"; do
      deploy_obs_str+="-f $val "
  done &&
  kubectl apply $deploy_obs_str &&
  printf "Started observability, waiting 10 minutes ...\n" &&
  sleep 10m
}

setup_microservices_loadgen() {
  for val in "${ms[@]}"; do
      deploy_ms_str+="-f $val "
  done &&
  kubectl apply $deploy_ms_str &&
  printf "Started microservices, waiting 5 minutes before deploying loadgenerator ...\n" &&
  sleep 5m &&
  kubectl apply -f $loadgen &&
  printf "Started loadgenerator, waiting 10 minutes ...\n" &&
  sleep 10m
}

#-----------------------------
# --- Get flag arguments -----
#-----------------------------

while getopts 'o:m:r:l:e:c:' flag; do
    case "${flag}" in
        r)  outfile="${OPTARG}";;
        o)  obs+=("${OPTARG}");;
        m)  ms+=("${OPTARG}");;
        e)  es+=("${OPTARG}");;
        l)  loadgen="${OPTARG}";;
        c)  csv="${OPTARG}";;
        *)  usage
            exit 1 ;;
  esac
done

if [ -z "${outfile}" ] || [ -z "$ms" ] || [ -z "${loadgen}" ] || [ -z "${csv}" ]; then
    printf 'Missing -r or -m or -l or -c\n' >&2
    usage
    exit 1
fi

if [ -n "$obs" ] && [ -z "$es" ]; then
  printf "specified observability, but not elasticsearch\n"
  printf "that can't be, check arguments.\n"
  usage
  exit 1
fi

printf "Starting setup, current time:\n" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile &&

#-----------------------------------
# --- Observability Deployment -----
#-----------------------------------

if [ -n "$obs" ]; then
  setup_observability
fi

if [ $? -ne 0 ]; then
  printf "failed to setup observability, aborting ...\n"
  exit 1
fi

#-----------------------------------
# --- Microservice Deployment ------
#-----------------------------------


setup_microservices_loadgen

if [ $? -ne 0 ]; then
  printf "failed to setup microservices or loadgenerator, aborting ...\n"
  exit 1
fi

printf "Everything setup!\n" &&
printf "Pods with restart count != 0 ---->:\n" | tee -a $outfile &&
kubectl get pod -o=json \
  | jq -r '.items[]|select(any( .status.containerStatuses[]; .restartCount!=0))|"\(.metadata.name)\t\t\(.status.containerStatuses[].restartCount)"' \
  | tee -a $outfile &&
printf "<----------------------------------\n" | tee -a $outfile

if [ $? -ne 0 ]; then
  printf "Something went wrong while trying to get restart statuses of pods. 
    Check if jq is installed. Aborting ..."
  exit 1
fi

printf "START of main measurement phase. Current time:\n" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile &&
sleep 15m &&

#-------------------------------------
# --- Stop everything exept ES--------
#-------------------------------------

printf "END of main measurement phase. Current time:\n" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile


if [ $? -ne 0 ]; then
  printf "Something went wrong after setup and before deleting observability, aborting ...\n"
  exit 1
fi

printf "Pods with restart count != 0 ---->:\n" | tee -a $outfile &&
kubectl get pod -o=json \
  | jq -r '.items[]|select(any( .status.containerStatuses[]; .restartCount!=0))|"\(.metadata.name)\t\t\(.status.containerStatuses[].restartCount)"' \
  | tee -a $outfile &&
printf "<----------------------------------\n" | tee -a $outfile

if [ $? -ne 0 ]; then
  printf "Something went wrong while trying to get restart statuses of pods. 
    Check if jq is installed. Aborting ..."
  exit 1
fi

if [ -n "$deploy_obs_str" ]; then
  kubectl delete $deploy_obs_str
fi

if [ $? -ne 0 ]; then
  printf "failed to delete observability, aborting ...\n"
  exit 1
fi

./loadgen-get-csv.sh -c "${csv}"

if [ $? -ne 0 ]; then
  printf "failed to extract csv file from loadgenerator, something is wrong, aborting ...\n"
  exit 1
fi

kubectl delete -f $loadgen &&
kubectl delete $deploy_ms_str

if [ $? -ne 0 ]; then
  printf "failed to delete ms/loadgen, aborting ...\n"
  exit 1
fi

# exit if elasticsearch wasn't deployed,
# but delete pvc just to be safe
if [ -z "$es" ]; then
  kubectl delete pvc --all
  exit 0
fi


printf "Everything except elasticsearch should now be stopped, waiting 10 min ...\n" &&
sleep 10m &&
printf "10m since everything except ES has been stopped\n" &&
printf "Measure Elasticsearch-PV (used bytes) here:\n" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile

if [ $? -ne 0 ]; then
  printf "something went wrong after ms and obs have been stopped.\n"
  printf "but before final cleanup.\n"
  printf "aborting ...\n"
  exit 1
fi


#-------------------------
# --- Final Clean up -----
#-------------------------

if [ -n "$es" ]; then
  printf "deleting elasticsearch\n"
  kubectl delete $deploy_es_str
fi

if [ $? -ne 0 ]; then
  printf "failed to delete elasticsearch, aborting ...\n"
  exit 1
fi

kubectl delete pvc --all


