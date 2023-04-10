resource "libvirt_volume" "ubuntu_qcow2" {
  name           = var.vm_name
  pool           = var.namespace
  base_volume_id = var.base_img_id
  size           = var.disk_size * 1073741824
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "${var.vm_name}_commoninit.iso"
  pool = var.namespace
  user_data = templatefile("${path.module}/templates/cloud_init.tftpl",
    {
      hostname = "${var.vm_name}.${var.domain}"
      fqdn     = "${var.vm_name}.${var.domain}"
      ssh_keys = var.ssh_keys
    }
  )
}


resource "libvirt_domain" "ubuntu_domain" {
  name      = var.vm_name
  memory    = var.memory * 1024
  vcpu      = var.cpu
  autostart = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name   = var.namespace
    wait_for_lease = true
    hostname = "${var.vm_name}"
    #   addresses      = var.network_interface_address
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_qcow2.id
  }
}

output "ip" {
  value = libvirt_domain.ubuntu_domain.network_interface.0.addresses
}
