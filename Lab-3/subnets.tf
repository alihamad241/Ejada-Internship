# 1. API Server Endpoint Subnet (Public)
module "api_endpoint_subnet" {
  source = "./modules/subnet"

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  subnet_name                = "${var.environment}-api-endpoint-subnet"
  cidr_block                 = var.api_endpoint_subnet_cidr
  dns_label                  = "k8sapi"
  prohibit_public_ip_on_vnic = false
  enable_subnet_logs         = true
  log_group_id               = oci_logging_log_group.lab3_log_group.id

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.igw.id
      description       = "Route to Internet Gateway for Public API Endpoint"
    }
  ]

  ingress_rules = [
    {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      description = "External access to Kubernetes API Server"
      tcp_options = {
        min = 6443
        max = 6443
      }
    },
    {
      protocol    = "6" # TCP
      source      = var.worker_nodes_subnet_cidr
      description = "Worker nodes to Kubernetes API Server"
      tcp_options = {
        min = 6443
        max = 6443
      }
    },
    {
      protocol    = "6" # TCP
      source      = var.worker_nodes_subnet_cidr
      description = "Worker nodes to Kubernetes API endpoint service"
      tcp_options = {
        min = 12250
        max = 12250
      }
    }
  ]
}

# 2. Worker Nodes Subnet (Private)
module "worker_nodes_subnet" {
  source = "./modules/subnet"

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  subnet_name                = "${var.environment}-worker-nodes-subnet"
  cidr_block                 = var.worker_nodes_subnet_cidr
  dns_label                  = "k8snodes"
  prohibit_public_ip_on_vnic = true
  enable_subnet_logs         = true
  log_group_id               = oci_logging_log_group.lab3_log_group.id

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.nat.id
      description       = "Route to NAT Gateway for outbound internet access"
    },
    {
      destination       = data.oci_core_services.all_services.services[0].cidr_block
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gw.id
      description       = "Route to Oracle Services Network"
    }
  ]

  ingress_rules = [
    {
      protocol    = "all"
      source      = var.worker_nodes_subnet_cidr
      description = "Allow intra-worker subnet communication"
    },
    {
      protocol    = "all"
      source      = var.pod_subnet_cidr
      description = "Allow communication from pods to worker nodes"
    },
    {
      protocol    = "6" # TCP
      source      = var.api_endpoint_subnet_cidr
      description = "Allow Kubernetes API server to worker kubelet"
      tcp_options = {
        min = 10250
        max = 10250
      }
    },
    {
      protocol    = "all"
      source      = var.lb_subnet_cidr
      description = "Allow Load Balancers to route traffic to worker nodes"
    }
  ]
}

# 3. VCN Native Pod Subnet (Private)
module "pod_subnet" {
  source = "./modules/subnet"

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  subnet_name                = "${var.environment}-pod-subnet"
  cidr_block                 = var.pod_subnet_cidr
  dns_label                  = "k8spods"
  prohibit_public_ip_on_vnic = true
  enable_subnet_logs         = true
  log_group_id               = oci_logging_log_group.lab3_log_group.id

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_nat_gateway.nat.id
      description       = "Outbound route for pods via NAT Gateway"
    },
    {
      destination       = data.oci_core_services.all_services.services[0].cidr_block
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.service_gw.id
      description       = "Route pods to OCI Services Network"
    }
  ]

  ingress_rules = [
    {
      protocol    = "all"
      source      = var.pod_subnet_cidr
      description = "Allow intra-pod network communication"
    },
    {
      protocol    = "all"
      source      = var.worker_nodes_subnet_cidr
      description = "Allow worker nodes to talk to pods"
    },
    {
      protocol    = "all"
      source      = var.lb_subnet_cidr
      description = "Allow Load Balancers to route traffic directly to pods"
    }
  ]
}

# 4. Load Balancer Subnet (Public)
module "load_balancer_subnet" {
  source = "./modules/subnet"

  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.main.id
  subnet_name                = "${var.environment}-lb-subnet"
  cidr_block                 = var.lb_subnet_cidr
  dns_label                  = "k8slb"
  prohibit_public_ip_on_vnic = false
  enable_subnet_logs         = true
  log_group_id               = oci_logging_log_group.lab3_log_group.id

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.igw.id
      description       = "Route to Internet Gateway for public load balancers"
    }
  ]

  ingress_rules = [
    {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      description = "HTTP web traffic"
      tcp_options = {
        min = 80
        max = 80
      }
    },
    {
      protocol    = "6" # TCP
      source      = "0.0.0.0/0"
      description = "HTTPS web traffic"
      tcp_options = {
        min = 443
        max = 443
      }
    }
  ]
}
