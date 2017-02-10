#!/bin/sh
#

yum -y install epel-release yum-plugin-priorities  mariadb-server mariadb

systemctl enable mariadb.service
systemctl start mariadb.service

cat > /tmp/schema.sql <<-EOF
DATABASE_SCHEMA
EOF

cat /tmp/schema.sql | mysql