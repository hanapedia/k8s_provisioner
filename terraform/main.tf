provider "libvirt" {
  uri = "qemu+ssh://hanapedia@ubuntuhome/system"
}

resource "libvirt_network" "k8s_network" {
  name = "k8s_network"
  mode = "nat"
  # dhcp {
  #   enabled = true
  # }
  addresses = ["192.168.100.0/24"]
  autostart = true
  dns {
    forwarders {
      address = "8.8.8.8"
    }
  }
}

resource "libvirt_pool" "k8s_pool" {
  name = "k8s_pool"
  type = "dir"
  path = pathexpand("~/.kvm")
}

resource "libvirt_volume" "ubuntu_base_img" {
  name   = "ubuntu_base_img"
  pool   = libvirt_pool.k8s_pool.name
  source = "https://cloud-images.ubuntu.com/releases/jammy/release-20220622/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = libvirt_pool.k8s_pool.name
  user_data = templatefile("${path.module}/configs/cloud_init.yaml", {})
  # network_config = templatefile("${path.module}/config/network_config.yaml", {})
}

module "control_plane" {
  count  = var.num_control_plane
  source = "./modules/vm_instance"

  vm_name                   = "control_plane_${count.index + 1}"
  pool_name                 = libvirt_pool.k8s_pool.name
  base_img_id               = libvirt_volume.ubuntu_base_img.id
  cloudinit_disk_id         = libvirt_cloudinit_disk.commoninit.id
  network_id                = libvirt_network.k8s_network.id
  network_interface_address = ["192.168.100.${count.index + 2}"]
}

module "node" {
  count  = var.num_node
  source = "./modules/vm_instance"

  vm_name                   = "node_${count.index + 1}"
  pool_name                 = libvirt_pool.k8s_pool.name
  base_img_id               = libvirt_volume.ubuntu_base_img.id
  cloudinit_disk_id         = libvirt_cloudinit_disk.commoninit.id
  network_id                = libvirt_network.k8s_network.id
  network_interface_address = ["192.168.100.${count.index + 10}"]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl",
    {
      control_plane_ips = module.control_plane.*.ip
      node_ips          = module.node.*.ip
  })
  filename = "inventory"
}

output "ip_control_plane" {
  value = module.control_plane.*.ip
}

output "ip_node" {
  value = module.node.*.ip
}
