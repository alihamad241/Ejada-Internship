# Comprehensive Project Documentation

---

## 1. Merged Files Description

This document consolidates information from the following three files:
- **`README.md`**: Provides the step-by-step execution guide, high-level architecture overview, deliverables checklist, and verification outputs.
- **`APP_DEPENDENCY_ASSESSMENT.md`**: Outlines the source application’s dependencies, runtime requirements, network security configurations, and the target OCI architecture.
- **`FILE_STRUCTURE_GUIDE.md`**: Details the purpose and structure of the Terraform modules (`subnet`, `oke`), Kubernetes manifests, and root configuration files.

---

## 2. Target OCI Architecture

The target architecture is a production-grade, highly available Oracle Kubernetes Engine (OKE) setup designed using reusable Terraform modules.

```text
+---------------------------------------------------------------------------------------------------+
| OCI Region: me-jeddah-1 (VCN: 10.0.0.0/16)                                                        |
|                                                                                                   |
|  +------------------------+                +--------------------------------------------------+  |
|  | Public LB Subnet       |                | API Endpoint Subnet (Public)                     |  |
|  | (10.0.20.0/24)         |                | (10.0.0.0/28)                                    |  |
|  | +--------------------+ |                | +----------------------------------------------+ |  |
|  | | OCI Load Balancer  | |                | | Kubernetes Control Plane API (v1.33.0)        | |  |
|  | | (IP: 79.72.5.99)   | |                | +----------------------+-----------------------+ |  |
|  | +---------+----------+ |                                         |                         |  |
|  +-----------|------------+                                         | K8s API                 |  |
|              | HTTP (Port 80) / HTTPS (Port 443)                    |                         |  |
|              v                                                      v                         |  |
|  +----------------------------------------------------------------------------------------------+ |
|  | Private Worker Subnet (10.0.10.0/24) & Dedicated Pod Subnet (10.0.32.0/19)                 | |
|  |                                                                                              | |
|  |  +----------------------------------------------------------------------------------------+  | |
|  |  | Managed Worker Node Pool (2x VM.Standard.E4.Flex - 2 OCPU / 16GB RAM)                 |  | |
|  |  |                                                                                        |  | |
|  |  |  +-------------------------------------+      +-------------------------------------+  |  |
|  |  |  | Node 1 (10.0.10.114)                |      | Node 2 (10.0.10.40)                 |  |  |
|  |  |  | Pod (IP: 10.0.35.169)               |      | NGINX App Container                 |  |  |
|  |  |  +------------------+------------------+      +------------------+------------------+  |  |
|  |  +---------------------|--------------------------------------------|---------------------+  | |
|  +------------------------|--------------------------------------------|------------------------+ |
|                           |                                            |                          |
|                           +---------------------+----------------------+                          |
|                                                 | OCI CSI Volume Driver                           |
|                                                 v                                                 |
|                           +--------------------------------------------+                          |
|                           | OCI Block Volume (50Gi PVC - RWO)          |                          |
|                           +--------------------------------------------+                          |
+---------------------------------------------------------------------------------------------------+
```

### Key Architectural Highlights
1. **Network Segregation**: 4 subnets (`api_endpoint`, `worker_nodes`, `pod_subnet`, `load_balancer`) isolated using strict Security Lists.
2. **VCN-Native Pod Networking**: Pods receive native IP addresses directly from the OCI VCN CIDR (`OCI_VCN_IP_NATIVE`).
3. **CSI Block Volume Persistence**: PersistentVolumeClaim backed by the OCI CSI Block Volume driver.
4. **OCI Registry Integration**: Private image repository hosting the containerized web application image.

---

## 3. Application Dependencies Assessment

### Runtime & Dependency Matrix
| Layer | Component | Requirement / Specification | Purpose |
| :--- | :--- | :--- | :--- |
| **Web Server** | NGINX | `>= 1.25.0 (Alpine Linux)` | Serving HTTP requests and static asset hosting. |
| **Runtime Container** | Docker Engine | `>= 24.0.0` / OCI Runtime | Container isolation and image packaging. |
| **Port Bindings** | TCP 80 / TCP 443 | Exposed internal port 80 | Receiving web traffic from Kubernetes Load Balancer. |
| **Persistent Storage**| OCI CSI Volume | `50Gi` Paravirtualized Block Vol | Mounted at `/usr/share/nginx/html`. |

---

## 4. Terraform Modules Documentation

### A. Subnet Module (`modules/subnet`)
* **What the module does**: It is a reusable, dynamic module designed to encapsulate a VCN Subnet, Route Table, Security List, and optional VCN Flow Logs. It eliminates duplicate networking code.
* **Input**:
  - `compartment_id`, `vcn_id`: Core identifiers.
  - `subnet_name`, `cidr_block`, `dns_label`: Subnet configuration.
  - `prohibit_public_ip_on_vnic`: Toggle for public vs. private access.
  - `enable_subnet_logs`, `log_group_id`: VCN Flow Log configuration.
  - `route_rules`, `ingress_rules`, `egress_rules`: Lists of dynamic rule objects.
