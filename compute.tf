resource "oci_database_db_system" "domain_db_system" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id = "${var.compartment_ocid}"
    database_edition = "${var.db_system["database_edition"]}"
    
    db_home {
        database {
            #Required
            admin_password = "${var.db_system["db_home_database_admin_password"]}"
            db_name = "${var.db_system["db_home_database_db_name"]}"
            db_workload = "${var.db_system["db_home_database_db_workload"]}"
            pdb_name = "${var.db_system["db_home_database_pdb_name"]}"
        }
        db_version = "${var.db_system["db_home_db_version"]}"
        display_name = "${var.db_system["db_home_display_name"]}"
    }
    hostname = "${var.db_system["hostname"]}"
    shape = "${var.db_system["shape"]}"
    ssh_public_keys = ["${tls_private_key.key.public_key_openssh}"]
    subnet_id = "${oci_core_subnet.subnet.id}"

    #Optional
    data_storage_size_in_gb = "${var.db_system["data_storage_size_in_gb"]}"
    license_model = "${var.db_system["license_model"]}"
    node_count = "${var.db_system["node_count"]}"
}