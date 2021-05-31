# Elastic Stack Kubernetes Helm Charts

The files and helm chart-folders in this directory are taken from the [Elastic Helm Chart Repository](https://github.com/elastic/helm-charts) (release [v7.11.2](https://github.com/elastic/helm-charts/tree/v7.11.2)) and have been partially modified to be deployed as observability measures with [this fork of Google's microservices demo application "Online Boutique"](https://github.com/salkinsen/microservices-demo).

## Deployment and Clean Up

From within the respective folders:

### Elastic Search

*for minikube:*  
cd examples/minikube/  
make install  
make purge  

*default:*  
helm install elasticsearch .  
helm uninstall elasticsearch

#### Kibana

helm install kibana .  
*for minikube:* kubectl port-forward svc/kibana-kibana :5601  
helm uninstall kibana

#### Logstash

helm install logstash .  
helm uninstall logstash

### Filebeat

helm install filebeat .  
helm uninstall logstash