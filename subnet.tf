# Security List for public subnet
resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "public-security-list"

  # Allow SSH
  ingress_security_rules {
    protocol    = "6"  # TCP
    source      = "0.0.0.0/0"
    description = "Allow SSH"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Allow all outbound traffic
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all outbound traffic"
  }
}

# Public Subnet
resource "oci_core_subnet" "public_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main_vcn.id
  cidr_block                 = var.public_subnet_cidr_block
  display_name               = "public-subnet"
  dns_label                  = "publicsubnet"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_route_table.public_route_table.id
  security_list_ids          = [oci_core_security_list.public_security_list.id]

}

