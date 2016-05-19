# Configure the VMware vCloud Director Provider
provider "vcd" {
    user            = "${var.vcd_userid}"
    org             = "${var.vcd_org}"
    password        = "${var.vcd_pass}"
    url             = "https://api.vcd.portal.skyscapecloud.com/api"
    maxRetryTimeout = "300"
}


# Jumpbox VM on the Management Network
resource "vcd_vapp" "jumpbox" {
    name          = "jump01.demo.devops-consultant.com"
    catalog_name  = "${var.catalog}"
    template_name = "${var.vapp_template}"
    memory        = 512
    cpus          = 1
    network_name  = "${vcd_network.mgt_net.name}"
    ip            = "${var.jumpbox_int_ip}"

    initscript    = "mkdir -p ${var.ssh_user_home}/.ssh; echo \"${file("~/.ssh/${var.ssh_userid}.pub")}\" >> ${var.ssh_user_home}/.ssh/authorized_keys; chmod -R go-rwx ${var.ssh_user_home}/.ssh; restorecon -Rv ${var.ssh_user_home}/.ssh"
}

# Create our networks
resource "vcd_network" "mgt_net" {
    name         = "Demo Management Network"
    edge_gateway = "${var.edge_gateway}"
    gateway      = "${cidrhost(var.mgt_net_cidr, 1)}"

    static_ip_pool {
        start_address = "${cidrhost(var.mgt_net_cidr, 10)}"
        end_address   = "${cidrhost(var.mgt_net_cidr, 200)}"
    }
}

resource "vcd_network" "web_net" {
    name         = "Demo Webserver Network"
    edge_gateway = "${var.edge_gateway}"
    gateway      = "${cidrhost(var.web_net_cidr, 1)}"

    static_ip_pool {
        start_address = "${cidrhost(var.web_net_cidr, 10)}"
        end_address   = "${cidrhost(var.web_net_cidr, 20)}"
    }
    dhcp_pool {
        start_address = "${cidrhost(var.web_net_cidr, 50)}"
        end_address   = "${cidrhost(var.web_net_cidr, 200)}"
    }
}

