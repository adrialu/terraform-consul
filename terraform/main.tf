# create a router that the internal network will use as a gateway
resource "openstack_networking_router_v2" "router" {
  name                = "router1"
  admin_state_up      = "true"
  external_network_id = "${var.os_external_network}"
}

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
