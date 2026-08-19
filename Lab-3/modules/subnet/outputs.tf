output "subnet_id" {
  description = "OCID of the created subnet"
  value       = oci_core_subnet.this.id
}

output "subnet_cidr" {
  description = "CIDR block of the created subnet"
  value       = oci_core_subnet.this.cidr_block
}

output "route_table_id" {
  description = "OCID of the associated route table"
  value       = oci_core_route_table.this.id
}

output "security_list_id" {
  description = "OCID of the associated security list"
  value       = oci_core_security_list.this.id
}

output "log_id" {
  description = "OCID of the subnet flow log resource (if created)"
  value       = var.enable_subnet_logs ? oci_logging_log.subnet_flow_log[0].id : null
}
