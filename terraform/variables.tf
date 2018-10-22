variable "os_keypair" {
  description = "Public key pair used to access the manager instances."
}

variable "os_external_network" {
  description = "Network ID to attach the router to"
}

# manager
variable "manager_cidr" {
  description = "Internal management network CIDR"
  default     = "192.168.1.0/24"
}

variable "manager_image" {
  description = "Image used for the manager instance(s)"
  default     = "Ubuntu Server 18.04 LTS (Bionic Beaver) amd64"
}

variable "manager_flavor" {
  description = "Flavor used for the manager instance(s)"
  default     = "m1.micro"
}

# global
variable "nameservers" {
  description = "The nameservers used by all instances"
  type        = "list"
  default     = ["1.1.1.1", "1.0.0.1"]
}
