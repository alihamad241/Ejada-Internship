# Fetch supported node pool options for the OKE cluster
data "oci_containerengine_node_pool_option" "this" {
  node_pool_option_id = oci_containerengine_cluster.this.id
  compartment_id      = var.compartment_id
}

locals {
  # All source images supported by this OKE cluster
  supported_sources = data.oci_containerengine_node_pool_option.this.sources

  # Filter genuine OKE-baked Oracle Linux 8 x86 images (compatible with VM.Standard.E4.Flex)
  ol8_oke_x86_images = [
    for s in local.supported_sources : s
    if s.source_name != null &&
       length(regexall("Oracle-Linux-8", s.source_name)) > 0 &&
       length(regexall("-OKE-", s.source_name)) > 0 &&
       length(regexall("aarch64|GPU", s.source_name)) == 0
  ]

  # Selected OKE worker image
  selected_source = length(local.ol8_oke_x86_images) > 0 ? local.ol8_oke_x86_images[0] : local.supported_sources[0]

  # Extract embedded version string (e.g., "1.32.10" from "Oracle-Linux-8.10-2026.02.28-0-OKE-1.32.10-1392")
  raw_version_matches = length(regexall("1\\.[0-9]{2}\\.[0-9]+", local.selected_source.source_name)) > 0 ? regexall("1\\.[0-9]{2}\\.[0-9]+", local.selected_source.source_name) : []

  # Formatted version string for node pool (e.g., "v1.32.10")
  extracted_node_version = length(local.raw_version_matches) > 0 ? "v${local.raw_version_matches[0]}" : var.kubernetes_version

  node_image_id    = (var.node_image_id == null || var.node_image_id == "" || var.node_image_id == "AUTO") ? local.selected_source.image_id : var.node_image_id
  node_k8s_version = (var.node_image_id == null || var.node_image_id == "" || var.node_image_id == "AUTO") ? local.extracted_node_version : var.kubernetes_version
}

# Resource 1: OKE Cluster
resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  kubernetes_version = var.kubernetes_version

  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }

  endpoint_config {
    is_public_ip_enabled = var.is_api_endpoint_public
    subnet_id            = var.api_endpoint_subnet_id
  }

  options {
    service_lb_subnet_ids = var.lb_subnet_ids

    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
  }
}

# Resource 2: Node Pool (Managed Worker Nodes with VCN Native Pod Network)
resource "oci_containerengine_node_pool" "this" {
  cluster_id         = oci_containerengine_cluster.this.id
  compartment_id     = var.compartment_id
  name               = var.node_pool_name
  node_shape         = var.node_shape
  kubernetes_version = local.node_k8s_version

  dynamic "node_shape_config" {
    for_each = var.node_ocpus != null && var.node_memory_in_gbs != null ? [1] : []
    content {
      ocpus         = var.node_ocpus
      memory_in_gbs = var.node_memory_in_gbs
    }
  }

  node_source_details {
    source_type = "IMAGE"
    image_id    = local.node_image_id
  }

  node_config_details {
    size = var.node_count

    dynamic "placement_configs" {
      for_each = var.availability_domains
      content {
        availability_domain = placement_configs.value
        subnet_id           = var.node_subnet_id
      }
    }

    node_pool_pod_network_option_details {
      cni_type       = "OCI_VCN_IP_NATIVE"
      pod_subnet_ids = [var.pod_subnet_id]
    }
  }

  ssh_public_key = var.ssh_public_key
}
