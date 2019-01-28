# Powercenter DB resource
resource "oci_database_db_system" "domain_db_system" {
    availability_domain    = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id         = "${var.compartment_ocid}"
    database_edition       = "${var.dbs["db_database_edition"]}"
    
    db_home {
        database {
            admin_password = "${var.dbs["db_home_database_admin_password"]}"
            db_name        = "${var.dbs["db_home_database_db_name"]}"
            pdb_name       = "${var.dbs["db_home_database_pdb_name"]}"
            db_workload    = "${var.dbs["db_home_database_db_workload"]}"
        }
        db_version   = "${var.dbs["db_home_db_version"]}"
        display_name = "${var.dbs["db_home_display_name"]}"
    }
    cpu_core_count          = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "available_core_count")}"
    disk_redundancy         = "${var.dbs["db_disk_redundancy"]}"
    hostname                = "${var.dbs["db_hostname"]}"
    shape                   = "${var.dbs["db_shape"]}"
    ssh_public_keys         = ["${tls_private_key.key.public_key_openssh}"]
    subnet_id               = "${oci_core_subnet.subnet.id}"
    data_storage_size_in_gb = "${var.dbs["db_data_storage_size_in_gb"]}"
    license_model           = "${var.dbs["db_license_model"]}"
    node_count              = "${var.dbs["db_node_count"]}"

    timeouts {
        create = "2h"
        delete = "2h"
    }
}