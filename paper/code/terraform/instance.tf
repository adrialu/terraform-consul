resource "openstack_compute_instance_v2" "manager" {
  name        = "manager"
  image_name  = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair    = "${openstack_compute_keypair_v2.remote.name}"
  user_data   = "${data.template_cloudinit_config.manager.rendered}"

  security_groups = [
    "${openstack_compute_secgroup_v2.remote.name}",
  ]

  network = {
    uuid = "${openstack_networking_network_v2.manager.id}"
  }
}