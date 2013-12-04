base:
  '*':
    - common.ntp

  'G@roles:mysql':
    - openstack.mysql

  'G@roles:nova-controller':
    - openstack.rabbitmq
    - openstack.keystone
    - openstack.horizon
    - openstack.cinder
    - openstack.glance
    - openstack.nova-controller
    - openstack.nova-controller.set_public_addresses

  'G@roles:nova-compute':
    - openstack.nova-compute
    - openstack.nova-compute.get_public_address
