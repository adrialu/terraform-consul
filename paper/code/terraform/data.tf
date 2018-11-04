data "tls_public_key" "manager" {
  private_key_pem = "${file("id_rsa")}"
}

data "template_file" "manager_keys" {
  template = "${file("templates/add_keys.sh.tpl")}"

  vars {
    private_key = "${data.tls_public_key.manager.private_key_pem}"
    public_key  = "${data.tls_public_key.manager.public_key_openssh}"
  }
}

data "template_cloudinit_config" "manager" {
  part {
    filename     = "add_keys.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.manager_keys.rendered}"
  }
}