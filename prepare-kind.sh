#!/bin/bash
# load relevant images into kind
kind create cluster --config kind-config.yaml
./kind-load-images.sh
kubectl label nodes kind-worker layer=meta-monitoring

# kind load docker-image quay.io/coreos/kube-state-metrics:7.11.2