# ---------------------------------------------------------------------------------------------------------------------
# Environmental variables
# You probably want to define these as environmental variables.
# ---------------------------------------------------------------------------------------------------------------------

# Required by the OCI Provider
variable "tenancy_ocid" {}
variable "compartment_ocid" {}
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

# Database Default Values
variable dbs {
    type    = "map"
    default = {
        db_database_edition = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
        db_home_database_admin_password = "#Password123456#Password123456"
        db_home_database_db_name = "pc"
        db_home_database_db_workload = "OLTP"
        db_home_database_pdb_name = "pdbpc"
        db_home_db_version = "12.2.0.1"
        db_home_display_name = "pdb"
        db_hostname = "pcdb-host"
        db_shape = "VM.Standard2.8"
        db_data_storage_size_in_gb = "512"
        db_license_model = "BRING_YOUR_OWN_LICENSE"
        db_node_count = "2"
        db_disk_redundancy = "HIGH"
    } 
}

# Simple Powercenter VM
variable "pc_instance_shape" {
    type    = "string"
    default = "VM.Standard2.4" 
}

variable "pc_instance_display_name" {
    type    = "string"
    default = "infpc-master"
}

variable "pc_instance_worker_display_name" {
    type    = "string"
    default = "intpc-worker" 
}

variable "pc_instance_imageid" {
    type    = "string"
    default = "ocid1.image.oc1.iad.aaaaaaaa2ptbgaxr64uxz5m6cxpv5mpiv66pgsnlgyu3ugctpf7xsr2q6o6a"
}

variable "pc_instance_worker_node_count" {
    type    = "string"
    default = "0"
}

variable "fss_export_path" {
    type    = "string"
    default = "/export1"
}

variable "fss_mountpoint" {
    type    = "string"
    default ="/fss"
}

# Powercenter configuration variables
variable "grid_name" {
    type    = "string"
    default = "PCGRID"
}

variable "admin_console_password" {
    type    = "string"
    default = "password1234%%"
}

variable "infra_pc_passphrase" {
    type    = "string"
    default = "password1234%%"
}

variable "domain_user_name" {
    type    = "string"
    default = "Domain"
}

variable "pc_repo_service_name" {
    type    = "string"
    default = "PCRS"
}

variable "pc_int_service_name" {
    type    = "string"
    default = "PCIS"
}

variable "bootstrap_file_name" {
    type    = "string"
    default = "../scripts/powercenter.sh"
}