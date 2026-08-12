resource "oci_file_storage_mount_target" "fss_mount_target" {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_id
  subnet_id           = oci_core_subnet.private_subnet.id
  display_name        = local.mount_target_name
  hostname_label      = "${var.environment}-fss-mt"
}

resource "oci_file_storage_export_set" "fss_export_set" {
  display_name    = local.export_set_name
  mount_target_id = oci_file_storage_mount_target.fss_mount_target.id
}

resource "oci_file_storage_file_system" "fss_file_system" {
  availability_domain = local.availability_domain
  compartment_id      = var.compartment_id
  display_name        = local.file_system_name
}

resource "oci_file_storage_export" "fss_export" {
  export_set_id  = oci_file_storage_export_set.fss_export_set.id
  file_system_id = oci_file_storage_file_system.fss_file_system.id
  path           = local.export_path

  export_options {
    source                         = var.private_subnet_cidr_block
    access                         = "READ_WRITE"
    identity_squash                = "NONE"
    require_privileged_source_port = false
    anonymous_uid                  = 0
    anonymous_gid                  = 0
  }
}