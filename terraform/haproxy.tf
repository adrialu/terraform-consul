# create a new haproxy instance
resource "openstack_compute_instance_v2" "haproxy" {
  count       = "${var.haproxy_replicas}"
  name        = "haproxy${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.manager.name}"

  security_groups = [
    "${openstack_compute_secgroup_v2.manager.name}",
    "${openstack_compute_secgroup_v2.consul.name}",
  ]

  network = {
    uuid = "${openstack_networking_network_v2.haproxy.id}"
  }

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.haproxy"]
}

# create the haproxy network
resource "openstack_networking_network_v2" "haproxy" {
  name           = "haproxy-net"
  admin_state_up = "true"
}

# create the haproxy subnet
resource "openstack_networking_subnet_v2" "haproxy" {
  name            = "haproxy-subnet"
  network_id      = "${openstack_networking_network_v2.haproxy.id}"
  cidr            = "${var.haproxy_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the haproxy subnet with the main router
resource "openstack_networking_router_interface_v2" "haproxy" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.haproxy.id}"
}
