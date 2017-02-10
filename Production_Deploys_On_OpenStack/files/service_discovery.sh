#!/bin/sh
#

mkdir -p /etc/consul.d/client

cat > /etc/consul.d/client/web.json <<-EOF
{
    "service": {
        "name": "web",
        "tags": [ "demo" ],
        "port": 80
    }
}
EOF