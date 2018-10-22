variable "replicas" {
  description = "Number of servers to create"
  default     = "2"
}

variable "image_name" {
  description = "Image name to use for the instances"
  default     = "Ubuntu Server 18.04 LTS (Bionic Beaver) amd64"
}

variable "flavor_name" {
  description = "Flavor name to use for the instances"
  default     = "m1.medium"
}

variable "router" {
  description = "Router to attach the subnet to"
}

variable "subnet_cidr" {
  description = "The address space for the network"
  default     = "192.168.120.0/24"
}

variable "nameservers" {
  description = "The nameservers used by the instances"
  type        = "list"
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "keypair" {
  description = "Key pair to allow access into the instances"
}

variable "management" {
  description = "Management network"
}

variable "secgroup" {
  description = "Default security group to allow"
}
