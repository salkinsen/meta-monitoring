# Prerequisites

Some of the scripts in the folder deployment-scripts need jq. It can been installed e.g. via snap:
```bash
sudo snap install jq
```

# meta-monitoring
This project is an attempt to measure the resource costs of observability in a microservice context.

## Test with kind
kind create cluster --config kind-config.yaml  
load images into cluster if present:  
kind load docker-image docker.elastic.co/elasticsearch/elasticsearch:7.13.0 docker.elastic.co/beats/filebeat:7.13.0 docker.elastic.co/kibana/kibana:7.13.0 docker.elastic.co/beats/metricbeat:7.13.0


## assign one node as meta-monitoring-node
kubectl get nodes  
kubectl label nodes \<node-name\> layer=meta-monitoring  
z.B. kubectl label nodes kind-worker layer=meta-monitoring  
(  
to verify:  
kubectl get nodes --show-labels  
or  
kubectl describe node "nodename"  
)

## access Kibana UI for Logging
kubectl port-forward svc/kibana-logging :5601 

## access Kibana UI for Monitoring
kubectl port-forward svc/kibana-metrics :5601 

## access Jaeger UI (if deployed)
kubectl port-forward svc/jaeger-query :80

## access Meta-Monitoring
kubectl -n meta-monitoring port-forward svc/meta-grafana 3000:3000
kubectl -n meta-monitoring port-forward svc/meta-prometheus 9091:9091

## access FrontEnd
kubectl port-forward deployment/frontend 8080:8080

## show pods and on which nodes they are
kubectl get pods --all-namespaces -o wide

## check if default namespace is clear
kubectl get pods; kubectl get pvc; kubectl get pv

# check metrics of jaeger agent
kubectl port-forward <jaeger-agent-pod> :14271
go to address and append /metrics

# check metrics of jaeger collector
kubectl port-forward <jaeger-collector-pod> :14269
go to address and append /metrics

# example for useful command to search for error messages regarding dropped spans
kubectl logs checkoutservice-6c77694b4-ltn2l | grep -E -i "(spans|span|drop|dropped|queue|max)"