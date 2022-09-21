#!/bin/bash
scp HomeLan:/home/hanapedia/.kube/config ~/.kube/new;
cp ~/.kube/config ~/.kube/configs/l;
mv ~/.kube/new ~/.kube/config;
