# set up OpenStack provider, using credentials from the environment
provider "openstack" {}

# create a router for our network
resource "openstack_networking_router_v2" "router" {
  name                = "router1"
  admin_state_up      = "true"
  external_network_id = "${var.os_external_network}"
}

# create keypair
resource "openstack_compute_keypair_v2" "remote" {
  name       = "remote"
  public_key = "${var.os_keypair}"
}

# create security group for remote access
resource "openstack_compute_secgroup_v2" "remote" {
  name        = "remote"
  description = "SSH access"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# use modules to segregate the project a bit
module "consul" {
  source     = "modules/consul"
  router     = "${openstack_networking_router_v2.router.id}"
  keypair    = "${openstack_compute_keypair_v2.manager.name}"
  management = "${openstack_networking_network_v2.manager.id}"
}

module "web" {
  source     = "modules/web"
  router     = "${openstack_networking_router_v2.router.id}"
  keypair    = "${openstack_compute_keypair_v2.manager.name}"
  management = "${openstack_networking_network_v2.manager.id}"
}

module "haproxy" {
  source     = "modules/haproxy"
  router     = "${openstack_networking_router_v2.router.id}"
  keypair    = "${openstack_compute_keypair_v2.manager.name}"
  management = "${openstack_networking_network_v2.manager.id}"
}
