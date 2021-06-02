default: install

install:
	$(MAKE) -C ./elasticsearch/examples/minikube install
	kubectl apply -f filebeat/permissiontest.yaml
	helm install kibana kibana/.

uninstall:
	$(MAKE) -C elasticsearch/examples/minikube purge
	kubectl delete -f filebeat/permissiontest.yaml
	helm uninstall kibana