include:
  - common.openstack-havana-repo
  - common.python-mysqldb

cinder-pkgs:
  pkg.installed:
    - names:
      - cinder-api
      - cinder-common
      - cinder-scheduler
      - cinder-volume
      - iscsitarget
      - open-iscsi
      - iscsitarget-dkms
      - python-cinderclient
    - require:
      - pkgrepo: havana

cinder-services:
  service.running:
    - names:
      - cinder-api
      - cinder-scheduler
      - cinder-volume
      - iscsitarget
      - open-iscsi
    - enable: True
    - require:
      - pkg: cinder-pkgs
    - watch:
      - file: /etc/cinder/cinder.conf
      - file: /etc/cinder/api-paste.ini
      - file: /etc/default/iscsitarget

/etc/default/iscsitarget:
  file.sed:
    - before: 'false'
    - after: 'true'
    - require:
      - pkg: cinder-pkgs

/etc/cinder/cinder.conf:
  file.managed:
    - source: salt://openstack/cinder/files/cinder.conf
    - user: cinder
    - group: cinder
    - mode: 640
    - template: jinja
    - require:
      - pkg: cinder-pkgs

/etc/cinder/api-paste.ini:
  file.managed:
    - source: salt://openstack/cinder/files/api-paste.ini
    - user: cinder
    - group: cinder
    - mode: 640
    - template: jinja
    - require:
      - pkg: cinder-pkgs

/etc/cinder/check:
  file.managed:
    - user: cinder
    - group: cinder
    - mode: 640
    - require:
      - pkg: cinder-pkgs

cinder_db_sync:
  cmd.wait:
    - name: 'cinder-manage db sync'
    - watch:
      - file: /etc/cinder/check
    - require:
      - pkg: python-mysqldb
      - service: cinder-services
