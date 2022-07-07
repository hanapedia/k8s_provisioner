variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvms/"
}

variable "ubuntu_22_img_url" {
  description = "ubuntu 22.04 image"
  default     = "https://cloud-images.ubuntu.com/releases/jammy/release-20220622/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "vm_hostname" {
  description = "vm hostname"
  default     = "terraform-kvm-test"
}

variable "ssh_host" {
  description = "ssh bastion host"
  default     = "HomeLan"
}

variable "ssh_username" {
  description = "ssh user to use"
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "ssh private key to use"
  default     = "~/.ssh/id_rsa"
}
