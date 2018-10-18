variable "replicas" {
  description = "Number of servers to create"
  default     = "3"
}

variable "image_name" {
  description = "Name of image to use for Consul servers"
  default     = "Ubuntu Server 18.04 LTS (Bionic Beaver) amd64"
}

variable "flavor_name" {
  description = "Name of flavor to use for Consul servers"
  default     = "m1.medium"
}

variable "router" {
  description = "Router to attach the subnet to"
}

variable "subnet_cidr" {
  description = "The address space for the Consul network"
  default = "192.168.100.0/24"
}

variable "nameservers" {
  description = "The nameservers used by the Consul network"
  type    = "list"
  default = ["1.1.1.1", "1.0.0.1"]
}

variable "keypair" {
  description = "Key pair to allow access into the Consul instances"
}
