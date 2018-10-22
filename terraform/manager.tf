# create a SSH key data type containing locally resourced keys
data "tls_public_key" "manager" {
  private_key_pem = "${file("id_rsa")}"
}

# create a template that runs a script with the SSH keys
data "template_file" "manager_keys" {
  template = "${file("templates/add_keys.sh.tpl")}"

  vars {
    private_key = "${data.tls_public_key.manager.private_key_pem}"
    public_key  = "${data.tls_public_key.manager.public_key_openssh}"
  }
}

# create a cloud-init template using the above script template
data "template_cloudinit_config" "manager" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "add_keys.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.manager_keys.rendered}"
  }
}

# add the keypair to OpenStack for use in other instances
resource "openstack_compute_keypair_v2" "manager" {
  name       = "manager"
  public_key = "${data.tls_public_key.manager.public_key_openssh}"
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

# associate the Manager subnet with the main router
resource "openstack_networking_router_interface_v2" "manager" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.manager.id}"
}

# create the manager instance
resource "openstack_compute_instance_v2" "manager" {
  name            = "manager"
  image_name      = "${var.manager_image}"
  flavor_name     = "${var.manager_flavor}"
  key_pair        = "${openstack_compute_keypair_v2.remote.name}"
  security_groups = ["${openstack_compute_secgroup_v2.remote.name}"]

  network = {
    uuid = "${openstack_networking_network_v2.manager.id}"
  }

  user_data = "${data.template_cloudinit_config.manager.rendered}"

  # terraform is not smart enough to realize we need a subnet first
  depends_on = ["openstack_networking_subnet_v2.manager"]
}

# appropriate a floating IP for the manager instance
resource "openstack_networking_floatingip_v2" "manager" {
  pool = "ntnu-internal"
}

# associate the floating IP with the manager instance
resource "openstack_compute_floatingip_associate_v2" "manager" {
  floating_ip = "${openstack_networking_floatingip_v2.manager.address}"
  instance_id = "${openstack_compute_instance_v2.manager.0.id}"
}

# create security group for internal access
resource "openstack_compute_secgroup_v2" "manager" {
  name        = "manager"
  description = "Internal SSH access"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "192.168.1.0/24"
  }
}
