# terraform.tfvars - All variables defined here!
compartment_id            = "ocid1.compartment.oc1..xxxxx"
region                    = "us-phoenix-1"
environment               = "lab"
vcn_name                  = "main-vcn"
vcn_dns_label             = "mainvcn"
public_subnet_name        = "public-subnet"
private_subnet_name       = "private-subnet"
instance_name             = "linux-webserver"
vcn_cidr_block            = "10.0.0.0/16"
public_subnet_cidr_block  = "10.0.1.0/24"
private_subnet_cidr_block = "10.0.2.0/24"
instance_shape            = "VM.Standard.E4.Flex"
instance_ocpus            = 1
instance_memory           = 4
ssh_public_key            = "ssh-rsa AAAA..."
instance_image_id         = "ocid1.image.oc1.phx.xxxxx"