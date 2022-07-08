variable "libvirt_disk_path" {
  description = "path for libvirt pool"
  default     = "/opt/kvms/"
}

variable "ubuntu_22_img_url" {
  description = "ubuntu 22.04 image"
  default     = "https://cloud-images.ubuntu.com/releases/jammy/release-20220622/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "num_vm_instances" {
  description = "number of vm instances"
  type        = number
  default     = 2

  validation {
    condition     = var.num_vm_instances < 4
    error_message = "The number of instances must be smaller than 4"
  }
}
