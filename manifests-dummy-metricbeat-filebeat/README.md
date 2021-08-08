This folder contains filebeat- and metribeat-kubernetes-manifests that deploy "dummy"-versions. They can be used to measure an estimate of the minimum resource costs.

These Daemonsets are configured to not scrape metrics or collect logs. Since metricbeat will exit if there are no modules and metricsets defined, the system-module with the cpu-metricset is configured. However the period is set to 1000000m.

Filebeat likewise needs an input-type or it will exit. For this reason a "type: log" - input is defined with a file that doesn't exist.

Note that both Daemonsets log metrics about themselves to Stdout every 30 seconds. Since this is part of the standard configuration, it should be part of the minimum base resource costs.