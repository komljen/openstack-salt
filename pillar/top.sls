base:
  '*':
    - data.keystone
    - data.glance
    - data.cinder
    - data.nova
    - data.rabbitmq
    - data.horizon

  'roles:mysql':
    - match: grain
    - data.mysql