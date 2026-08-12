output "vcn_id" {
  value       = module.lab2.vcn_id
  description = "OCID of the VCN"
}

output "private_instance_id" {
  value       = module.lab2.private_instance_id
  description = "OCID of the private compute instance"
}

output "private_instance_ip" {
  value       = module.lab2.private_instance_ip
  description = "Private IP address of the compute instance"
}

output "bastion_instance_id" {
  value       = module.lab2.bastion_instance_id
  description = "OCID of the bastion host"
}

output "bastion_public_ip" {
  value       = module.lab2.bastion_public_ip
  description = "Public IP address of the bastion host"
}

output "load_balancer_public_ips" {
  value       = module.lab2.load_balancer_public_ips
  description = "Public IP addresses assigned to the load balancer"
}