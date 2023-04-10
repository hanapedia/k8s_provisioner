#!/bin/bash
scp HomeLan:/home/hanapedia/.kube/config ~/.kube/new;
cp ~/.kube/config ~/.kube/configs/pre_home-cluster;
mv ~/.kube/new ~/.kube/config;
