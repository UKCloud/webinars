# Webserver VMs on the Webserver network
resource "vcd_vapp" "webservers" {
    name          = "${format("web%02d", count.index + 1)}"
    catalog_name  = "${var.catalog}"
    template_name = "${var.vapp_template}"
    memory        = 1024
    cpus          = 1
    network_name  = "${vcd_network.web_net.name}"

    initscript    = "mkdir -p ${var.ssh_user_home}/.ssh; echo \"${file("~/.ssh/${var.ssh_userid}.pub")}\" >> ${var.ssh_user_home}/.ssh/authorized_keys; chmod -R go-rwx ${var.ssh_user_home}/.ssh; restorecon -Rv ${var.ssh_user_home}/.ssh"

    depends_on    = [ "vcd_vapp.jumpbox" ]

    count         = "${var.webserver_count}"
}

# Load-balancer VM on the Webserver network
resource "vcd_vapp" "haproxy" {
    name          = "lb01"
    catalog_name  = "${var.catalog}"
    template_name = "${var.vapp_template}"
    memory        = 1024
    cpus          = 1
    network_name  = "${vcd_network.web_net.name}"
    ip            = "${var.haproxy_int_ip}"

    initscript    = "mkdir -p ${var.ssh_user_home}/.ssh; echo \"${file("~/.ssh/${var.ssh_userid}.pub")}\" >> ${var.ssh_user_home}/.ssh/authorized_keys; chmod -R go-rwx ${var.ssh_user_home}/.ssh; restorecon -Rv ${var.ssh_user_home}/.ssh"

    depends_on    = [ "vcd_vapp.jumpbox" ]
}

