// Create a 50GB block volume and attach it to the linux instance

resource "oci_core_volume" "linux_volume" {
  compartment_id     = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name       = "linux-instance-block-volume"
  size_in_gbs        = 50
}

resource "oci_core_volume_attachment" "linux_volume_attach" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.linux_instance.id
  volume_id      = oci_core_volume.linux_volume.id
  display_name   = "linux-volume-attachment"
  attachment_type = "iscsi"

}
