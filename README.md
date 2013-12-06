Salt OpenStack
==============

Salt states for OpenStack Havana release multi-node deployments. This deployment doesn't support HA, which means one controller node and multiple compute nodes. It will use FlatDHCP networking. Salt states tree:

```
├── pillar
│   ├── data
│   │   ├── cinder.sls
│   │   ├── glance.sls
│   │   ├── horizon.sls
│   │   ├── keystone.sls
│   │   ├── mysql.sls
│   │   ├── nova.sls
│   │   └── rabbitmq.sls
│   └── top.sls
└── salt
    ├── common
    │   ├── ntp
    │   │   └── init.sls
    │   ├── openstack-grizzly-repo
    │   │   └── init.sls
    │   ├── openstack-havana-repo
    │   │   └── init.sls
    │   ├── ppa
    │   │   └── nodejs
    │   │       └── init.sls
    │   ├── python-lesscpy
    │   │   └── init.sls
    │   ├── python-mysqldb
    │   │   └── init.sls
    │   ├── python-software-properties
    │   │   └── init.sls
    │   └── ubuntu-cloud-keyring
    │       └── init.sls
    ├── openstack
    │   ├── cinder
    │   │   ├── files
    │   │   │   ├── api-paste.ini
    │   │   │   └── cinder.conf
    │   │   └── init.sls
    │   ├── glance
    │   │   ├── files
    │   │   │   ├── glance-api.conf
    │   │   │   └── glance-registry.conf
    │   │   └── init.sls
    │   ├── horizon
    │   │   ├── files
    │   │   │   └── local_settings.py
    │   │   └── init.sls
    │   ├── keystone
    │   │   ├── files
    │   │   │   ├── keystone.conf
    │   │   │   └── keystone.sh
    │   │   └── init.sls
    │   ├── mysql
    │   │   ├── files
    │   │   │   └── my.cnf
    │   │   └── init.sls
    │   ├── nova-compute
    │   │   ├── drive.sls
    │   │   ├── files
    │   │   │   ├── api-paste.ini
    │   │   │   ├── libvirt-bin
    │   │   │   ├── libvirt-bin.conf
    │   │   │   ├── libvirtd.conf
    │   │   │   ├── nova-compute.conf
    │   │   │   └── qemu.conf
    │   │   ├── get_public_address.sls
    │   │   ├── init.sls
    │   │   ├── interfaces.sls
    │   │   └── kvm.sls
    │   ├── nova-controller
    │   │   ├── files
    │   │   │   ├── api-paste.ini
    │   │   │   ├── nova.conf
    │   │   │   └── nova_network.sh
    │   │   ├── init.sls
    │   │   └── set_public_addresses.sls
    │   ├── rabbitmq
    │   │   └── init.sls
    │   └── sysctl.sls
    ├── overstate.sls
    └── top.sls
```
Salt Minion
==============

There are three different salt-minion roles: mysql, nova-controller and nova-compute. First two can be assigned to one node. Salt minion nova controller configuration:

```
master: ip_address

grains:
  roles:
    - nova-controller
    - mysql

mine_functions:
  network.ip_addrs:
    - eth0
  network.interfaces: []
  test.ping: []
  grains.item:
    - public_ips
    - public_ip
```
Salt minion nova compute configuration:

```
master: ip_address

grains:
  roles:
    - nova-compute

mine_functions:
  network.ip_addrs:
    - eth0
  network.interfaces: []
  test.ping: []
  grains.item:
    - public_ips
    - public_ip
```

Deployment
==============

All OpenStack configuration otpions are definied in pillars. After all minions are ready you need to run overstate (http://docs.saltstack.com/ref/states/overstate.html):

```
rm -rf /srv/salt /srv/pillar
cd /srv && git clone https://github.com/komljen/salt-openstack.git .
salt-run state.over
```

For bare metal salt provisioning you can use Cobbler (https://github.com/komljen/cobbler-salt).
