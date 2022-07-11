variable "ubuntu_22_img_url" {
  description = "ubuntu 22.04 image"
  default     = "https://cloud-images.ubuntu.com/releases/jammy/release-20220622/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "num_control_plane" {
  description = "number of control planes"
  type        = number
  default     = 3

  validation {
    condition     = var.num_control_plane < 5
    error_message = "The number of instances must be smaller than 5"
  }
}

variable "num_node" {
  description = "number of node"
  type        = number
  default     = 3

  validation {
    condition     = var.num_node < 5
    error_message = "The number of instances must be smaller than 5"
  }
}
