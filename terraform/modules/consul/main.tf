# create a new Consul instance
resource "openstack_compute_instance_v2" "consul" {
  count           = "${var.replicas}"
  name            = "consul${count.index+1}"
  image_name      = "${var.image_name}"
  flavor_name     = "${var.flavor_name}"
  key_pair        = "${var.keypair}"
  security_groups = ["${var.secgroup}"]

  network = {
    uuid = "${openstack_networking_network_v2.consul.id}"
  }

  network = {
    uuid = "${var.management}"
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
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the Consul subnet with the main router
resource "openstack_networking_router_interface_v2" "consul" {
  router_id = "${var.router}"
  subnet_id = "${openstack_networking_subnet_v2.consul.id}"
}
