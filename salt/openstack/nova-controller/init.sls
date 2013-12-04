include:
  - common.openstack-havana-repo
  - common.python-mysqldb
  - openstack.sysctl

nova-pkgs:
  pkg.installed:
    - names:
      - nova-api
      - nova-cert
      - nova-conductor
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
    - require:
      - pkgrepo: havana

nova-services:
  service.running:
    - names:
      - nova-api
      - nova-cert
      - nova-conductor
      - nova-consoleauth
      - nova-novncproxy
      - nova-scheduler
    - enable: True
    - require:
      - pkg: nova-pkgs
    - watch:
      - file: /etc/nova/nova.conf
      - file: /etc/nova/api-paste.ini
      - cmd: nova_db_sync

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack/nova-controller/files/nova.conf
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-pkgs

/etc/nova/api-paste.ini:
  file.managed:
    - source: salt://openstack/nova-controller/files/api-paste.ini
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-pkgs

/root/nova_network.sh:
  file.managed:
    - source: salt://openstack/nova-controller/files/nova_network.sh
    - template: jinja
    - mode: 750
    - require:
      - pkg: nova-pkgs

/etc/nova/check:
  file.managed:
    - user: nova
    - group: nova
    - mode: 640
    - require:
      - pkg: nova-pkgs

nova_db_sync:
  cmd.wait:
    - name: 'nova-manage db sync && echo -n "\nchanged=yes"'
    - stateful: True
    - watch:
      - file: /etc/nova/check
    - require:
      - pkg: python-mysqldb
      - file: /etc/nova/nova.conf
      - file: /etc/nova/api-paste.ini

nova_network.sh:
  cmd.wait:
    - name: /root/nova_network.sh
    - watch:
      - cmd: nova_db_sync
    - require:
      - file: /root/nova_network.sh
