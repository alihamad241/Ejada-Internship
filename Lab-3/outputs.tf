output "vcn_id" {
  description = "OCID of the main VCN"
  value       = oci_core_vcn.main.id
}

output "subnets" {
  description = "Summary of created subnets and their IDs"
  value = {
    api_endpoint  = module.api_endpoint_subnet.subnet_id
    worker_nodes  = module.worker_nodes_subnet.subnet_id
    pods          = module.pod_subnet.subnet_id
    load_balancer = module.load_balancer_subnet.subnet_id
  }
}

output "oke_cluster_id" {
  description = "OCID of the OKE Cluster"
  value       = module.oke.cluster_id
}

output "oke_node_pool_id" {
  description = "OCID of the OKE Node Pool"
  value       = module.oke.node_pool_id
}

output "kubeconfig_command" {
  description = "OCI CLI command to fetch kubeconfig for local kubectl access"
  value       = module.oke.kubeconfig_command
}
