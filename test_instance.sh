#!/bin/bash

. ./admin-openrc
wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img
openstack image create "cirros" --file cirros-0.3.4-x86_64-disk.img --disk-format qcow2 --container-format bare --public
openstack image list
. ./admin-openrc
neutron net-create --shared --provider:physical_network provider --provider:network_type flat provider
neutron subnet-create --name provider --allocation-pool start=192.168.56.101,end=192.168.56.250 --dns-nameserver 8.8.4.4 --gateway 192.168.0.254 provider 192.168.56.0/24
. ./demo-openrc
neutron net-create selfservice
neutron subnet-create --name selfservice --dns-nameserver 8.8.4.4 --gateway 172.16.1.1 selfservice 172.16.1.0/24
. ./admin-openrc
neutron net-update provider --router:external
. ./demo-openrc
neutron router-create router
neutron router-interface-add router selfservice
neutron router-gateway-set router provider
. ./admin-openrc
ip netns
neutron router-port-list router
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano
. ./demo-openrc
ssh-keygen -q -N ""
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack keypair list
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
. ./demo-openrc
openstack flavor list
openstack image list
openstack network list
openstack security group list
openstack server create --flavor m1.nano --image cirros --nic net-id=055715a8-0cfc-46ae-948f-b6aa44524b48 --security-group default --key-name mykey selfservice-instance
openstack server list
openstack console url show selfservice-instance
. ./demo-openrc
openstack volume create --size 1 volume1
openstack volume list
openstack server add volume selfservice-instance volume1
openstack volume list
