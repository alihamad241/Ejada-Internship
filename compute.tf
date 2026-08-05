# Get availability domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# User data script for Nginx
locals {
  user_data_script = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Welcome to OCI Linux Instance - Deployed by Terraform</h1>" > /var/www/html/index.html
              EOF
  )
}

# Linux Compute Instance
resource "oci_core_instance" "linux_instance" {
  compartment_id      = var.compartment_id
  display_name        = "linux-webserver"
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = var.instance_shape

  # Shape configuration for flexible shapes
  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory
  }

  # Source image
  source_details {
    source_id   = var.instance_image_id
    source_type = "IMAGE"
  }

  # Network configuration
  create_vnic_details {
    subnet_id                 = oci_core_subnet.public_subnet.id
    display_name              = "primary-vnic"
    assign_public_ip          = true
    skip_source_dest_check    = false
  }

  # SSH key and user data
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = local.user_data_script
  }
}
