# Lab 2 Runbook

This document explains how to run the Lab 2 Terraform stack and how to verify that every part of the deployment is working.

## What This Lab Deploys

The Lab 2 stack creates:

- 1 Virtual Cloud Network (VCN)
- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 NAT Gateway
- 1 public Application Load Balancer
- 1 bastion host in the public subnet
- 1 private compute instance in the private subnet
- 1 OCI File Storage Service file system mounted to the private instance
- OCI remote state storage using the OCI backend

## Repository Layout

### Root files

- [backend.tf](backend.tf) declares the OCI backend.
- [main.tf](main.tf) passes root variables into the `lab2` module.
- [outputs.tf](outputs.tf) exposes the most useful values after apply.
- [provider.tf](provider.tf) configures the OCI provider.
- [terraform.tfvars](terraform.tfvars) contains the real environment values for the lab.
- [variables.tf](variables.tf) defines the root input variables.

### Module files

All infrastructure resources are inside [modules/lab2](modules/lab2).

- [modules/lab2/data.tf](modules/lab2/data.tf) looks up the availability domains.
- [modules/lab2/locals.tf](modules/lab2/locals.tf) stores reusable names and bootstrap values.
- [modules/lab2/vcn.tf](modules/lab2/vcn.tf) creates the VCN, gateways, and route tables.
- [modules/lab2/subnet.tf](modules/lab2/subnet.tf) creates security lists and subnets.
- [modules/lab2/storage.tf](modules/lab2/storage.tf) creates the File Storage resources.
- [modules/lab2/compute.tf](modules/lab2/compute.tf) creates the private instance and bastion host.
- [modules/lab2/load_balancer.tf](modules/lab2/load_balancer.tf) creates the Application Load Balancer.
- [modules/lab2/outputs.tf](modules/lab2/outputs.tf) defines module outputs.
- [modules/lab2/variables.tf](modules/lab2/variables.tf) defines the module inputs.

## Prerequisites

Before running the lab, make sure you have:

- Terraform installed
- OCI CLI installed and configured
- A valid OCI API key profile in `~/.oci/config`
- A valid tenancy OCID
- A valid compartment OCID
- An SSH public key
- Permission to create networking, compute, load balancer, and file storage resources
- An OCI Object Storage bucket to store the Terraform state file

## Files You Must Review Before Running

Check these values in [terraform.tfvars](terraform.tfvars):

- `compartment_id`
- `tenancy_ocid`
- `region`
- `ssh_public_key`
- `bastion_ssh_source_cidr`

If any of those are placeholders, replace them before initializing Terraform.

The Ubuntu image is selected automatically using the OCI image data source, so you do not need to provide an image OCID manually.

## How To Run It Step by Step

### Step 1: Make sure the backend bucket exists

The backend uses OCI Object Storage. Before running Terraform, confirm that:

- the Object Storage namespace exists
- the bucket exists
- you know the namespace name
- your OCI profile has permission to read and write objects in that bucket

If the bucket does not exist yet, create it in the OCI Console first.

### Step 2: Format the Terraform files

Run this from the Lab 2 directory:

```bash
terraform fmt -recursive
```

### Step 3: Initialize Terraform with the OCI backend

The backend block is declared in [backend.tf](backend.tf), but OCI still needs the backend settings at init time.

Example:

```bash
terraform init \
  -backend-config="namespace=YOUR_NAMESPACE" \
  -backend-config="bucket=terraform-state" \
  -backend-config="key=lab-2/terraform.tfstate" \
  -backend-config="region=me-jeddah-1" \
  -backend-config="auth=APIKey" \
  -backend-config="config_file_profile=DEFAULT"
```

If Terraform asks to migrate local state to remote state, confirm the migration.

### Step 4: Validate the configuration

Run:

```bash
terraform validate
```

This checks that the configuration is syntactically correct and that module references are wired properly.

### Step 5: Review the plan

Run:

```bash
terraform plan
```

Confirm that the plan includes all expected resources:

- VCN and gateways
- public and private subnets
- security lists and route tables
- File Storage mount target, export set, file system, and export
- private instance
- bastion host
- Application Load Balancer and backend set

