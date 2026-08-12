variable "compartment_id" {
  description = "OCID of the compartment where resources will be created"
  type        = string
}

variable "tenancy_ocid" {
  description = "OCID of the tenancy used to look up availability domains"
  type        = string
}

variable "region" {
  description = "OCI Region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "vcn_name" {
  description = "Name of the VCN"
  type        = string
}

variable "vcn_dns_label" {
  description = "DNS label for VCN"
  type        = string
}

variable "vcn_cidr_block" {
  description = "CIDR block for VCN"
  type        = string
}

variable "public_subnet_name" {
  description = "Name of public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name of private subnet"
  type        = string
}

variable "public_subnet_dns_label" {
  description = "DNS label for the public subnet"
  type        = string
}

variable "private_subnet_dns_label" {
  description = "DNS label for the private subnet"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for public subnet"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for private subnet"
  type        = string
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
}

variable "instance_hostname_label" {
  description = "Hostname label for the compute instance"
  type        = string
}

variable "instance_shape" {
  description = "Shape of the compute instance"
  type        = string
}

variable "instance_ocpus" {
  description = "Number of OCPUs for flexible shape"
  type        = number
}

variable "instance_memory" {
  description = "Memory in GB for flexible shape"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}

variable "load_balancer_shape" {
  description = "Shape used by the public load balancer"
  type        = string
}

variable "bastion_shape" {
  description = "Shape used by the bastion host"
  type        = string
}

variable "bastion_ocpus" {
  description = "Number of OCPUs for the bastion host"
  type        = number
}

variable "bastion_memory" {
  description = "Memory in GB for the bastion host"
  type        = number
}

variable "bastion_name" {
  description = "Name of the bastion host"
  type        = string
}

variable "bastion_hostname_label" {
  description = "Hostname label for the bastion host"
  type        = string
}

variable "bastion_ssh_source_cidr" {
  description = "CIDR allowed to SSH into the bastion host"
  type        = string
}