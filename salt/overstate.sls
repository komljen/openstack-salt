ntp:
  match: '*'
  sls:
    - common.ntp

mysql:
  match: 'G@roles:mysql'
  sls:
    - openstack.mysql

rabbitmq:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.rabbitmq

keystone:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.keystone
  require:
    - rabbitmq
    - mysql

glance:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.glance
  require:
    - rabbitmq
    - mysql
    - keystone

cinder:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.cinder
  require:
    - rabbitmq
    - mysql
    - keystone

nova-controller:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.nova-controller
  require:
    - rabbitmq
    - mysql
    - keystone

nova-controller-public-addresses:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.nova-controller.set_public_addresses
  require:
    - nova-controller

horizon:
  match: 'G@roles:nova-controller'
  sls:
    - openstack.horizon
  require:
    - rabbitmq
    - mysql
    - keystone
    - cinder
    - glance
    - nova-controller

nova-compute-public-address:
  match: 'G@roles:nova-compute'
  sls:
    - openstack.nova-compute.get_public_address
  require:
    - nova-controller-public-addresses
    - nova-controller

nova-compute:
  match: 'G@roles:nova-compute'
  sls:
    - openstack.nova-compute
  require:
    - nova-controller
    - nova-compute-public-address
