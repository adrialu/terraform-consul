resource "openstack_networking_network_v2" "manager" {
  name           = "manager-net"
  admin_state_up = "true"
}