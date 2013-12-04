include:
  - common.openstack-havana-repo
  - common.python-mysqldb

glance-pkgs:
  pkg.installed:
    - names:
      - glance
      - glance-api
      - glance-registry
      - glance-common
      - python-glanceclient
    - require:
      - pkgrepo: havana

glance-services:
  service.running:
    - names:
      - glance-api
      - glance-registry
    - enable: True
    - require:
      - pkg: glance-pkgs
    - watch:
      - file: /etc/glance/glance-api.conf
      - file: /etc/glance/glance-registry.conf

/etc/glance/glance-api.conf:
  file.managed:
    - source: salt://openstack/glance/files/glance-api.conf
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja
    - require:
      - pkg: glance-pkgs

/etc/glance/glance-registry.conf:
  file.managed:
    - source: salt://openstack/glance/files/glance-registry.conf
    - user: glance
    - group: glance
    - mode: 640
    - template: jinja
    - require:
      - pkg: glance-pkgs

/etc/glance/check:
  file.managed:
    - user: glance
    - group: glance
    - mode: 640
    - require:
      - pkg: glance-pkgs

glance_db_sync:
  cmd.wait:
    - name: 'glance-manage db_sync && echo -n "\nchanged=yes"'
    - stateful: True
    - watch:
      - file: /etc/glance/check
    - require:
      - pkg: python-mysqldb
      - service: glance-services
