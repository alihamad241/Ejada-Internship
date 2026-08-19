variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN"
  type        = string
}

variable "cluster_name" {
  description = "Name of the OKE Cluster"
  type        = string
  default     = "lab3-oke-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "v1.33.0"
}

variable "api_endpoint_subnet_id" {
  description = "OCID of the subnet for Kubernetes API endpoint"
  type        = string
}

variable "is_api_endpoint_public" {
  description = "Whether the Kubernetes API endpoint has a public IP"
  type        = bool
  default     = true
}

variable "lb_subnet_ids" {
  description = "List of subnet OCIDs for Kubernetes Load Balancers"
  type        = list(string)
}

variable "node_subnet_id" {
  description = "OCID of the private subnet for worker nodes"
  type        = string
}

variable "pod_subnet_id" {
  description = "OCID of the private subnet for VCN-native pod networking"
  type        = string
}

variable "availability_domains" {
  description = "List of Availability Domains for node placement"
  type        = list(string)
}

variable "node_pool_name" {
  description = "Name of the OKE node pool"
  type        = string
  default     = "np-standard"
}

variable "node_shape" {
  description = "Shape of worker nodes"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "node_ocpus" {
  description = "Number of OCPUs for flexible shape"
  type        = number
  default     = 2
}

variable "node_memory_in_gbs" {
  description = "Memory in GB for flexible shape"
  type        = number
  default     = 16
}

variable "node_count" {
  description = "Number of worker nodes in the node pool"
  type        = number
  default     = 2
}

variable "node_image_id" {
  description = "OCID of the worker node image"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for worker nodes"
  type        = string
  default     = null
}
