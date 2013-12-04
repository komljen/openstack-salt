include:
  - common.openstack-havana-repo

rabbitmq-server:
  pkg.installed:
    - require:
      - pkgrepo: havana
  service.running:
    - enable: True
    - watch:
      - pkg: rabbitmq-server
  rabbitmq_user.present:
    - name: {{ salt['pillar.get']('rabbitmq:user') }}
    - password: {{ salt['pillar.get']('rabbitmq:password') }}
    - force: True
    - require:
      - service: rabbitmq-server
  rabbitmq_vhost.present:
    - name: "/"
    - user: {{ salt['pillar.get']('rabbitmq:user') }}
    - conf: .*
    - write: .*
    - read: .*
    - require:
      - rabbitmq_user: {{ salt['pillar.get']('rabbitmq:user') }}
