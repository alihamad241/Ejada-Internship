variable "compartment_id" {
  description = "OCID of the compartment where resources will be created"
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID of the tenancy used to resolve availability domains"
  type        = string
}
//used to place my resources in my compartment

variable "region" {
  description = "OCI Region"
  type        = string
  default     = "me-jeddah-1"
}

variable "vcn_cidr_block" {
  description = "CIDR block for VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_shape" {
  description = "Shape of the compute instance"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  description = "Number of OCPUs for flexible shape"
  type        = number
  default     = 1
}

variable "instance_memory" {
  description = "Memory in GB for flexible shape"
  type        = number
  default     = 4
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}

variable "boot_volume_size_in_gbs" {
  description = "Size of the boot volume in GBs"
  type        = number
  default     = 50
}

variable "instance_hostname_label" {
  description = "Hostname label for the compute instance"
  type        = string
  default     = "linux-webserver"
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default     = "linux-webserver"
}

variable "vcn_name" {
  description = "Name of the VCN"
  type        = string
  default     = "main-vcn"
}

variable "vcn_dns_label" {
  description = "DNS label for VCN"
  type        = string
  default     = "mainvcn"
}

variable "public_subnet_dns_label" {
  description = "DNS label for the public subnet"
  type        = string
  default     = "publicsubnet"
}

variable "private_subnet_dns_label" {
  description = "DNS label for the private subnet"
  type        = string
  default     = "privatesubnet"
}

variable "load_balancer_shape" {
  description = "Shape used by the public load balancer"
  type        = string
  default     = "100Mbps"
}

variable "bastion_shape" {
  description = "Shape used by the bastion host"
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "bastion_ocpus" {
  description = "Number of OCPUs for the bastion host"
  type        = number
  default     = 1
}

variable "bastion_memory" {
  description = "Memory in GB for the bastion host"
  type        = number
  default     = 2
}

variable "bastion_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "linux-bastion"
}

variable "bastion_hostname_label" {
  description = "Hostname label for the bastion host"
  type        = string
  default     = "linux-bastion"
}

variable "bastion_ssh_source_cidr" {
  description = "CIDR allowed to SSH into the bastion host"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of public subnet"
  type        = string
  default     = "public-subnet"
}

variable "private_subnet_name" {
  description = "Name of private subnet"
  type        = string
  default     = "private-subnet"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "lab"
}
