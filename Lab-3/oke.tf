# OKE Cluster & Managed Node Pool Instance
module "oke" {
  source = "./modules/oke"

  compartment_id         = var.compartment_id
  vcn_id                 = oci_core_vcn.main.id
  cluster_name           = var.cluster_name
  kubernetes_version     = var.kubernetes_version
  api_endpoint_subnet_id = module.api_endpoint_subnet.subnet_id
  is_api_endpoint_public = true
  lb_subnet_ids          = [module.load_balancer_subnet.subnet_id]

  node_subnet_id = module.worker_nodes_subnet.subnet_id
  pod_subnet_id  = module.pod_subnet.subnet_id
  availability_domains = [
    data.oci_identity_availability_domains.ads.availability_domains[0].name
  ]

  node_pool_name     = var.node_pool_name
  node_shape         = var.node_shape
  node_ocpus         = var.node_ocpus
  node_memory_in_gbs = var.node_memory_in_gbs
  node_count         = var.node_count
  node_image_id      = var.node_image_id
  ssh_public_key     = var.ssh_public_key
}
