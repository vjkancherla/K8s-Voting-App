#!/bin/bash

# Find and kill all kubectl port-forward processes
pkill -f "kubectl port-forward"

kubectl delete --force -f ./