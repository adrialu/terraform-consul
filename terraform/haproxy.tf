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
    "${openstack_compute_secgroup_v2.web.name}",
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

# appropriate a floating IP for the haproxy instances
resource "openstack_networking_floatingip_v2" "haproxy" {
  pool = "${var.os_floating_ip_pool}"
}

# associate the floating IP with the haproxy instance
resource "openstack_compute_floatingip_associate_v2" "haproxy" {
  floating_ip = "${openstack_networking_floatingip_v2.haproxy.address}"
  instance_id = "${openstack_compute_instance_v2.haproxy.0.id}"
}

# create security group for HTTP/S access
resource "openstack_compute_secgroup_v2" "web" {
  name        = "web"
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
