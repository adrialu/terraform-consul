# set up OpenStack credentials. Any of these can be overridden in the openstack_* resources.
provider "openstack" {
  auth_url          = "${var.os_auth_url}"
  region            = "${var.os_region_name}"
  tenant_id         = "${var.os_project_id}"
  tenant_name       = "${var.os_project_name}"
  user_name         = "${var.os_username}"
  password          = "${var.os_password}"
  user_domain_name  = "${var.os_user_domain_name}"
  project_domain_id = "${var.os_project_domain_id}"
}

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
  source  = "modules/consul"
  router  = "${openstack_networking_router_v2.router.id}"
  keypair = "${openstack_compute_keypair_v2.remote.name}"
}
