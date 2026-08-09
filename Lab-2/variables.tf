variable "compartment_id" {
  description = "OCID of the compartment where resources will be created"
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

variable "instance_image_id" {
  description = "Image OCID for Ubuntu 22.04 LTS"
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
  default = "linux-webserver"
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
  default = "linux-webserver"
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
