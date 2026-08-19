# Virtual Cloud Network
resource "oci_core_vcn" "main" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr_block]
  display_name   = "${var.environment}-vcn"
  dns_label      = "lab3vcn"
}

# Internet Gateway (for Public Subnets: API Endpoint & Load Balancer)
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.environment}-igw"
  enabled        = true
}

# NAT Gateway (for Private Subnets: Worker Nodes & Pods)
resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.environment}-nat-gw"
}

# Data source for OCI Services (Oracle Services Network)
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

# Service Gateway (allows private access to OCI services like Block Volumes, Object Storage, Container Registry)
resource "oci_core_service_gateway" "service_gw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.main.id
  display_name   = "${var.environment}-service-gw"

  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}

# OCI Logging Log Group for Subnet Flow Logs
resource "oci_logging_log_group" "lab3_log_group" {
  compartment_id = var.compartment_id
  display_name   = "${var.environment}-log-group"
  description    = "Log Group for Lab 3 Subnet Flow Logs"
}
