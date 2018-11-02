# create an instance, using the network, security groups, key pair and cloud config defined below
resource "openstack_compute_instance_v2" "manager" {
  name        = "manager"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.remote.name}"

  security_groups = [
    "${openstack_compute_secgroup_v2.remote.name}",
    "${openstack_compute_secgroup_v2.consul.name}", # this is defined in consul.tf
  ]

  network = {
    uuid = "${openstack_networking_network_v2.manager.id}"
  }

  user_data = "${data.template_cloudinit_config.manager.rendered}" # defined in main.tf

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.manager"]
}

# create the internal management network
resource "openstack_networking_network_v2" "manager" {
  name           = "manager-net"
  admin_state_up = "true"
}

# create a subnet on the internal management network
resource "openstack_networking_subnet_v2" "manager" {
  name            = "manager-subnet"
  network_id      = "${openstack_networking_network_v2.manager.id}"
  cidr            = "${var.manager_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the manager subnet with the main router
resource "openstack_networking_router_interface_v2" "manager" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.manager.id}"
}

# appropriate a floating IP for the manager instance
resource "openstack_networking_floatingip_v2" "manager" {
  pool = "${var.os_floating_ip_pool}"
}

# associate the floating IP with the manager instance
resource "openstack_compute_floatingip_associate_v2" "manager" {
  floating_ip = "${openstack_networking_floatingip_v2.manager.address}"
  instance_id = "${openstack_compute_instance_v2.manager.0.id}"
}

# create security group for internal access
resource "openstack_compute_secgroup_v2" "manager" {
  name        = "manager"
  description = "Internal access"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "192.168.0.0/16"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "192.168.0.0/16"
  }
}

# create a key pair used for remote access to the manager instance
resource "openstack_compute_keypair_v2" "remote" {
  name       = "remote"
  public_key = "${var.os_keypair}"
}

# create security group for remote access to the manager instance
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
