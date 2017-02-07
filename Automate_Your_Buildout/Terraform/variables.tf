variable "vcd_org"        {}
variable "vcd_userid"     {}
variable "vcd_pass"       {}
variable "catalog"        { default = "DevOps" }
variable "vapp_template"  { default = "centos71" }
variable "edge_gateway"   { default = "Edge Gateway Name" }
variable "jumpbox_ext_ip" { default = "51.179.193.252" }
variable "mgt_net_cidr"   { default = "192.168.150.0/24" }
variable "web_net_cidr"   { default = "192.168.151.0/24" }
variable "jumpbox_int_ip" { default = "192.168.150.10" }
variable "haproxy_int_ip" { default = "192.168.151.10" }
variable "webserver_count" { default = 2 }
variable "domain_name"    { default = "demo.devops-consultant.com" }