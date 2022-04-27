#!/bin/bash

PROJECT=jupyterhub

oc delete project $PROJECT
oc new-project $PROJECT 2> /dev/null
while [ $? \> 0 ]; do
    sleep 1
    printf "."
oc new-project $PROJECT 2> /dev/null
done

oc apply -f imagestreams/gpu-notebook-base.yaml
oc apply -f imagestreams/tensorflow-gpu-notebook.yaml
oc apply -f imagestreams/jupyterhub.yaml
oc apply -f imagestreams/s2i-minimal-notebook.yaml

# oc create configmap jupyterhub-cfg --from-file=jupyterhub_config.py=jupyterhub_config.py

oc create -f deploy-templates.yaml

oc new-app --template jupyterhub-ocp-oauth