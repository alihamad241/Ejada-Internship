data "oci_core_images" "ubuntu_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "private_instance" {
  compartment_id      = var.compartment_id
  display_name        = var.instance_name
  availability_domain = local.availability_domain
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu_images.images[0].id
    source_type = "IMAGE"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    display_name     = "primary-vnic"
    hostname_label   = var.instance_hostname_label
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = base64encode(local.private_instance_cloud_init)
  }
}

data "oci_core_vnic_attachments" "private_instance" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.private_instance.id
}

data "oci_core_vnic" "private_instance" {
  vnic_id = data.oci_core_vnic_attachments.private_instance.vnic_attachments[0].vnic_id
}

resource "oci_core_instance" "bastion_instance" {
  compartment_id      = var.compartment_id
  display_name        = var.bastion_name
  availability_domain = local.availability_domain
  shape               = var.bastion_shape

  shape_config {
    ocpus         = var.bastion_ocpus
    memory_in_gbs = var.bastion_memory
  }

  source_details {
    source_id   = data.oci_core_images.ubuntu_images.images[0].id
    source_type = "IMAGE"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    display_name     = "bastion-vnic"
    hostname_label   = var.bastion_hostname_label
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

data "oci_core_vnic_attachments" "bastion_instance" {
  compartment_id = var.compartment_id
  instance_id    = oci_core_instance.bastion_instance.id
}

data "oci_core_vnic" "bastion_instance" {
  vnic_id = data.oci_core_vnic_attachments.bastion_instance.vnic_attachments[0].vnic_id
}