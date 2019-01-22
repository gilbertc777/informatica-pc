resource "oci_database_db_system" "domain_db_system" {
    #Required
    availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
    compartment_id = "${var.tenancy_ocid}"
    database_edition = "${var.db_system["database_edition"]}"
    db_home {
        #Required
        database {
            #Required
            admin_password = "${var.db_system["db_home_database_admin_password"]}"

            #Optional
            db_name = "${var.db_system["db_home_database_db_name"]}"
            db_workload = "${var.db_system["db_home_database_db_workload"]}"
            pdb_name = "${var.db_system["db_home_database_pdb_name"]}"
        }

        #Optional
        db_version = "${var.db_system["db_home_db_version"]}"
        display_name = "${var.db_system["db_home_display_name"]}"
    }
    hostname = "${var.db_system["hostname"]}"
    shape = "${var.db_system["shape"]}"
    ssh_public_keys = "${var.db_system_ssh_public_keys}"
    subnet_id = "${oci_core_subnet.subnet.id}"

    #Optional
    data_storage_size_in_gb = "${var.db_system["data_storage_size_in_gb"]}"
    license_model = "${var.db_system["license_model"]}"
    node_count = "${var.db_system["node_count"]}"
}


# resource "oci_core_instance" "pc_instance" {
#     depends_on = ["oci_database_db_system.domain_db_system"]
#     #Required
#     availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
#     compartment_id = "${var.tenancy_ocid}"
#     shape = "${var.pc_instance["shape"]}"

#     #Optional
#     create_vnic_details {
#         #Required
#         subnet_id = "${oci_core_subnet.subnet.id}"
#     }
#     display_name = "${var.pc_instance["display_name"]}"
#     metadata {
#         ssh_authorized_keys = "${var.ssh_public_key}"
#         user_data           = "${base64encode(format("%s\n%s\n%s\n",
#           "#!/usr/bin/env bash",
#           "password=${var.dse["password"]}",
#           file("../scripts/powercenter.sh")
#         ))}"
#     }
#     source_details {
#         #Required
#         source_id = "${var.pc_imageid}"
#         source_type = "image"
#     }
#     preserve_boot_volume = false
# }