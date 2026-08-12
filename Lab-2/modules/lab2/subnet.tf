resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = local.public_security_list_name

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow inbound HTTP traffic to the load balancer"

    tcp_options {
      min = local.listener_port
      max = local.listener_port
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.bastion_ssh_source_cidr
    description = "Allow SSH access to the bastion host"

    tcp_options {
      min = 22
      max = 22
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = local.private_security_list_name

  ingress_security_rules {
    protocol    = "6"
    source      = var.public_subnet_cidr_block
    description = "Allow application traffic from the public subnet"

    tcp_options {
      min = local.app_port
      max = local.app_port
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.public_subnet_cidr_block
    description = "Allow SSH access from the bastion subnet"

    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = var.private_subnet_cidr_block
    description = "Allow NFS traffic inside the private subnet"

    tcp_options {
      min = local.nfs_port
      max = local.nfs_port
    }
  }

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
}

resource "oci_core_subnet" "public_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main_vcn.id
  cidr_block                 = var.public_subnet_cidr_block
  display_name               = var.public_subnet_name
  dns_label                  = var.public_subnet_dns_label
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids          = [oci_core_security_list.public_security_list.id]
}

resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main_vcn.id
  cidr_block                 = var.private_subnet_cidr_block
  display_name               = var.private_subnet_name
  dns_label                  = var.private_subnet_dns_label
  prohibit_public_ip_on_vnic = true
  route_table_id             = oci_core_route_table.private_route_table.id
  security_list_ids          = [oci_core_security_list.private_security_list.id]
}