# create a new web instance
resource "openstack_compute_instance_v2" "web" {
  count       = "${var.replicas}"
  name        = "web${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${var.keypair}"

  network = {
    uuid = "${openstack_networking_network_v2.web.id}"
  }

  network = {
    uuid = "${var.management}"
  }

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.web"]
}

# create the web network
resource "openstack_networking_network_v2" "web" {
  name           = "web-net"
  admin_state_up = "true"
}

# create the web subnet
resource "openstack_networking_subnet_v2" "web" {
  name            = "web-subnet"
  network_id      = "${openstack_networking_network_v2.web.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the web subnet with the main router
resource "openstack_networking_router_interface_v2" "web" {
  router_id = "${var.router}"
  subnet_id = "${openstack_networking_subnet_v2.web.id}"
}
