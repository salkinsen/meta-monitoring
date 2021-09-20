This repository is part of my bachelor thesis **Resource Costs of Observability in Microservice Systems**. It is intended to be used with the [fork of Google's Online Boutique](https://github.com/salkinsen/microservices-demo), which contains a microservice app that is instrumented with OpenTelemetry. 

**Important**: The following instructions and the scripts in the [./deployment-scripts](./deployment-scripts)-folder assume that this repository (meta-monitoring) is cloned into the same folder that the [adapted microservice demo](https://github.com/salkinsen/microservices-demo) project is cloned into. The folder structure should look something like this:

```
.
├──  microservice-demo
├──  meta-monitoring
```



Both repositories should be cloned into the same folder or else the deployment scripts will not work.

This project is an attempt to measure the resource costs of observability in a microservice context.

The Kubernetes manifest files for Elasticsearch, Filebeat, Metricbeat and Kibana were created by using the official [Elastic Helm charts](https://github.com/elastic/helm-charts). Since most of Helms functionality wasn't needed for this project, the charts were rendered (with [helm template](https://helm.sh/docs/helm/helm_template/)) into yaml files with the standard values. These were then modified for integration, where necessary.

The same process was followed regarding the official [Jaeger Helm charts](https://github.com/jaegertracing/helm-charts).

## Prerequisites
Set up a Kubernetes cluster with at least two nodes. Recommended minimum resources are 2 vCPU cores and 8 GB memory for the meta-monitoring and 6 vCPU cores, 16 GB memory for the other node(s). The meta-monitoring-node needs to be labeled with key=layer and value=meta-monitoring. E.g. in a kind cluster via
```shell
kubectl get nodes
kubectl label nodes <node-name> layer=meta-monitoring  
```

## Deployment and Accessing UIs
Make sure kubectl is connected to the cluster.

To deploy the different measurement scenarios that were used in the thesis, refer to the [./deployment-scripts](./deployment-scripts)-folder and the corresponding README there.

To simply deploy the meta-monitoring-layer, all microservices and the observability containers with a sampling rate of 10 % as well as the load generator with a load of 100 req/s, execute the following command:

```shell
kubectl apply -f manifests-meta-monitoring/ -f manifests-elasticsearch/ -f manifests-observability/ -f ../microservices-demo/kubernetes-manifests/microservices-tracing-sampling-10perc/ -f ../microservices-demo/kubernetes-manifests/loadgenerator/loadgenerator100.yaml
```

Wait for the pods to stabilize.

### Grafana

To access Grafana on the meta-monitoring-node, access the service entpoint from the meta-grafana pod through a browser. You can get the address through the cloud provider (e.g. the `Services & Ingress`-tab in Google Cloud). In a local cluster, you might have to use port forwarding. E.g. for a kind cluster, the following command should give you an endpoint:
```shell
kubectl -n meta-monitoring port-forward svc/meta-grafana :3000
```
Log into Grafana by using `admin` for both the Username- and Password-field. Afterwards you can set a new password or click `skip`. Using the navigation bar on the left, navigate to Dashboards -> Manage. Click on the `cAdvisor from Prometheus`-dashboard. 

The first five panels show point values for the average from the last 15 minutes regarding CPU usage, memory usage, received network bytes, sent network bytes and the current value for used bytes of persistent volumes from the Elasticsearch instances. These panels can be used to export CSV files. The next five panel show more visual timeseries of the same metrics.

### Jaeger Query

Jaeger Query can visualize traces and can be accessed through the service endpoint from the cloud provider or, in a local cluster, through e.g. port-forwarding.
```shell
kubectl port-forward svc/jaeger-query :80
```
### Kibana Logging
Access the kibana-logging service endpoint through the cloud provider or by using port-forwarding in a local cluster via
```shell
kubectl port-forward svc/kibana-logging :5601 
```
Click on `explore on my own` and through the navigation bar on the left, navigate to Observability -> Logs. You should see a stream of the current logs. For instructions on how to filter, categorize, search for logs, etc. refer to the [Kibana Documentation (Log monitoring)](https://www.elastic.co/guide/en/observability/7.13/monitor-logs.html). The logs are enriched by Kubernetes metadata, so they can be searched or filtered using fields like for instance `kubernetes.pod.name`.

### Kibana Metrics
Access the kibana-metrics service endpoint through the cloud provider or by using port-forwarding in a local cluster via
```shell
kubectl port-forward svc/kibana-metrics :5601 
```
Click on `explore on my own` and through the navigation bar on the left, navigate to Observability -> Metrics. Via Show -> Kubernetes Pods you can get view metrics by pods. For more information on how to use the Kibana Metrics App, refer to its [documentation](https://www.elastic.co/guide/en/observability/7.13/analyze-metrics.html).