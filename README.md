# meta-monitoring
This project is an attempt to measure the resource costs of observability in a microservice context.

## To test with minikube, create two nodes
minikube start --driver=virtualbox --nodes 2 --disk-size 40g 

Note that this could use up to 80g of disk space in the minikube home directory. However only actually used space will be taken. You can change the location of this directory through the environment variable [MINIKUBE_HOME](https://minikube.sigs.k8s.io/docs/handbook/config/). 

Stop the nodes with "minikube stop" and in VirtualBox, set the resources for 
- the first node to
    - CPUs = 4, memory = 8000 MB
- and the second node to
    - CPus = 2, memory = 3000 MB. 

Only do this if the system has enough resources left afterwards for normal operation. Then restart with "minikube start".

## Test with kind
kind create cluster --config kind-config.yaml

## assign one node as meta-monitoring-node
kubectl get nodes  
kubectl label nodes \<node-name\> layer=meta-monitoring  
(  
to verify:  
kubectl get nodes --show-labels  
or  
kubectl describe node "nodename"  
)