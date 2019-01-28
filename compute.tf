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
    cpu_core_count = "${lookup(data.oci_database_db_system_shapes.db_system_shapes.db_system_shapes[0], "available_core_count")}"
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
    
    # Upload configuration scripts and set executable
    provisioner "file" {
  		source      = "./scripts"
  		destination = "/home/opc"

  		connection {
            host 	 = "${oci_core_instance.pc_instance.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}		
	}

    provisioner "remote-exec" {
  		inline = [
              "chmod -R 755 /home/opc/scripts"
          ]

  		connection {
            host 	 = "${oci_core_instance.pc_instance.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}		
	}

    # Mount FSS
    provisioner "remote-exec" {
        inline = [
            "export mount_target_ip=${lookup(data.oci_core_private_ips.fss1_mt_1_ip.private_ips[0], "ip_address")}",
            "export export_name=${var.fss_export_path}",
            "export mount_point=${var.fss_mountpoint}"
        ]
        connection {
            host 	 = "${oci_core_instance.pc_instance.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}
    }
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

    # Upload configuration scripts and set executable
    provisioner "file" {
  		source      = "./scripts"
  		destination = "/home/opc"

  		connection {
            host 	 = "${oci_core_instance.pc_instance_worker.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}		
	}

    provisioner "remote-exec" {
  	    inline = [
            "chmod -R 755 /home/opc/scripts"
        ]

  		connection {
            host 	 = "${oci_core_instance.pc_instance.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}		
	}

    # Mount FSS
    provisioner "remote-exec" {
        inline = [
            "export mount_target_ip=${lookup(data.oci_core_private_ips.fss1_mt_1_ip.private_ips[0], "ip_address")}",
            "export export_name=${var.fss_export_path}",
            "export mount_point=${var.fss_mountpoint}"
        ]
        connection {
            host 	 = "${oci_core_instance.pc_instance.public_ip}"
    		type     = "ssh"
    		user     = "opc"
    		private_key = "${tls_private_key.key.private_key_pem}"
			timeout	 = "5m"
  		}
    }
}