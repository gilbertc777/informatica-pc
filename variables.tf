# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}

# Key used to SSH to OCI VMs
variable "ssh_public_key" {}
variable "ssh_private_key" {}

# ---------------------------------------------------------------------------------------------------------------------
# Optional variables
# The defaults here will give you a cluster.  You can also modify these.
# ---------------------------------------------------------------------------------------------------------------------

# Network Defaults
variable "cidr_block" {
    type = "string"
    default = "10.0.0.0/16"
}

variable "dns_label" {
    type = "string"
    default = "infpc"
}

variable "db_public_ssh_keys" {
    type    = "list"
    default = [""]
}

# Simple Database System
variable "db_system" {
    type = "map"
    default = {
        database_edition = "Enterprise_Edition_Extreme_Performance"
        db_home_database_admin_password = "#Password123456#Password123456"
        db_home_database_db_name = "pc"
        db_home_database_db_workload = "OLTP"
        db_home_database_pdb_name = "pdb"
        db_home_db_version = "12.2.0.1"
        db_home_display_name = "pdb"
        hostname = "pdb"
        shape = "VM.Standard2.4"
        data_storage_size_in_gb = "8"
        license_model = "BRING_YOUR_OWN_LICENSE"
        node_count = "1"  
    }
}

# Simple Powercenter VM
variable "pc_instance" {
    type = "map"
    default = {
        shape = "VM.Standard2.4"
        display_name = "pc-test-vm"
        imageid = ""
    }
}

variable "bootstrap_file_name" {
    type = "string"
    default = "../scripts/powercenter.sh"
}