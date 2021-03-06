variable "vm_name" {
  description = "name for the vm instance"
  type        = string
}

variable "pool_name" {
  description = "libvirt pool to attach the vm volume"
  type        = string
}

variable "base_img_id" {
  description = "ubuntu 22.04 base image"
  type        = string
}

variable "cloudinit_disk_id" {
  description = "cloud init iso disk id"
  type        = string
}

variable "network_id" {
  description = "libvirt network to attach the vm network interface"
  type        = string
}

variable "network_interface_address" {
  description = "address for the network interface of the vm instance"
  type        = list(string)
}
