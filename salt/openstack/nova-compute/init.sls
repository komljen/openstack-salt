include:
  - common.openstack-havana-repo
  - openstack.sysctl
  - .drive
  - .interfaces
  - .kvm

nova-pkgs:
  pkg.installed:
    - names:
      - nova-compute
      - nova-network
      - nova-api-metadata
      - nova-compute-kvm
    - require:
      - sls: openstack.sysctl
      - sls: openstack.nova-compute.drive
      - sls: openstack.nova-compute.interfaces
      - sls: openstack.nova-compute.kvm
      - pkgrepo: havana

nova-state-path:
  file.directory:
    - name: {{ salt['pillar.get']('nova:service:state_path') }}
    - user: nova
    - group: nova
    - file_mode: 744
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode
    - require:
      - pkg: nova-pkgs

nova-services:
  service.running:
    - names:
      - nova-compute
      - nova-network
      - nova-api-metadata
    - enable: True
    - require:
      - pkg: nova-pkgs
    - watch:
      - file: /etc/nova/nova.conf
      - file: /etc/nova/nova-compute.conf
      - file: /etc/nova/api-paste.ini

/etc/nova/nova.conf:
  file.managed:
    - source: salt://openstack/nova-controller/files/nova.conf
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-pkgs

/etc/nova/nova-compute.conf:
  file.managed:
    - source: salt://openstack/nova-compute/files/nova-compute.conf
    - user: nova
    - group: nova
    - mode: 600
    - template: jinja
    - require:
      - pkg: nova-pkgs

/etc/nova/api-paste.ini:
  file.managed:
    - source: salt://openstack/nova-compute/files/api-paste.ini
    - user: nova
    - group: nova
    - mode: 640
    - template: jinja
    - require:
      - pkg: nova-pkgs
