# Virtual Cloud Network
resource "oci_core_vcn" "main_vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_block]
  display_name   = "ali-lab1-vcn"
  dns_label      = "alilab1vcn"
}

# Internet Gateway
resource "oci_core_internet_gateway" "main_igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "main-igw"
  enabled        = true
}

# Route Table for Public Subnet
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main_vcn.id
  display_name   = "public-route-table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.main_igw.id
    description       = "Route to Internet Gateway"
  }
}

