# Powercenter DB resource
resource "oci_database_db_system" "domain_db_system" {
    availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id      = "${var.compartment_ocid}"
    database_edition    = "${var.db_database_edition}"
    
    db_home {
        database {
            admin_password = "${var.db_home_database_admin_password}"
            db_name = "${var.db_home_database_db_name}"
            pdb_name = "${var.db_home_database_pdb_name}"
            db_workload = "${var.db_home_database_db_workload}"
        }
        db_version = "${var.db_home_db_version}"
        display_name = "${var.db_home_display_name}"
    }
    cpu_core_count = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "maximum_core_count")}"
    disk_redundancy = "${var.db_disk_redundancy}"
    hostname = "${var.db_hostname}"
    shape = "${var.db_shape}"
    ssh_public_keys = ["${tls_private_key.key.public_key_openssh}"]
    subnet_id = "${oci_core_subnet.subnet.id}"
    data_storage_size_in_gb = "${var.db_data_storage_size_in_gb}"
    license_model = "${var.db_license_model}"
    node_count = "${var.db_node_count}"

    timeouts {
        create = "2h"
        delete = "2h"
    }
}

# Powercenter Compute Resources
# Master Powercenter Server
resource "oci_core_instance" "pc_instance" {
    depends_on = ["oci_database_db_system.domain_db_system"]
    availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id = "${var.compartment_ocid}"
    shape = "${var.pc_instance_shape}"
    display_name = "${var.pc_instance_display_name}"
    
    create_vnic_details {
        subnet_id = "${oci_core_subnet.subnet.id}"
    }

    metadata {
        ssh_authorized_keys = "${tls_private_key.key.public_key_openssh}"
    }
    source_details {
        source_id = "${var.pc_instance_imageid}"
        source_type = "image"
    }
    preserve_boot_volume = false
}

# Optional Power Center instances
resource "oci_core_instance" "pc_instance_worker" {
    depends_on = ["oci_database_db_system.domain_db_system", "oci_core_instance.pc_instance"]
    count = "${var.pc_instance_worker_node_count}"
    availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id = "${var.compartment_ocid}"
    shape = "${var.pc_instance_shape}"
    display_name = "${var.pc_instance_worker_display_name}-${count.index}"
    
    create_vnic_details {
        subnet_id = "${oci_core_subnet.subnet.id}"
    }

    metadata {
        ssh_authorized_keys = "${tls_private_key.key.public_key_openssh}"
    }
    source_details {
        source_id = "${var.pc_instance_imageid}"
        source_type = "image"
    }
    preserve_boot_volume = false
}