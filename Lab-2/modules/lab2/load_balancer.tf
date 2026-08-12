resource "oci_load_balancer_load_balancer" "app_lb" {
  compartment_id = var.compartment_id
  display_name   = local.load_balancer_name
  shape          = var.load_balancer_shape
  subnet_ids     = [oci_core_subnet.public_subnet.id]
}

resource "oci_load_balancer_backend_set" "app_backend_set" {
  name             = local.backend_set_name
  load_balancer_id = oci_load_balancer_load_balancer.app_lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "HTTP"
    port              = local.app_port
    url_path          = "/"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
}

resource "oci_load_balancer_listener" "app_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.app_lb.id
  name                     = local.listener_name
  default_backend_set_name = oci_load_balancer_backend_set.app_backend_set.name
  port                     = local.listener_port
  protocol                 = "HTTP"
}

resource "oci_load_balancer_backend" "app_backend" {
  load_balancer_id = oci_load_balancer_load_balancer.app_lb.id
  backendset_name  = oci_load_balancer_backend_set.app_backend_set.name
  ip_address       = data.oci_core_vnic.private_instance.private_ip_address
  port             = local.app_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}