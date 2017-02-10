#!/bin/sh
#

yum -y install epel-release yum-plugin-priorities httpd php php-mysql wget

setsebool -P httpd_can_network_connect_db 1
systemctl enable httpd
systemctl start httpd

cat > /var/www/html/config.php <<-EOF
CONFIG_PHP
EOF

cat > /var/www/html/index.php <<-"EOF"
INDEX_PHP
EOF

wget -O /var/www/html/favicon.ico https://github.com/UKCloud/cgbt-infra-demo/raw/master/appfiles/favicon.ico
