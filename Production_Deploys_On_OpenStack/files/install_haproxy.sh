#!/bin/sh
#

yum -y install haproxy
mkdir -p /etc/haproxy

# cat > /etc/haproxy/haproxy.cfg <<-EOF
# HAPROXY_CFG
# EOF

sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.ip_nonlocal_bind=1

systemctl enable haproxy
systemctl restart haproxy
