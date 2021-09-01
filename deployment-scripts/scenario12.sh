#!/bin/bash

scenario_name=scenario12

outfile=reports/"$scenario_name".txt
loadgen_csv=reports/loadgen-"$scenario_name".csv

error_msg="Something went wrong, aborted the rest! \
Check state of cluster, might be problematic!"

echo "----------------SCENARIO 12 STARTING----------------" | tee -a $outfile

./deploy.sh -r $outfile -c $loadgen_csv \
    -m ../../microservices-demo/kubernetes-manifests/microservices-no-tracing/ \
    -l ../../microservices-demo/kubernetes-manifests/loadgenerator/loadgenerator75.yaml \
    -o ../manifests-observability/filebeat.yaml \
    -o ../manifests-observability/kibana-logging.yaml \
    -e ../manifests-elasticsearch/elasticsearch-logging.yaml

if [ $? -eq 1 ]; then
   echo "$error_msg"
   exit 1
fi

echo "----------------SCENARIO 12 FINISHED----------------" | tee -a $outfile