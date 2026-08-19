variable "compartment_id" {
  description = "OCID of the compartment where subnet resources will be created"
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN"
  type        = string
}

variable "subnet_name" {
  description = "Display name for the subnet and associated resources"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the subnet"
  type        = string
}

variable "dns_label" {
  description = "DNS label for the subnet"
  type        = string
  default     = null
}

variable "prohibit_public_ip_on_vnic" {
  description = "Whether VNICs in this subnet are prohibited from having public IP addresses (true for private subnets)"
  type        = bool
  default     = true
}

variable "enable_subnet_logs" {
  description = "Whether to enable VCN flow log resource for this subnet"
  type        = bool
  default     = true
}

variable "log_group_id" {
  description = "OCID of the OCI logging log group. Required if enable_subnet_logs is true."
  type        = string
  default     = ""
}

variable "route_rules" {
  description = "List of route rules to add to the subnet's route table"
  type = list(object({
    destination       = string
    destination_type  = string
    network_entity_id = string
    description       = optional(string, "")
  }))
  default = []
}

variable "ingress_rules" {
  description = "List of ingress security rules for the security list"
  type = list(object({
    protocol    = string
    source      = string
    source_type = optional(string, "CIDR_BLOCK")
    description = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress security rules for the security list"
  type = list(object({
    protocol         = string
    destination      = string
    destination_type = optional(string, "CIDR_BLOCK")
    description      = optional(string, "")
    tcp_options = optional(object({
      min = number
      max = number
    }), null)
    udp_options = optional(object({
      min = number
      max = number
    }), null)
    icmp_options = optional(object({
      type = number
      code = optional(number, null)
    }), null)
  }))
  default = [
    {
      protocol         = "all"
      destination      = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      description      = "Allow all outbound traffic"
    }
  ]
}
