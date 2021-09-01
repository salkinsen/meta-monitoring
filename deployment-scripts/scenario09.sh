#!/bin/bash

scenario_name=scenario09

outfile=reports/"$scenario_name".txt
loadgen_csv=reports/loadgen-"$scenario_name".csv

error_msg="Something went wrong, aborted the rest! \
Check state of cluster, might be problematic!"

echo "----------------SCENARIO 9 STARTING----------------" | tee -a $outfile

./deploy.sh -r $outfile -c $loadgen_csv \
    -m ../../microservices-demo/kubernetes-manifests/microservices-tracing-sampling-10perc/ \
    -l ../../microservices-demo/kubernetes-manifests/loadgenerator/loadgenerator75.yaml \
    -o ../manifests-observability/jaeger.yaml \
    -e ../manifests-elasticsearch/elasticsearch-tracing.yaml

if [ $? -eq 1 ]; then
   echo "$error_msg"
   exit 1
fi

echo "----------------SCENARIO 9 FINISHED----------------" | tee -a $outfile