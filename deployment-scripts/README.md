Important: For these scripts to work, this repository (meta-monitoring) needs be cloned into the same folder that the [adapted microservice demo](https://github.com/salkinsen/microservices-demo) project is cloned into. It should look something like this:

```
.
├──  microservice-demo
├──  meta-monitoring
```

Some of the scripts need jq. It can been installed e.g. via snap:
```bash
sudo snap install jq
```

# Main Scenarios

Scenario 01 - 08 have a load of 100 req/s.

| Scenario | Short Name | Description |
| ------------- | ------------- | ------------- |
| Scenario01 | No Observability  | Just the microservices. None of the observability pillars are deployed and tracing instrumentation is disabled. |
| Scenario02 | All On  | All 3 observability pillars are active, no sampling applied. |
| Scenario03 | Base Costs  | All 3 observability pillars are deployed, but not used. Tracing instrumentation is disabled, no metrics are being scraped and no logs are being collected. This serves to give an estimate of the minimum base costs of observability in this setup. |
| Scenario04 | Just Logging  | Only the logging pillar is active. No other observability containers are deployed. Tracing instrumenation is disabled. |
| Scenario05 | Just Metrics  | Only the monitoring pillar is active. No other observability containers are deployed. Tracing instrumentation is disabled. |
| Scenario06 | Just Tracing  | Only the tracing pillar is active. No other observability containers are deployed. No sampling. |
| Scenario07 | Tracing 10 \%  | Like "Just Tracing", but with 10 \% sampling. |
| Scenario08 | Tracing 1 \%  | Like "Just Tracing", but with 1 \% sampling. |

# Variations with different loads

| Scenario | Short Name | Description |
| ------------- | ------------- | ------------- |
| Scenario09 | Tracing 10 \% - 75 load  | Like "Tracing 10 \%", but with a load of 75 req/s (as opposed to the normal load of 100 req/s.) |
| Scenario10 | Tracing 10 \% - 50 load  | Like "Tracing 10 \%", but with a load of 50 req/s. |
| Scenario11 | Tracing 10 \% - 25 load  | Like "Tracing 10 \%", but with a load of 25 req/s. |
| Scenario12 | Logging - 75 load  | Like "Just Logging", but with a load of 75 req/s. |
| Scenario13 | Logging - 50 load  | Like "Just Logging", but with a load of 50 req/s. |
| Scenario14 | Logging - 25 load  | Like "Just Logging", but with a load of 25 req/s. |
| Scenario15 | Metrics - 75 load  | Like "Just Metrics", but with a load of 75 req/s. |
| Scenario16 | Metrics - 50 load  | Like "Just Metrics", but with a load of 50 req/s. |
| Scenario17 | Metrics - 25 load  | Like "Just Metrics", but with a load of 25 req/s. |
| Scenario18 | No Observability - 75 load  | Like "No Observability", but with a load of 75 req/s. |
| Scenario19 | No Observability - 50 load  | Like "No Observability", but with a load of 50 req/s. |
| Scenario20 | No Observability - 25 load  | Like "No Observability", but with a load of 25 req/s. |