# Gets a list of Availability Domains
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${var.compartment_ocid}"
}

# Get DB node list
data "oci_database_db_nodes" "db_nodes" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.domain_db_system.id}"
}

# Get DB node details
data "oci_database_db_node" "db_node_details" {
  db_node_id = "${lookup(data.oci_database_db_nodes.db_nodes.db_nodes[0], "id")}"
}

data "oci_database_db_homes" "db_homes" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.domain_db_system.id}"
}

data "oci_database_databases" "databases" {
  compartment_id = "${var.compartment_ocid}"
  db_home_id     = "${data.oci_database_db_homes.db_homes.db_homes.0.db_home_id}"
}

data "oci_database_db_system_patches" "patches" {
  db_system_id = "${oci_database_db_system.domain_db_system.id}"
}

data "oci_database_db_system_patch_history_entries" "patches_history" {
  db_system_id = "${oci_database_db_system.domain_db_system.id}"
}

data "oci_database_db_home_patches" "patches" {
  db_home_id = "${data.oci_database_db_homes.db_homes.db_homes.0.db_home_id}"
}

data "oci_database_db_home_patch_history_entries" "patches_history" {
  db_home_id = "${data.oci_database_db_homes.db_homes.db_homes.0.db_home_id}"
}

data "oci_database_db_versions" "db_versions_by_db_system_id" {
  compartment_id = "${var.compartment_ocid}"
  db_system_id   = "${oci_database_db_system.domain_db_system.id}"
}

data "oci_database_db_system_shapes" "db_system_shapes" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  compartment_id      = "${var.compartment_ocid}"

  filter {
    name   = "shape"
    values = ["${var.dbs["shape"]}"]
  }
}

data "oci_core_private_ips" "fss1_mt_1_ip" {
  subnet_id = "${oci_file_storage_mount_target.fss1_mt1.subnet_id}"

  filter {
    name   = "id"
    values = ["${oci_file_storage_mount_target.fss1_mt1.private_ip_ids.0}"]
  }
}