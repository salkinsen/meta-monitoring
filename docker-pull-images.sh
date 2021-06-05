#!/bin/bash
# load relevant images into kind
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.11.2
docker pull docker.elastic.co/beats/filebeat:7.11.2
docker pull docker.elastic.co/kibana/kibana:7.11.2
docker pull docker.elastic.co/beats/metricbeat:7.11.2
# docker pull quay.io/coreos/kube-state-metrics:2.4.1