resource "oci_core_virtual_network" "virtual_network" {
  display_name   = "virtual_network"
  compartment_id = "${var.tenancy_ocid}"
  cidr_block     = "${var.cidr_block}"
  dns_label      = "${var.dns_label}"
}

resource "oci_core_internet_gateway" "internet_gateway" {
  display_name   = "internet_gateway"
  compartment_id = "${var.tenancy_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"
}

resource "oci_core_route_table" "route_table" {
  display_name   = "route_table"
  compartment_id = "${var.tenancy_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}

resource "oci_core_security_list" "security_list" {
  display_name   = "security_list"
  compartment_id = "${var.tenancy_ocid}"
  vcn_id         = "${oci_core_virtual_network.virtual_network.id}"

  egress_security_rules = [{
    protocol    = "All"
    destination = "0.0.0.0/0"
  }]

  ingress_security_rules = [{
    protocol = "All"
    source   = "0.0.0.0/0"
  }]
}

resource "oci_core_subnet" "subnet" {
  display_name        = "subnet"
  compartment_id      = "${var.tenancy_ocid}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0], "name")}"
  cidr_block          = "${var.cidr_block}"
  vcn_id              = "${oci_core_virtual_network.virtual_network.id}"
  route_table_id      = "${oci_core_route_table.route_table.id}"
  security_list_ids   = ["${oci_core_security_list.security_list.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.virtual_network.default_dhcp_options_id}"
  dns_label           = "${var.dns_label}"
}