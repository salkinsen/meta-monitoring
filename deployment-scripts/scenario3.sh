#!/bin/bash

outfile=reports/scenario3.txt

error_msg="Something went wrong, aborted the rest! \
Check state of cluster, might be problematic!"

echo "----------------SCENARIO 3 STARTING----------------" | tee -a $outfile

./deploy.sh -r $outfile \
    -m ../../microservices-demo/kubernetes-manifests/microservices-no-tracing/ \
    -l ../../microservices-demo/kubernetes-manifests/loadgenerator/loadgenerator100.yaml \
    -o ../manifests-observability/filebeat.yaml \
    -o ../manifests-observability/kibana-logging.yaml \
    -e ../manifests-elasticsearch/elasticsearch-logging.yaml

if [ $? -eq 1 ]; then
   echo "$error_msg"
   exit 1
fi

echo "----------------SCENARIO 3 FINISHED----------------" | tee -a $outfile