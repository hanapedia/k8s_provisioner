variable "libvirt_uri" {
  description = "uri for libvirt namespace"
  type        = string
  # default     = "qemu+ssh://hanapedia@ubuntuhome/system"
}

variable "domain" {
  description = "domain name for local dns"
  type        = string
  # default = "k8s.local"
}

variable "cluster_name" {
  description = "name of the k8s cluster"
  type        = string
  # default     = "k8s"
}

variable "ubuntu_22_img_url" {
  description = "ubuntu 22.04 image"
  type        = string
  # default     = "https://cloud-images.ubuntu.com/releases/jammy/release-20220622/ubuntu-22.04-server-cloudimg-amd64.img"
}

variable "ssh_keys" {
  description = "authorized ssh keys"
  type        = list(string)
  # default = [
  #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCVDhT/P9zxI4ypW39uNYbkcl5kadudwPcJDdnCK1s5oURgNlmPpRtHP3l2Bfp2v4kd35PyQGXWA9xlK+oud5sILV04R1I0/lmr2p6HPO9lfhFuHxm+irXiJdkCdv9ymw7jrYSQPQy/Wv29pwSEVgha2OZnyUh7jsPw1XGVlv4ZjJxkYa/fRm2ERikz/2Qg7vCVRUoz8kAqVRgp+Ra5wR4WMY8XmF0b8vaucaV/vcCRV1w2/KQ9Vg5EHwkmZXRktSAiEMe/7a53ox4ADSY/hehR0bwEYBHcx93vUdOMztkQhW5AzJeqcbkc6jS0mBhU1HEmi1HFEVYP0sAGoIoQKrB/Un3hVt81B+xpZZVKFyoi7B56eZqEBfTf+bBlxWMpGcYjYO8AHzzT7tn7NM+0hvxATqdLGgt0/PryttW4W5FMKvJ+3t8VLO+RswwcDlgkPwIKkFLQV/ThXqBy7fZSL2hrlVN1xwLIgz8Z1mOaezHO+A+TQIkOjQG/jTx/f/aK4b9Pd0U2gyYMv7mKG+o84tSY0gU+geWtBhZKrg8r8iWGnhKJlYlZvISSUl1499svE1t1WSt4wOP+1B/LFJyk/1i9jXOfqYGiR5MHeBY6PXpjW/PkdSRudOIJ+4gkXdGIXTu41uIm5XLCIF5H9JHV6IgulurGia6Hp60omc6WG+gSUw== Hiroki macbook air",
  #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDMrBQUa4iADNPo3q/AQjpQyt1GFsdYKEW9Hd8kC478o3G4UbpuempbF/TlLixp/5tusMQjV9n/8kMJF1kj4lrsFHShftd7+ZXvUKkny8vEOF7aj79j3V9nYFPJ4NFIuJdzPsdfBG51DaT3wbossCEZshfNMc9iBISSLbSwDi6rwxCZX75GvQlMOR5TZSOXe7exj/28QSkyI9hcCbnbK0JG6Kabcxh1ZFAX/BwxDv/ywShWNbM2Y66KbO0BcjQjRPPgEIE05nW7C5Q0K5XJ5DAWHFzdACQakkRUuWXFrNS7ptZSIBY5BKryc0jq0JJinnmoAkMuEKCwUBIVa+5C4EokAM+ICTTaf6kWzWeraueZ4czFUdS5F7R6G/YNP6yTwmx2Y07lLt3m9EijxM8VTDgYsSS2R4yP8KGC1cof7W/Ia+8ZYdPR8Yg/QwfV+OP4CQELaIG1YvZldMJ1KUUsrkFNZ9cNbVtQIL2VLhw/P+PtOBlKgpESE+NvYDG7+3cImTk= hiroki11hanada@gmail.com"
  # ]
}

variable "num_control_plane" {
  description = "number of control planes"
  type        = number
  # default     = 3

  validation {
    condition     = var.num_control_plane < 5
    error_message = "The number of instances must be smaller than 5"
  }
}

variable "disk_size_cp" {
  description = "disk size for cp vm"
  type = number
}

variable "memory_cp" {
  description = "memory for cp vm"
  type = number
}

variable "cpu_cp" {
  description = "cpus for cp vm"
  type = number
}

variable "num_node" {
  description = "number of node"
  type        = number
  # default     = 3

  validation {
    condition     = var.num_node < 5
    error_message = "The number of instances must be smaller than 5"
  }
}

variable "disk_size_n" {
  description = "disk size for node vm"
  type = number
}

variable "memory_n" {
  description = "memory for node vm"
  type = number
}

variable "cpu_n" {
  description = "cpus for node vm"
  type = number
}

