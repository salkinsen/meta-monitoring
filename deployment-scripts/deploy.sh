#!/bin/bash

# This script is used to setup and measure the different scenarios.
# It is called from the scenario-scripts.

usage() {
  printf "Usage:\n
    use -r flag to give name for output-report file (required).\n
    use -o flag to specify file/folder options for observability yaml files (optional).\n
    use -e flag to specify file/folder options for elasticsearch yaml files (optional).\n
    use -m flag to specify file/folder options for microservice yaml files (required).\n
    use -l flag to specify file/folder options for loadgenerator yaml file (required).\n
    e.g $0 -r scenario1-report.txt -o ../manifests-observability/ -m ../../microservices-demo/kubernetes-manifests/microservices-tracing \n"
}

setup_elasticsearch() {
  for val in "${es[@]}"; do
      deploy_es_str+="-f $val "
  done &&
  kubectl apply $deploy_es_str &&
  echo "Started elasticsearch"
}

setup_observability() {
  setup_elasticsearch &&
  for val in "${obs[@]}"; do
      deploy_obs_str+="-f $val "
  done &&
  kubectl apply $deploy_obs_str &&
  echo "Started observability, waiting 10 minutes ..." &&
  sleep 10m
}

setup_microservices_loadgen() {
  for val in "${ms[@]}"; do
      deploy_ms_str+="-f $val "
  done &&
  kubectl apply $deploy_ms_str &&
  echo "Started microservices, waiting 5 minutes before deploying loadgenerator ..." &&
  sleep 5m &&
  kubectl apply -f $loadgen &&
  echo "Started loadgenerator, waiting 10 minutes ..." &&
  sleep 10m
}

#-----------------------------
# --- Get flag arguments -----
#-----------------------------

while getopts 'o:m:r:l:' flag; do
    case "${flag}" in
        r)  outfile="${OPTARG}";;
        o)  obs+=("${OPTARG}");;
        m)  ms+=("${OPTARG}");;
        e)  es+=("${OPTARG}");;
        l)  loadgen="${OPTARG}";;
        *)  usage
            exit 1 ;;
  esac
done

if [ -z "${outfile}" ] || [ -z "$ms" ] || [ -z "${loadgen}" ]; then
    echo 'Missing -r or -m or -l' >&2
    usage
    exit 1
fi

if [ -n "$obs" ] && [ -z "$es"]; then
  echo "specified observability, but not elasticsearch"
  echo "that can't be, check arguments."
  usage
  exit 1
fi

echo "Starting setup, current time:" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile &&

#-----------------------------------
# --- Observability Deployment -----
#-----------------------------------

if [ -n "$obs" ]; then
  setup_observability
fi

if [ $? -ne 0 ]; then
  echo "failed to setup observability, aborting ..."
  exit 1
fi

#-----------------------------------
# --- Microservice Deployment ------
#-----------------------------------


setup_microservices_loadgen

if [ $? -ne 0 ]; then
  echo "failed to setup microservices or loadgenerator, aborting ..."
  exit 1
fi

echo "Everything setup!" &&
echo "START of main measurement phase. Current time:" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile &&
sleep 15m &&

#-------------------------------------
# --- Stop everything exept ES--------
#-------------------------------------

echo "END of main measurement phase. Current time:" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile &&
kubectl delete -f $loadgen &&
kubectl delete $deploy_ms_str


if [ $? -ne 0 ]; then
  echo "Something went wrong between setup and deleting ms/loadgen, aborting ..."
  exit 1
fi

if [ -n "$deploy_obs_str" ]; then
  kubectl delete -f $deploy_obs_str
fi

if [ $? -ne 0 ]; then
  echo "failed to delete observability, aborting ..."
  exit 1
fi

# exit if elasticsearch wasn't deployed,
# but delete pvc just to be safe
if [ -z "$es" ]; then
  kubectl delete pvc --all
  exit 0
fi


echo "Everything except elasticsearch should now be stopped, waiting 10 min ..." &&
sleep 10m &&
echo "10m since everything except ES has been stopped" &&
echo "Measure Elasticsearch-PV (used bytes) here:" | tee -a $outfile &&
date +"%Y-%m-%d %T" | tee -a $outfile

if [ $? -ne 0 ]; then
  echo "something went wrong after ms and obs have been stopped."
  echo "but before final cleanup."
  echo "aborting ..."
  exit 1
fi


#-------------------------
# --- Final Clean up -----
#-------------------------

if [ -n "$es" ]; then
  echo "deleting elasticsearch"
  kubectl delete $deploy_es_str
fi

if [ $? -ne 0 ]; then
  echo "failed to delete elasticsearch, aborting ..."
  exit 1
fi

kubectl delete pvc --all


