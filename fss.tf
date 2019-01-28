resource "oci_file_storage_file_system" "fss1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.pc_instance_display_name}_fss1"
}

resource "oci_file_storage_export" "fss1_export1" {
  export_set_id  = "${oci_file_storage_export_set.fss1_exportset1.id}"
  file_system_id = "${oci_file_storage_file_system.fss1.id}"
  path           = "/export1"

    export_options { 
      source                          = "${oci_core_virtual_network.virtual_network.cidr_block}"
      access                          = "READ_WRITE"
      identity_squash                 = "NONE"
      require_privileged_source_port  = false
      anonymous_gid                   = 65534
      anonymous_uid                   = 65534
  }
}

resource "oci_file_storage_export_set" "fss1_exportset1" {
  mount_target_id   = "${oci_file_storage_mount_target.fss1_mt1.id}"
  max_fs_stat_bytes = 23843202333
  max_fs_stat_files = 223442
}

resource "oci_file_storage_mount_target" "fss1_mt1" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  subnet_id           = "${oci_core_subnet.subnet.id}"
  display_name        = "${var.pc_instance_display_name}_fss1_mt_1"
}

data "oci_core_private_ips" "fss1_mt_1_ip" {
  subnet_id = "${oci_file_storage_mount_target.fss1_mt1.subnet_id}"

  filter {
    name   = "id"
    values = ["${oci_file_storage_mount_target.fss1_mt1.private_ip_ids.0}"]
  }
}