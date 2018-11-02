variable "os_keypair" {
  description = "Public key pair used to access the manager instances."
}

variable "os_external_network" {
  description = "Network ID to attach the router to"
}

variable "os_floating_ip_pool" {
  description = "Name of the floating IP pool on OpenStack"
}

# global
variable "nameservers" {
  description = "The nameservers used by all instances"
  type        = "list"
  default     = ["1.1.1.1", "1.0.0.1"]
}

variable "image_name" {
  description = "Image used for the manager instance(s)"
  default     = "Ubuntu IaC Python"
}

variable "flavor_name" {
  description = "Flavor used for the manager instance(s)"
  default     = "m1.small"
}

# manager
variable "manager_cidr" {
  description = "Internal management network CIDR"
  default     = "192.168.1.0/24"
}

# consul
variable "consul_replicas" {
  description = "Number of servers to create"
  default     = "3"
}

variable "consul_cidr" {
  description = "Internal consul network CIDR"
  default     = "192.168.100.0/24"
}

# proxy
variable "proxy_replicas" {
  description = "Number of servers to create"
  default     = "1"
}

variable "proxy_cidr" {
  description = "Internal network CIDR"
  default     = "192.168.120.0/24"
}

# web
variable "web_replicas" {
  description = "Number of servers to create"
  default     = "3"
}

variable "web_cidr" {
  description = "Internal consul network CIDR"
  default     = "192.168.110.0/24"
}
