#!/bin/sh
#

yum -y install keepalived

mkdir -p /etc/keepalived
cat > /etc/keepalived/keepalived.conf <<-EOF
KEEPALIVED_CONF
EOF

systemctl enable keepalived
systemctl restart keepalived
