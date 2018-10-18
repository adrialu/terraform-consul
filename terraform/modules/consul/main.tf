# create a new Consul instance
resource "openstack_compute_instance_v2" "consul_server" {
  name        = "consul"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${var.keypair}"

  network = {
    # since this is a dependable, Terraform will create the network before the instance
    uuid = "${openstack_networking_network_v2.consul_net.id}"
  }
}

# create the Consul network
resource "openstack_networking_network_v2" "consul_net" {
  name           = "consul-net"
  admin_state_up = "true"
}

# create the Consul subnet
resource "openstack_networking_subnet_v2" "consul_subnet" {
  name            = "consul-subnet"
  network_id      = "${openstack_networking_network_v2.consul_net.id}"
  cidr            = "${var.subnet_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the Consul subnet with the main router
resource "openstack_networking_router_interface_v2" "consul_router_interface" {
  router_id = "${var.router}"
  subnet_id = "${openstack_networking_subnet_v2.consul_subnet.id}"
}
