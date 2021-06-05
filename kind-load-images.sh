#!/bin/bash
# load relevant images into kind
kind load docker-image docker.elastic.co/elasticsearch/elasticsearch:7.11.2
kind load docker-image docker.elastic.co/beats/filebeat:7.11.2
kind load docker-image docker.elastic.co/kibana/kibana:7.11.2
kind load docker-image docker.elastic.co/beats/metricbeat:7.11.2
# kind load docker-image quay.io/coreos/kube-state-metrics:7.11.2