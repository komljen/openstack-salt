include:
  - common.python-mysqldb

{% set root_pass = salt['pillar.get']('mysql:root_password') -%}

mysql-server:
  pkg.installed:
    - require:
      - pkg: python-mysqldb

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://openstack/mysql/files/my.cnf
    - template: jinja
    - require:
      - pkg: mysql-server

mysql:
  service.running:
    - enable: True
    - require:
      - pkg: mysql-server
    - watch:
      - file: /etc/mysql/my.cnf

#mysql_root_change:
#  mysql_user.present:
#    - name: root
#    - password: {{ root_pass }}
#    - connection_pass: {{ root_pass }}
#    - require:
#      - pkg: mysql-server

{% set accounts = ['keystone', 'nova', 'glance', 'cinder'] -%}
{% for user in accounts -%}

{{ user }}:
  mysql_user.present:
    - host: "%"
    - password: {{ salt['pillar.get'](user + ':db:password') }}
#    - connection_pass: {{ root_pass }}
    - require:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf
    - watch:
      - service: mysql
  mysql_database.present:
#    - connection_pass: {{ root_pass }}
    - require:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf
    - watch:
      - service: mysql
  mysql_grants.present:
    - grant: ALL
    - database: "{{ user }}.*"
    - user: {{ user }}
    - host: "%"
#    - connection_pass: {{ root_pass }}
    - require:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf
      - mysql_database: {{ user }}
    - watch:
      - service: mysql

{% endfor -%}
