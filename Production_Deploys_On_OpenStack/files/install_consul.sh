#!/bin/sh
#

DOWNLOAD_URL="https://releases.hashicorp.com/consul/0.7.4/consul_0.7.4_linux_amd64.zip"

yum -y install wget unzip

wget -O /tmp/consul.zip $DOWNLOAD_URL
mkdir -p /usr/local/bin
cd /usr/local/bin
unzip /tmp/consul.zip

useradd --comment "Consul User" --no-create-home --system --shell /sbin/nologin consul

mkdir -p /etc/consul.d/{bootstrap,server,client}

cat > /etc/consul.d/bootstrap/config.json <<-EOF
{
    "bootstrap": true,
    "server": true,
    "data_dir": "/var/consul",
    "datacenter": "demo",
    "log_level": "INFO",
    "enable_syslog": true
}
EOF

cat > /etc/consul.d/server/config.json <<-EOF
{
    "bootstrap": false,
    "server": true,
    "data_dir": "/var/consul",
    "datacenter": "demo",
    "log_level": "INFO",
    "enable_syslog": true,
    "start_join": [ "$jumpbox_ip", "$vip" ],
    "advertise_addr": "$local_ip"
}
EOF

cat > /etc/consul.d/client/config.json <<-EOF
{
    "server": false,
    "data_dir": "/var/consul",
    "datacenter": "demo",
    "log_level": "INFO",
    "enable_syslog": true,
    "start_join": [ "$vip" ]
}
EOF

mkdir -p /var/consul
chown consul.consul /var/consul

cat > /etc/init.d/consul <<-"EOF"
CONSUL_INIT_SH
EOF
chmod 755 /etc/init.d/consul

cat > /etc/sysconfig/consul <<-EOF
confdir=/etc/consul.d/$agenttype
EOF

systemctl enable consul
systemctl restart consul
