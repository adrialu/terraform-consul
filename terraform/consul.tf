# create Consul instance(s)
resource "openstack_compute_instance_v2" "consul" {
  count       = "${var.consul_replicas}"
  name        = "consul${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.manager.name}"

  security_groups = [
    "${openstack_compute_secgroup_v2.manager.name}", # defined in manager.tf
    "${openstack_compute_secgroup_v2.consul.name}",
  ]

  network = {
    uuid = "${openstack_networking_network_v2.consul.id}"
  }

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.consul"]
}

# create the Consul network
resource "openstack_networking_network_v2" "consul" {
  name           = "consul-net"
  admin_state_up = "true"
}

# create the Consul subnet
resource "openstack_networking_subnet_v2" "consul" {
  name            = "consul-subnet"
  network_id      = "${openstack_networking_network_v2.consul.id}"
  cidr            = "${var.consul_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the Consul subnet with the main router
resource "openstack_networking_router_interface_v2" "consul" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.consul.id}"
}

# create security group for Consul application communication, only accessible internally
resource "openstack_compute_secgroup_v2" "consul" {
  name        = "consul"
  description = "Consul ports"

  rule {
    from_port   = 8300
    to_port     = 8300
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8301
    to_port     = 8301
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8301
    to_port     = 8301
    ip_protocol = "udp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8302
    to_port     = 8302
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8302
    to_port     = 8302
    ip_protocol = "udp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8400
    to_port     = 8400
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8500
    to_port     = 8500
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8600
    to_port     = 8600
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = 8600
    to_port     = 8600
    ip_protocol = "udp"
    cidr        = "192.168.0.0/16"
  }
}
