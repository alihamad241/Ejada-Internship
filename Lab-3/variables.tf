variable "compartment_id" {
  description = "OCID of the compartment where resources will be created"
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID of the tenancy"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "me-jeddah-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "lab3"
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "api_endpoint_subnet_cidr" {
  description = "CIDR block for OKE API Endpoint Subnet"
  type        = string
  default     = "10.0.0.0/28"
}

variable "worker_nodes_subnet_cidr" {
  description = "CIDR block for OKE Worker Nodes Subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "pod_subnet_cidr" {
  description = "CIDR block for VCN Native Pod Network Subnet"
  type        = string
  default     = "10.0.32.0/19"
}

variable "lb_subnet_cidr" {
  description = "CIDR block for Public Load Balancer Subnet"
  type        = string
  default     = "10.0.20.0/24"
}

variable "cluster_name" {
  description = "Name of the OKE Cluster"
  type        = string
  default     = "lab3-oke-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for OKE cluster"
  type        = string
  default     = "v1.33.0"
}

variable "node_pool_name" {
  description = "Name of the worker node pool"
  type        = string
  default     = "pool-native-pods"
}

variable "node_shape" {
  description = "Compute shape for OKE worker nodes"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "node_ocpus" {
  description = "Number of OCPUs for worker nodes"
  type        = number
  default     = 2
}

variable "node_memory_in_gbs" {
  description = "Memory in GB for worker nodes"
  type        = number
  default     = 16
}

variable "node_count" {
  description = "Total worker node count"
  type        = number
  default     = 2
}

variable "node_image_id" {
  description = "OCID of Oracle Linux image for OKE worker nodes"
  type        = string
  default     = ""
}

variable "ssh_public_key" {
  description = "SSH public key for worker nodes access"
  type        = string
  default     = ""
}
