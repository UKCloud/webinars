#!/bin/sh
#

DOWNLOAD_URL="https://releases.hashicorp.com/consul-template/0.18.1/consul-template_0.18.1_linux_amd64.zip"

yum -y install wget unzip

wget -O /tmp/consul-template.zip $DOWNLOAD_URL
mkdir -p /usr/local/bin
cd /usr/local/bin
unzip /tmp/consul-template.zip

cat > /usr/lib/systemd/system/consul-template.service <<-"EOF"
CONSULTEMPLATE_SERVICE
EOF

cat > /etc/sysconfig/consul-template <<-"EOF"
CMD_OPTS="-config=/etc/consul-template.d/consul-template.config"
EOF

mkdir -p /etc/consul-template.d
cat > /etc/consul-template.d/haproxy.cfg.ctmpl <<-EOF
HAPROXY_CFG_CTMPL
EOF

cat > /etc/consul-template.d/consul-template.config <<-EOF
CONSULTEMPLATE_CONFIG
EOF

touch /etc/haproxy/haproxy.cfg
chown consul.consul /etc/haproxy/haproxy.cfg
chgrp consul /etc/haproxy
chmod g+w /etc/haproxy

cat > /etc/sudoers.d/consultemplate <<-EOF
consul ALL=(ALL) NOPASSWD: /usr/sbin/service haproxy restart
EOF

systemctl enable consul-template
systemctl start consul-template