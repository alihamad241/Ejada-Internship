# terraform.tfvars - All variables defined here!
compartment_id            = "ocid1.compartment.oc1..aaaaaaaaysnyvq2lov36yvi5wjctoxuqf4gdjflzponmhjww2xdcbcceirwq"
tenancy_ocid              = "ocid1.tenancy.oc1..aaaaaaaaats3vpt43eyb7d6djyot4nzy4d7qqe4ajiwr2vnn2rbffcdo34nq"
region                    = "me-jeddah-1"
environment               = "lab"
vcn_name                  = "main-vcn"
vcn_dns_label             = "mainvcn"
public_subnet_name        = "public-subnet"
private_subnet_name       = "private-subnet"
instance_name             = "linux-webserver"
vcn_cidr_block            = "10.0.0.0/16"
public_subnet_cidr_block  = "10.0.1.0/24"
private_subnet_cidr_block = "10.0.2.0/24"
public_subnet_dns_label   = "publicsubnet"
private_subnet_dns_label  = "privatesubnet"
instance_shape            = "VM.Standard.E4.Flex"
instance_ocpus            = 1
instance_memory           = 4
load_balancer_shape       = "100Mbps"
bastion_shape             = "VM.Standard.E4.Flex"
bastion_ocpus             = 1
bastion_memory            = 2
bastion_name              = "linux-bastion"
bastion_hostname_label    = "linux-bastion"
bastion_ssh_source_cidr   = "0.0.0.0/0"
ssh_public_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCbEeXvKKW070bfy02ahHS+XjjvpiqvFRj8zXrKkGIxn1JpLkL9E5hTyYskCP1BBh1s89ki2PwtOkvTIfIydDu8XyBVYZEp2XFjohtGsZfOfL6CawuWK8pXFL17/fnL4EffW3FFLKSCFGd8N9c0XdMYvWlFnoXa4RxmTnxIG6r8JKlIADHmQVgZUh7QHfA2GAnyZKnil11zGBDvfdh4Fzge9dT0CzuFumRuUMD15gE5wWZjtDWETbP6SYIIibvohhdrsddDlIoXl5ydAO8ldrRywipT4UT7SbkaQFmdLa2AiMSt5IdInY4FAA6rHHASD7SR7B/gB3rlO8QAUfMGP7l8HnrL18OjcWB0P38u60BJ8d4Kg5dXGKVoyBqsQ6RSQWD14G6iJh+46QuFO6mmJ1+1W48XH5MrcWJYmcD8K9fy0TAl6v3rkaNl99xoWW1oRFcZszUm46Ctrnzhg53KMGB7iokUm7RwFDmEB9rD8tIDxdnsbFv7YQO2MSur3FnP0+9qTt5k6b9wF0IHUTlwUtm80zuKH9WcMcLBq81OKcxaJ7cpO2p/zEGKsMnWrgGq2G8G0JrMwAQy6hc1vnndaJaJ5T4noBTgcsNzT08OB9GgXbdosSRGnAT43oGeRT2DoceFYjnxG/ZvJ9le6oZR3mtdXj+QX6+IJYath1bzMQKb/Q== ali_hamad@JACK"