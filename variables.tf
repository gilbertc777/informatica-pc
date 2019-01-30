
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

# Network Defaults
variable "cidr_block" {
    type = "string"
    default = "10.0.0.0/16"
}

variable "dns_label" {
    type = "string"
    default = "infpc"
}

# Database System Default Values
variable dbs {
    type    = "map"
    default = {
        database_edition             = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
        home_database_admin_password = "Password_123456_Password"
        home_database_db_name        = "pc"
        home_database_db_workload    = "OLTP"
        home_database_pdb_name       = "pdbpc"
        home_db_version              = "12.2.0.1"
        home_display_name            = "pdb"
        hostname                     = "pcdb-host"
        shape                        = "VM.Standard2.8"
        data_storage_size_in_gb      = "512"
        license_model                = "BRING_YOUR_OWN_LICENSE"
        node_count                   = "2"
        disk_redundancy              = "HIGH"
    } 
}

# Powercenter VM Shape Defaults
variable pcvm {
    type = "map"
    default = {
        instance_shape               = "VM.Standard2.4"
        instance_display_name        = "infpc-master"
        instance_worker_display_name = "infpc-worker"
        instance_imageid             = "ocid1.image.oc1.iad.aaaaaaaa2ptbgaxr64uxz5m6cxpv5mpiv66pgsnlgyu3ugctpf7xsr2q6o6a"
        instance_worker_node_count   = "0"


    }
}

# FSS Filesystem Config Defaults
variable fss_config {
    type = "map"
    default = {
        export_path = "/export1"
        mountpoint  = "/fss"
    }
}

# Powercenter configuration variables
variable infm_pc_config {
    type = "map"
    default = {
        grid_name              = "PCGRID"
        admin_console_password = "Password_123456_Password"
        passphrase             = "Password_123456_Password"
        domain_user_name       = "Domain"
        repo_service_name      = "PCRS"
        int_service_name       = "PCIS"
    }
}