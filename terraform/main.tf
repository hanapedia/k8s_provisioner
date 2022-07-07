provider "libvirt" {
  uri = "qemu+ssh://hanapedia@ubuntuhome/system"
}

resource "libvirt_network" "ubuntu_network" {
  name = "ubuntu"
  mode = "nat"
  dhcp {
    enabled = true
  }
  addresses = ["192.168.100.0/24"]
  autostart = true
}

resource "libvirt_pool" "ubuntu_pool" {
  name = "ubuntu"
  type = "dir"
  path = var.libvirt_disk_path
}

resource "libvirt_volume" "ubuntu_qcow2" {
  name   = "ubuntu-qcow2"
  pool   = libvirt_pool.ubuntu_pool.name
  source = var.ubuntu_22_img_url
  format = "qcow2"
}
# template_file is deprecated
# data "template_file" "user_data" {
#   template = file("${path.module}/config/cloud_init.yaml")
# }

# template_file is deprecated
# data "template_file" "network_config" {
#   template = file("${path.module}/config/network_config.yaml")
# }

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  pool      = libvirt_pool.ubuntu_pool.name
  user_data = templatefile("${path.module}/config/cloud_init.yaml", {})
  # network_config = templatefile("${path.module}/config/network_config.yaml", {})
}

resource "libvirt_domain" "domain_ubuntu" {
  name   = var.vm_hostname
  memory = "4096"
  vcpu   = 2

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id     = libvirt_network.ubuntu_network.id
    wait_for_lease = true
    hostname       = var.vm_hostname
    addresses      = ["192.168.100.2"]
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2.id
  }
}

output "ips" {
  value = libvirt_domain.domain_ubuntu.*.network_interface.0.addresses
}
