include:
  - common.openstack-havana-repo
  - common.python-mysqldb

keystone-pkgs:
  pkg.installed:
    - names:
      - keystone
      - python-keystone
      - python-keystoneclient
    - require:
      - pkgrepo: havana

keystone-service:
  service.running:
    - name: keystone
    - enable: True
    - require:
      - pkg: keystone-pkgs
    - watch:
      - file: /etc/keystone/keystone.conf

/etc/keystone/keystone.conf:
  file.managed:
    - source: salt://openstack/keystone/files/keystone.conf
    - user: keystone
    - group: keystone
    - mode: 640
    - template: jinja
    - require:
      - pkg: keystone-pkgs

/root/keystone.sh:
  file.managed:
    - source: salt://openstack/keystone/files/keystone.sh
    - template: jinja
    - mode: 750
    - require:
      - pkg: keystone-pkgs

/etc/keystone/check:
  file.managed:
    - user: keystone
    - group: keystone
    - mode: 640
    - require:
      - pkg: keystone-pkgs

keystone_db_sync:
  cmd.wait:
    - name: 'keystone-manage db_sync && echo -n "\nchanged=yes"'
    - stateful: True
    - watch:
      - file: /etc/keystone/check
    - require:
      - pkg: python-mysqldb
      - service: keystone-service

keystone.sh:
  cmd.wait:
    - name: /root/keystone.sh
    - watch:
      - cmd: keystone_db_sync
    - require:
      - file: /root/keystone.sh
