# Production Deployments on Cloud Native Infrastructure

This repository contains the HEAT Orchestration Templates used during the UKCloud Partner Webinar on Friday 10th Feb 2017. 

The templates build and configure a complete 3-Tier application stack consisting of:

 - 3 Networks / Subnets, isolating DMZ, Application & Data instances.
 - A router connecting the 3 networks to the external 'internet' network.
 - 2 Floating IP Addresses, one assigned to a Jumpbox instance, the other the endpoint for inbound http traffic.
 - 1 Jumpbox instance used to relay onto internal servers for management.
 - 2 HAProxy instances, configured with keepalived controlling a VIP (assigned to the floating IP address for inbound requests).
 - The Jumpbox instance and the 2 HAProxy instances are configured as a 3 node Consul server cluster, used by the application instances for Service Discovery.
 - The 2 HAProxy instances also use consul-template to dynamically manage the HAProxy configuration based on the discovered application instances.
 - 2 Database instances, configured with MariaDB and deployed with an initial database schema.
 - 1 Auto-scale group of Application Instances, initially deploying 3 instances. The instance run Apache and PHP with a simple php application dynamically configured with database connection details.
 - Each Application instance deployed by the auto-scale group runs the Consul Client to register with the Consul Servers and advertise it's web services.
 - All the instances are secured with very specific security groups, for example: 
	 - the database instances will only allow incoming connections to MariaDB from instances in the security group for the application instances. 
	 - The application instances will only allow incoming http connections from the instances in the loadbalancer security group.
	 - Internal instances only accept SSH connections from the Jumpbox instance.
 - Each pair of servers are members of a ServerGroup that defines an 'Anti-affinity' policy, ensuring that the instances are created on different hosts.


----------

The templates setup everything from scratch apart from your SSH Keypair. You will need to setup your SSH Keypair in advance and update the 'environment_example.yaml' accordingly.

To deploy the entire stack with a single command, run:
'''
openstack stack create -t deploystack.yaml -e environment_example.yaml --wait appstack
'''

The output from the 'loadbalancer' stack shows you the floating IP addresses that have been assigned to the Jumpbox instance for SSH access, and to the HAProxy VIP, along with the URL for web requests.

In order to support the HAProxy VIP and management via keepalived, the template sets up the required OpenStack configurations of ports and floating IP address, along with the 'allowed address pairs' configuration on the two instances.
