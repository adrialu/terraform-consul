# create a new web instance
resource "openstack_compute_instance_v2" "web" {
  count       = "${var.web_replicas}"
  name        = "web${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.manager.name}"

  security_groups = [
    "${openstack_compute_secgroup_v2.manager.name}",
    "${openstack_compute_secgroup_v2.consul.name}",
    "${openstack_compute_secgroup_v2.web.name}",
  ]

  network = {
    uuid = "${openstack_networking_network_v2.web.id}"
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
  cidr            = "${var.web_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the web subnet with the main router
resource "openstack_networking_router_interface_v2" "web" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.web.id}"
}