* **Output**:
  - `subnet_id`, `subnet_cidr`, `route_table_id`, `security_list_id`, `log_id`.

### B. OKE Module (`modules/oke`)
* **What the module does**: Provisions the Oracle Container Engine for Kubernetes (OKE) cluster with VCN-native pod networking and creates a managed worker node pool matching specific compute and OS requirements.
* **Input**:
  - `cluster_name`, `kubernetes_version`: Engine specs.
  - `api_endpoint_subnet_id`, `is_api_endpoint_public`: Control plane network configs.
  - `lb_subnet_ids`, `node_subnet_id`, `pod_subnet_id`: VCN-Native subnets.
  - `node_shape`, `node_ocpus`, `node_memory_in_gbs`, `node_count`, `node_image_id`, `ssh_public_key`: Node pool configuration.
* **Output**:
  - `cluster_id`, `cluster_name`, `kubernetes_version`, `node_pool_id`, `cluster_endpoints`.
  - `kubeconfig_command`: The CLI command to authenticate locally.

---

## 5. Problems Faced & Troubleshooting

During the deployment lifecycle, several technical hurdles were encountered and resolved:

### 1. Nginx `403 Forbidden` Error on Application Load
* **Problem**: When accessing the Load Balancer IP, Nginx returned a `403 Forbidden` error. This happened because mounting the empty OCI Block Volume to `/usr/share/nginx/html` overwrote the container's built-in `index.html`.
* **Fix**: Implemented an `initContainers` block in `k8s/deployment.yaml`. The init container runs `cp -f /usr/share/nginx/html/index.html /mnt/pvc/index.html` to seed the newly mounted volume before Nginx starts.

### 2. Pods Stuck in `Init` State (Volume Attachment Conflict)
* **Problem**: The deployment was scaled to `replicas: 2`. Since OCI Block Volumes use `ReadWriteOnce` access mode, the volume could only bind to one worker node at a time. The second pod stalled while waiting for the volume attachment.
* **Fix**: Changed the deployment specification to `replicas: 1` in `k8s/deployment.yaml` to respect the RWO attachment limits.

### 3. Load Balancer Timeout (`ERR_TIMED_OUT`) in Browsers
* **Problem**: Modern browsers (Chrome, Edge) automatically convert explicit IPs (`79.72.5.99`) to `https://`. Since the Load Balancer was only listening on HTTP port 80, the HTTPS request timed out. Furthermore, the `worker_nodes_subnet` lacked ingress permissions from the `load_balancer_subnet`.
* **Fix**: 
  - Added an ingress rule to `worker_nodes_subnet` allowing traffic from `var.lb_subnet_cidr`.
  - Exposed both port 80 and port 443 in `k8s/service.yaml`, mapping both to `targetPort: 80` to safely catch automatic browser HTTPS requests.

### 4. Node Pool Shape and Image Compatibility Errors
* **Problem**: The Node Pool failed to provision because standard `Oracle-Linux-8.10` compute images were incompatible with OKE managed nodes on `VM.Standard.E4.Flex` shapes.
* **Fix**: Integrated a dynamic `oci_containerengine_node_pool_option` data source block inside `modules/oke/main.tf` to automatically lookup and select a valid `Oracle-Linux-8...-OKE` image compatible with the selected shape and Kubernetes version.

---

## 6. Complete Commands List (Execution Guide)

Here is every command used to initialize, deploy, debug, and verify the infrastructure and application from A to Z.

### Infrastructure Provisioning
```bash
cd /home/ali_hamad/terraform/Labs/Lab-3
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

### OKE Authentication & Connecting
```bash
oci ce cluster create-kubeconfig --cluster-id <cluster_id> --file ~/.kube/config --region me-jeddah-1 --token-version 2.0.0
kubectl get nodes -o wide
```

### Docker Containerization & Registry Push
```bash
docker build -t ejada-app:local .
docker tag ejada-app:local alihamad2411/ejada-cloud-app:v1.0.0
docker login -u alihamad2411
docker push alihamad2411/ejada-cloud-app:v1.0.0
docker images | grep ejada
```

### Kubernetes Application Deployment
```bash
kubectl apply -f k8s/storageclass.yaml
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### Troubleshooting & Rollout Fixes
```bash
kubectl rollout restart deployment web-app-deployment
kubectl rollout status deployment web-app-deployment --timeout=60s
kubectl delete deployment web-app-deployment --now
kubectl apply -f k8s/deployment.yaml
```

### Verification & Connectivity Testing
```bash
kubectl get pods,svc,pvc,sc -o wide
curl -I http://79.72.5.99
curl -v --connect-timeout 5 http://79.72.5.99
curl -v -k https://79.72.5.99
```