### Step 6: Apply the infrastructure

Run:

```bash
terraform apply
```

Type `yes` when Terraform asks for confirmation.

## What You Should See After Apply

Use:

```bash
terraform output
```

The important outputs are:

- `vcn_id`
- `private_instance_id`
- `private_instance_ip`
- `bastion_instance_id`
- `bastion_public_ip`
- `load_balancer_public_ips`

## How To Verify Everything Is Working

### 1. Check the resources in OCI Console

In the OCI Console, verify that the following exist:

- 1 VCN
- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 NAT Gateway
- 2 route tables
- 2 security lists
- 1 File Storage mount target
- 1 File System
- 1 Export Set
- 1 Export
- 1 private compute instance
- 1 bastion host
- 1 Application Load Balancer

### 2. Verify the load balancer

Open the load balancer public IP from `terraform output` in a browser.

Expected result:

- the Lab 2 application page should load
- the backend should be healthy in the OCI load balancer console

You can also test with:

```bash
curl http://<load-balancer-public-ip>
```

### 3. Verify the bastion host

Connect to the bastion host using the bastion public IP from `terraform output`:

```bash
ssh -i ~/.ssh/id_rsa opc@<bastion-public-ip>
```

If your SSH key is stored elsewhere, replace the path with your own private key.

### 4. Verify access to the private instance

From the bastion host, SSH into the private instance using the same private key that matches `ssh_public_key` in `terraform.tfvars`:

```bash
ssh -i ~/.ssh/id_rsa ubuntu@<private-instance-ip>
```

Use `ubuntu` for the Ubuntu image generated by Terraform. If you used a different private key when you connected to the bastion, replace `~/.ssh/id_rsa` with that matching key file.

If that works, the public subnet SSH rule and the private subnet SSH rule are both functioning.

### 5. Verify the File Storage mount

From the private instance shell, run:

```bash
mount | grep fss
ls -la /mnt/fss
ls -la /mnt/fss/app
```

Expected result:

- the OCI File Storage export is mounted
- the application files are visible in `/mnt/fss/app`

If you see `No such file or directory` on the bastion host, that is expected. The mount point is created on the private instance only.

### 6. Verify the application process

On the private instance, run:

```bash
curl http://127.0.0.1:8080
```

Expected result:

- HTML content for the Lab 2 application

### 7. Verify the load balancer backend health

In the OCI Console, open the load balancer backend set and confirm that the backend is healthy.

If it is unhealthy, check:

- the private instance is running
- the Python HTTP server is active on port 8080
- the private instance security list allows port 8080
- the load balancer backend points to the private instance IP

## End-to-End Success Criteria

The stack is working correctly when all of the following are true:

- `terraform apply` completes without errors
- `terraform output` shows valid public and private IPs
- the bastion host is reachable by SSH
- the private instance is reachable from the bastion
- the File Storage mount exists on the private instance
- the application files are stored under `/mnt/fss/app`
- the load balancer public IP returns the application page in a browser or with `curl`
- the backend health is green in OCI

## Troubleshooting

### Terraform init fails

Check:

- the namespace value passed to `terraform init`
- the bucket name
- the OCI config profile name
- network access to OCI Object Storage

### `terraform plan` fails on availability domains

Check that `tenancy_ocid` in [terraform.tfvars](terraform.tfvars) is correct.

### The load balancer does not respond

Check:

- the backend set health status
- the public subnet security list
- the private instance is serving HTTP on port 8080
- the private instance IP is correct in the backend

### Bastion SSH does not work

Check:

- `bastion_ssh_source_cidr` matches your real public IP range
- the bastion host has a public IP
- your SSH private key matches `ssh_public_key`

### File Storage does not mount

Check:

- the mount target exists
- the export and export set exist
- the private subnet allows NFS traffic
- cloud-init completed successfully on the private instance

## Cleanup

To remove everything created by the lab:

```bash
terraform destroy
```

If you used remote state, the state file remains in the Object Storage bucket until you delete it separately.
