# Create and provision k8s cluster
## libvirt resources (./libvirt)
- Creates libvirt network related resources
- Enables subnet dns with dnsmasq
## kvm and k8s cluster init (./cluster)
- Creates kvms with specified roles of loadbalancer, control plane, and worker node
- Installs k8s and joins each control plane and worker node kvm to form a cluster
- Installs calico for cluster networking
## configuration
configure the libvirt resources as ansible variable file and pass its path via extra_vars
### Libvirt configuration
```
libvirt:
  version: v1                                     # versioning for the cluster
  namespace: k8s                                  # namespace used for naming libvirt resources
  uri: "qemu+ssh://hanapedia@ubuntuhome/system"   # virsh uri
  
  network:
    domain: k8s.home                              # local dns domain
    network_cidr:
      - 192.168.100.0/24                          # network cidr block to be used for DHCP
```
### Kvm resource configuration
```
k8s:
  cluster_name: home-cluster # name prefix used for kvms

  control_plane:
    cpu: 2    # number of vcpus for each kvm of the role
    mem: 4    # amount of memory allocated for each kvm of the role
    vms: 2    # number of kvm for the role
    disk: 16  # amount of disk space for each kvm of the role

  node:
    cpu: 2
    mem: 8
    vms: 3
    disk: 24
  
  loadbalancer:
    cpu: 1 
    mem: 4 
    vms: 1 
    disk: 8 
```
### Further configuration for kvm and cluster
any variables in `./cluster/ansible/group_vars/all.yaml` can be overwritten. But use with care.
