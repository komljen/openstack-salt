Salt OpenStack
==============

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

Salt for OpenStack deployment
