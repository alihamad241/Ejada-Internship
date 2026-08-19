output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = oci_containerengine_cluster.this.id
}

output "cluster_name" {
  description = "Name of the OKE cluster"
  value       = oci_containerengine_cluster.this.name
}

output "kubernetes_version" {
  description = "Kubernetes version of the cluster"
  value       = oci_containerengine_cluster.this.kubernetes_version
}

output "node_pool_id" {
  description = "OCID of the node pool"
  value       = try(oci_containerengine_node_pool.this.id, null)
}

output "cluster_endpoints" {
  description = "Endpoints for accessing the Kubernetes API server"
  value       = oci_containerengine_cluster.this.endpoints
}

output "kubeconfig_command" {
  description = "OCI CLI command to generate kubeconfig for the OKE cluster"
  value       = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.this.id} --file ~/.kube/config --region <YOUR_REGION> --token-version 2.0.0"
}
