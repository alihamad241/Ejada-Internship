output "vcn_id" {
  value       = oci_core_vcn.main_vcn.id
  description = "OCID of the VCN"
}

output "private_instance_id" {
  value       = oci_core_instance.private_instance.id
  description = "OCID of the private compute instance"
}

output "private_instance_ip" {
  value       = data.oci_core_vnic.private_instance.private_ip_address
  description = "Private IP address of the compute instance"
}

output "bastion_instance_id" {
  value       = oci_core_instance.bastion_instance.id
  description = "OCID of the bastion host"
}

output "bastion_public_ip" {
  value       = data.oci_core_vnic.bastion_instance.public_ip_address
  description = "Public IP address of the bastion host"
}

output "load_balancer_public_ips" {
  value       = [for ip in oci_load_balancer_load_balancer.app_lb.ip_address_details : ip.ip_address]
  description = "Public IP addresses assigned to the load balancer"
}