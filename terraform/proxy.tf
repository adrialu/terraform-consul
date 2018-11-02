# create instance(s)
resource "openstack_compute_instance_v2" "proxy" {
  count       = "${var.proxy_replicas}"
  name        = "proxy${count.index+1}"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.manager.name}"

  security_groups = [
    "${openstack_compute_secgroup_v2.manager.name}", # defined in manager.tf
    "${openstack_compute_secgroup_v2.consul.name}",  # defined in consul.tf
    "${openstack_compute_secgroup_v2.http.name}",    # defined below
  ]

  network = {
    uuid = "${openstack_networking_network_v2.proxy.id}"
  }

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.proxy"]
}

# create network
resource "openstack_networking_network_v2" "proxy" {
  name           = "proxy-net"
  admin_state_up = "true"
}

# create subnet
resource "openstack_networking_subnet_v2" "proxy" {
  name            = "proxy-subnet"
  network_id      = "${openstack_networking_network_v2.proxy.id}"
  cidr            = "${var.proxy_cidr}"
  ip_version      = 4
  enable_dhcp     = "true"
  dns_nameservers = "${var.nameservers}"
}

# associate the subnet with the main router
resource "openstack_networking_router_interface_v2" "proxy" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.proxy.id}"
}

# appropriate a floating IP for the instance
resource "openstack_networking_floatingip_v2" "proxy" {
  pool = "${var.os_floating_ip_pool}"
}

# associate the floating IP with the instance
resource "openstack_compute_floatingip_associate_v2" "proxy" {
  floating_ip = "${openstack_networking_floatingip_v2.proxy.address}"
  instance_id = "${openstack_compute_instance_v2.proxy.0.id}"
}

# create security group for external HTTP access
resource "openstack_compute_secgroup_v2" "http" {
  name        = "http"
  description = "HTTP/S access"

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
