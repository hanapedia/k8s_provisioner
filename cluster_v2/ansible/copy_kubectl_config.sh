#!/bin/bash
scp HomeLan:/home/hanapedia/.kube/config ~/.kube/new;
cp ~/.kube/config ~/.kube/configs/k8s-v1;
mv ~/.kube/new ~/.kube/config;
