resource "libvirt_volume" "ubuntu_qcow2" {
  name   = var.vm_name
  pool   = var.pool_name
  source = var.img_url
  format = "qcow2"
}

resource "libvirt_domain" "ubuntu_domain" {
  name   = var.vm_name
  memory = "4096"
  vcpu   = 2

  cloudinit = var.cloudinit_disk_id

  network_interface {
    network_id     = var.network_id
    wait_for_lease = true
    hostname       = var.vm_name
    addresses      = var.network_interface_address
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

output "ip" {
  value = libvirt_domain.ubuntu_domain.*.network_interface.0.addresses
}
