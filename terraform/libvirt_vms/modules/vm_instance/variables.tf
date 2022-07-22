variable "vm_name" {
  description = "name for the vm instance"
  type        = string
}

variable "cluster_name" {
  description = "libvirt pool to attach the vm volume"
  type        = string
}

variable "base_img_id" {
  description = "ubuntu 22.04 base image"
  type        = string
}

variable "disk_size" {
  description = "amount of disk size"
  type        = number
  # default     = 8
}

variable "memory" {
  description = "amount of vmemory"
  type        = number
  # default     = 2
}

variable "cpu" {
  description = "number of vcpus"
  type        = number
  # default     = 2
}

# variable "cloudinit_disk_id" {
#   description = "cloud init iso disk id"
#   type        = string
# }
#
# variable "network_name" {
#   description = "libvirt network to attach the vm network interface"
#   type        = string
# }
variable "domain" {
  description = "domain name for the local dns"
  type        = string
}

variable "ssh_keys" {
  description = "authorized ssh keys"
  type        = list(string)
}

# variable "network_interface_address" {
#   description = "address for the network interface of the vm instance"
#   type        = list(string)
# }
