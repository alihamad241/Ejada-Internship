output "vcn_id" {
  value       = oci_core_vcn.main_vcn.id
  description = "OCID of the VCN"
}

output "instance_id" {
  value       = oci_core_instance.linux_instance.id
  description = "OCID of the Linux compute instance"
}

output "instance_public_ip" {
  value       = oci_core_instance.linux_instance.public_ip
  description = "Public IP address of the Linux instance"
}

