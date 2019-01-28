resource "null_resource" "remote-exec-master-node" {
    depends_on = ["oci_core_instance.pc_instance", "oci_database_db_system.domain_db_system"]
    # Execute provisioner to install/confiure Powercenter
    provisioner "remote-exec" {
        inline = [
            "export public_url=NULL",
            "export admin_console_password=${var.infm_pc_config["admin_console_password"]}",
            "export master_db_password=${var.dbs["home_database_admin_password"]}",
            "export infra_passphrase=${var.infm_pc_config["passphrase"]}",
            "export create_domain=1",
            "export join_domain=0",
            "export serves_as_gateway=0",
            "export single_node=0",
            "export domain_user_name=${var.infm_pc_config["domain_user_name"]}",
            "export db_type=Oracle",
            "export repository_service_name=${var.infm_pc_config["repo_service_name"]}",
            "export integration_service_name=${var.infm_pc_config["int_service_name"]}",
            "export db_host_name=${var.dbs["hostname"]-scan.${oci_core_subnet.subnet.dns_label}.${oci_core_virtual_network.virtual_network.dns_label}.oraclevcn.com",
            "export db_port=1521",
            "export db_uname=usr7",
            "export db_servicename=${var.dbs["hostname"]-scan.${oci_core_subnet.subnet.dns_label}.${oci_core_virtual_network.virtual_network.dns_label}.oraclevcn.com",
            "export domain_name=InfraDomain",
            "export node_name=${oci_core_instance.pc_instance.hostname_label}",
            "export grid_name=${var.infm_pc_config["grid_name"]}",
            "export repo_user=usr8",
            "export informatica_services=2",
            "export join_node_name=NotApplicable",
            "export domain_host_name=${var.pcvm["instance_display_name"]}",
            "/home/opc/scripts/install-powercenter.sh > /home/opc/pc_install.log"
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

# resource "null_resource" "remote-exec-domain-nodes" {

# }

