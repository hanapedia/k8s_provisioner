provider "libvirt" {
  uri = "qemu+ssh://hanapedia@ubuntuhome/system"
}

resource "libvirt_network" "ubuntu_network" {
  name = "ubuntu"
  mode = "nat"
  # dhcp {
  #   enabled = true
  # }
  addresses = ["192.168.100.0/24"]
  autostart = true
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = libvirt_pool.ubuntu_pool.name
  user_data = templatefile("${path.module}/config/cloud_init.yaml", {})
  # network_config = templatefile("${path.module}/config/network_config.yaml", {})
}

module "vm_ubuntu" {
  count  = var.num_vm_instances
  source = "./modules/vm_instance"

  vm_name                   = "ubuntu_${count.index + 1}"
  pool_name                 = libvirt_pool.ubuntu_pool.name
  cloudinit_disk_id         = libvirt_cloudinit_disk.commoninit.id
  network_id                = libvirt_network.ubuntu_network.id
  network_interface_address = ["192.168.100.${count.index + 2}"]
}

output "ip_ubuntu" {
  value = module.vm_ubuntu.*.ip
}

