#!/usr/bin/env bash
# Validate not sudo
user_id=`id -u`
if [ $user_id -eq 0 -a -z "$RUNNER_ALLOW_RUNASROOT" ]; then
    echo "Must not run interactively with sudo"
    exit 1
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
app_name=$1
image=$2
namespace=$3

deploy=`oc get deployment $app_name`
if [[ "$?" -eq 0 ]]; then
    oc set image deployment/$app_name $app_name=$image
    oc rollout restart deployment/$app_name
else
    oc new-app $image --name $app_name -n $namespace
fi
