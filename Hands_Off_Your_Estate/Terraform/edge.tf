# Inbound SSH to the Jumpbox server
resource "vcd_dnat" "jumpbox-ssh" {
    edge_gateway  = "${var.edge_gateway}"
    external_ip   = "${var.jumpbox_ext_ip}"
    port          = 22
    internal_ip   = "${var.jumpbox_int_ip}"
}

# Inbound HTTP to the loadbalancer server
resource "vcd_dnat" "loadbalance-http" {
    edge_gateway  = "${var.edge_gateway}"
    external_ip   = "${var.jumpbox_ext_ip}"
    port          = 80
    internal_ip   = "${var.haproxy_int_ip}"
}

# SNAT Outbound traffic
resource "vcd_snat" "mgt-outbound" {
    edge_gateway  = "${var.edge_gateway}"
    external_ip   = "${var.jumpbox_ext_ip}"
    internal_ip   = "${var.mgt_net_cidr}"
}

resource "vcd_snat" "web-outbound" {
    edge_gateway  = "${var.edge_gateway}"
    external_ip   = "${var.jumpbox_ext_ip}"
    internal_ip   = "${var.web_net_cidr}"
}

resource "vcd_firewall_rules" "website-fw" {
    edge_gateway   = "${var.edge_gateway}"
    default_action = "drop"

    rule {
        description      = "allow-jumpbox-ssh"
        policy           = "allow"
        protocol         = "tcp"
        destination_port = "22"
        destination_ip   = "${var.jumpbox_ext_ip}"
        source_port      = "any"
        source_ip        = "any"
    }

    rule {
        description      = "allow-loadbalancer-http"
        policy           = "allow"
        protocol         = "tcp"
        destination_port = "80"
        destination_ip   = "${var.jumpbox_ext_ip}"
        source_port      = "any"
        source_ip        = "any"
    }

    rule {
        description      = "allow-mgt-outbound"
        policy           = "allow"
        protocol         = "any"
        destination_port = "any"
        destination_ip   = "any"
        source_port      = "any"
        source_ip        = "${var.mgt_net_cidr}"
    }

    rule {
        description      = "allow-web-outbound"
        policy           = "allow"
        protocol         = "any"
        destination_port = "any"
        destination_ip   = "any"
        source_port      = "any"
        source_ip        = "${var.web_net_cidr}"
    }
}
