#!/bin/bash

kind create cluster

helm upgrade --install crossplane crossplane --repo https://charts.crossplane.io/stable --namespace crossplane-system --create-namespace --wait

kubectl wait --for=condition=healthy provider.pkg.crossplane.io --all --timeout=5m

kubectl apply -f functions.yaml

kubectl wait --for=condition=healthy function.pkg.crossplane.io --all --timeout={{timeout}}

kubectl apply -f extra-resources.yaml

kubectl apply -f compositeresourcedefinition.yaml

kubectl apply -f composition.yaml

kubectl apply -f xr.yaml
