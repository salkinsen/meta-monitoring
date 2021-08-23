#!/bin/bash

#-----------------------------
# --- Get flag argument ------
#-----------------------------

usage() {
  printf "Usage:\n
    use -c flag to give name for output-csv file from loadgenerator (required).\n"
}

while getopts 'c:' flag; do
    case "${flag}" in
        c)  csv="${OPTARG}";;
        *)  usage
            exit 1 ;;
  esac
done

if [ -z "${csv}" ]; then
    printf 'Missing -c. Please give location for csv file.\n' >&2
    exit 1
fi

#-------------------
# --- Get CVS ------
#-------------------

loadgen_pod_name=$(kubectl get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' \
    | grep ^loadgenerator)

# echo "$loadgen_pod_name"
# kubectl exec "$loadgen_pod_name" -- ls -la /

"Extracting csv-file from loadgenerator ...\n"
kubectl cp default/"$loadgen_pod_name":loadgen_stats_history.csv "${csv}"

if [ $? -eq 1 ]; then
   exit 1
fi