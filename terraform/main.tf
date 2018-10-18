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
  external_network_id = "730cb16e-a460-4a87-8c73-50a2cb2293f9" # ntnu-internal
}

# create keypairs for ourselves, from vars
resource "openstack_compute_keypair_v2" "key-adrialu" {
  name       = "adrialu"
  public_key = "${var.os_keys["adrialu"]}"
}

resource "openstack_compute_keypair_v2" "key-vetletm" {
  name       = "vetletm"
  public_key = "${var.os_keys["vetletm"]}"
}
