terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

variable "libvirt_uri" {
  description = "uri for libvirt namespace"
  type        = string
  # default     = "qemu+ssh://hanapedia@ubuntuhome/system"
}

variable "namespace" {
  description = "name for libvirt resources"
  type        = string
  # default     = "k8s"
}

variable "resource_version" {
  description = "version for libvirt resources"
  type        = string
  # default     = "k8s"
}

variable "domain" {
  description = "domain name for local dns"
  type        = string
  # default = "k8s.local"
}

variable "network_cidr" {
  description = "cidr block for the network"
  type        = list(string)
  # default     = ["192.168.100.0/24"]
}

resource "libvirt_network" "k8s_network" {
  autostart = true
  name      = "${var.namespace}-${var.resource_version}"
  mode      = "nat"
  domain    = var.domain
  addresses = var.network_cidr
  bridge    = "${var.namespace}-${var.resource_version}"

  dns {
    enabled    = true
    local_only = true
    forwarders {
      address = "8.8.8.8"
    }
    forwarders {
      address = "8.8.4.4"
    }
  }
  dnsmasq_options {
    options {
      option_name  = "server"
      option_value = "/${var.domain}/${cidrhost(var.network_cidr[0], 1)}"
    }
  }
}

resource "libvirt_pool" "k8s_pool" {
  name = "${var.namespace}-${var.resource_version}"
  type = "dir"
  path = pathexpand("~/.kvm/${var.namespace}-${var.resource_version}")
}
