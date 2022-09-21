terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_volume" "ubuntu_base_img" {
  name   = "ubuntu_base_img"
  pool   = var.cluster_name
  source = var.ubuntu_22_img_url
  format = "qcow2"
}

module "control_plane" {
  count  = var.num_control_plane
  source = "./modules/vm_instance"

  vm_name      = "cp${count.index + 1}"
  cluster_name = var.cluster_name
  base_img_id  = libvirt_volume.ubuntu_base_img.id
  domain       = var.domain
  ssh_keys     = var.ssh_keys
  disk_size    = var.disk_size_cp
  memory       = var.memory_cp
  cpu          = var.cpu_cp
}

module "node" {
  count  = var.num_node
  source = "./modules/vm_instance"

  vm_name      = "node${count.index + 1}"
  cluster_name = var.cluster_name
  base_img_id  = libvirt_volume.ubuntu_base_img.id
  domain       = var.domain
  ssh_keys     = var.ssh_keys
  disk_size    = var.disk_size_n
  memory       = var.memory_n
  cpu          = var.cpu_n
}

module "loadbalancer" {
  source = "./modules/vm_instance"

  vm_name      = "loadbalancer"
  cluster_name = var.cluster_name
  base_img_id  = libvirt_volume.ubuntu_base_img.id
  domain       = var.domain
  ssh_keys     = var.ssh_keys
  disk_size    = var.disk_size_lb
  memory       = var.memory_lb
  cpu          = var.cpu_lb
}

# Inventory file ganeration with raw ip
# deprecated since inventory file generation is handled from ansible with hostname
# resource "local_file" "ansible_inventory" {
#   content = templatefile("${path.module}/templates/inventory.tftpl",
#     {
#       control_plane_ips = flatten(module.control_plane.*.ip)
#       node_ips          = flatten(module.node.*.ip)
#   })
#   filename = "../files/inventory"
# }

output "ip_control_plane" {
  value = module.control_plane.*.ip
}

output "ip_node" {
  value = module.node.*.ip
}
