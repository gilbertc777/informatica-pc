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

# Database Defaults
variable "db_database_edition" {
    type    = "string"
    default = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
}

variable "db_home_database_admin_password" {
    type = "string"
    default = "#Password123456#Password123456"
}

variable "db_home_database_db_name" {
    type    = "string"
    default = "pc"
}

variable "db_home_database_db_workload" {
    type    = "string"
    default = "OLTP"
}

variable "db_home_database_pdb_name" {
    type    = "string"
    default = "pdbpc"
}

variable "db_home_db_version" {
    type    = "string"
    default = "12.2.0.1"
}

variable "db_home_display_name" {
    type    = "string"
    default = "pdb"
}

variable "db_hostname" {
    type    = "string"
    default = "pcdb-host"
}

variable "db_shape" {
    type    = "string"
    default = "VM.Standard2.8"
}

variable "db_data_storage_size_in_gb" {
    type    = "string"
    default = "512"
}

variable "db_license_model" {
    type    = "string"
    default = "BRING_YOUR_OWN_LICENSE"
}

variable "db_node_count" {
    type    = "string"
    default = "2"
}

variable "db_disk_redundancy" {
    type    = "string"
    default = "HIGH"
}

# Simple Powercenter VM
variable "pc_instance_shape" {
    type    = "string"
    default = "VM.Standard2.4" 
}

variable "pc_instance_display_name" {
    type    = "string"
    default = "InfPC-Master"
}

variable "pc_instance_worker_display_name" {
    type    = "string"
    default = "InfPC-worker" 
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

variable "bootstrap_file_name" {
    type    = "string"
    default = "../scripts/powercenter.sh"
}