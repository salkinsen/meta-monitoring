#!/bin/bash

scenario_name=scenario02

outfile=reports/"$scenario_name".txt
loadgen_csv=reports/loadgen-"$scenario_name".csv

error_msg="Something went wrong, aborted the rest! \
Check state of cluster, might be problematic!"

echo "----------------SCENARIO 2 STARTING----------------" | tee -a $outfile

./deploy.sh -r $outfile -c $loadgen_csv \
    -m ../../microservices-demo/kubernetes-manifests/microservices-tracing \
    -l ../../microservices-demo/kubernetes-manifests/loadgenerator/loadgenerator100.yaml \
    -o ../manifests-observability/ \
    -e ../manifests-elasticsearch/

if [ $? -eq 1 ]; then
   echo "$error_msg"
   exit 1
fi

echo "----------------SCENARIO 2 FINISHED----------------" | tee -a $outfile