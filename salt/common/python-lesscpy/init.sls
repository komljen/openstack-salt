include:
  - common.openstack-havana-repo

python-lesscpy:
  pkg.installed:
    - require:
      - pkgrepo: havana

