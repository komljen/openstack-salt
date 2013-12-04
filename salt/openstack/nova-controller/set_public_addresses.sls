{% set public_ip_count = salt['pillar.get']('nova:network:custom:public_ip_count') -%}
{% set ips = salt['cmd.run']("nova-manage floating list | grep nova | awk '{print $2}' | tail -" + public_ip_count|string).split() -%}
public_ips:
  grains.present:
    - value: {{ ips }}

mine.update:
  module.run:
    - require:
      - grains: public_ips

wait:
  cmd.wait:
    - name: 'sleep $(( ( RANDOM % 7 ) + 2 ))'
    - watch:
      - module: mine.update
