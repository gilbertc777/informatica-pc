# Powercenter DB resource
resource "oci_database_db_system" "domain_db_system" {
    availability_domain    = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id         = "${var.compartment_ocid}"
    database_edition       = "${var.dbs["database_edition"]}"
    
    db_home {
        database {
            admin_password = "${var.dbs["home_database_admin_password"]}"
            db_name        = "${var.dbs["home_database_db_name"]}"
            pdb_name       = "${var.dbs["home_database_pdb_name"]}"
            db_workload    = "${var.dbs["home_database_db_workload"]}"
        }
        db_version   = "${var.dbs["home_db_version"]}"
        display_name = "${var.dbs["home_display_name"]}"
    }
    cpu_core_count          = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "available_core_count")}"
    disk_redundancy         = "${var.dbs["disk_redundancy"]}"
    hostname                = "${var.dbs["hostname"]}"
    shape                   = "${var.dbs["shape"]}"
    ssh_public_keys         = ["${tls_private_key.key.public_key_openssh}"]
    subnet_id               = "${oci_core_subnet.subnet.id}"
    data_storage_size_in_gb = "${var.dbs["data_storage_size_in_gb"]}"
    license_model           = "${var.dbs["license_model"]}"
    node_count              = "${var.dbs["node_count"]}"

    timeouts {
        create = "2h"
        delete = "2h"
    }
}