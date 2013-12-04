include:
  - common.openstack-havana-repo
  - common.python-lesscpy

openstack-dashboard-pkgs:
  pkg.installed:
    - names:
      - memcached
      - openstack-dashboard
      - python-memcache
    - require:
      - pkgrepo: havana
      - pkg: python-lesscpy

openstack-dashboard-ubuntu-theme:
  pkg.purged:
    - require:
      - pkg: openstack-dashboard-pkgs

openstack-dashboard-services:
  service.running:
    - names:
      - apache2
      - memcached
    - enable: True
    - require:
      - pkg: openstack-dashboard-pkgs
    - watch:
      - file: /etc/openstack-dashboard/local_settings.py
      - pkg: openstack-dashboard-ubuntu-theme

/etc/openstack-dashboard/local_settings.py:
  file.managed:
    - source: salt://openstack/horizon/files/local_settings.py
    - template: jinja
    - require:
      - pkg: openstack-dashboard-pkgs
