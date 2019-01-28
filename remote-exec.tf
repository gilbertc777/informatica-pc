# resource "null_resource" "remote-exec-master-node" {
#     depends_on = ["oci_core_instance.pc_instance", "oci_database_db_system.domain_db_system"]
#     # Execute provisioner to install/confiure Powercenter
#     provisioner "remote-exec" {
#         inline = [
#             "export public_url=",
#             "export admin_console_password=",
#             "export master_db_password=",
#             "export infra_passphrase=",
#             "export create_domain=1",
#             "export join_domain=0",
#             "export serves_as_gateway=0",
#             "export single_node=0",
#             "export domain_user_name=Administrator",
#             "export db_type=Oracle",
#             "export repository_service_name=PCRS",
#             "export integration_service_name=PCIS",
#             "export db_host_name=",
#             "export db_port=1521",
#             "export db_uname=usr7",
#             "export pdb_name.host_domain_name=${var.db_home_database_pdb_name}.",
#             "export domain_name=InfraDomain",
#             "export node_name=Node01",
#             "export grid_name=PCGRID",
#             "export repo_user=usr8",
#             "export informatica_services=2",
#             "export join_node_name=NotApplicable",
#             "export domain_host_name=${var.pc_instance_display_name}",
#             "/home/opc/scripts/install-powercenter.sh"
#         ]
#         connection {
#             host 	 = "${oci_core_instance.pc_instance.public_ip}"
#     		type     = "ssh"
#     		user     = "opc"
#     		private_key = "${tls_private_key.key.private_key_pem}"
# 			timeout	 = "5m"
#   		}
#     }

# }

# resource "null_resource" "remote-exec-domain-nodes" {

# }

