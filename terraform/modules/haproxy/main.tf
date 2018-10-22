# create a new haproxy instance
resource "openstack_compute_instance_v2" "haproxy_server" {
  count       = "${var.replicas}"
  name        = "haproxy${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${var.keypair}"

  network = {
    # since this is a dependable, Terraform will create the network before the instance
    uuid = "${openstack_networking_network_v2.haproxy_net.id}"
  }

  network = {
    uuid = "${var.management}"
  }

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.haproxy"]
}

# create the haproxy network
resource "openstack_networking_network_v2" "haproxy_net" {
  name           = "haproxy-net"
  admin_state_up = "true"
}

# create the haproxy subnet
resource "openstack_networking_subnet_v2" "haproxy_subnet" {
  name            = "haproxy-subnet"
  network_id      = "${openstack_networking_network_v2.haproxy_net.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"

  depends_on = ["openstack_networking_network_v2.haproxy_net"]
}

# associate the haproxy subnet with the main router
resource "openstack_networking_router_interface_v2" "haproxy_router_interface" {
  router_id = "${var.router}"
  subnet_id = "${openstack_networking_subnet_v2.haproxy_subnet.id}"

  depends_on = ["openstack_networking_subnet_v2.haproxy_subnet"]
}
