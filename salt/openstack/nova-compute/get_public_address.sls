{% set ip_list = salt['mine.get']('roles:nova-controller', 'grains.item', 'grain') -%}
{% set ip_node = salt['mine.get']('roles:nova-compute', 'grains.item', 'grain') -%}
{% set minion_id = salt['mine.get']('roles:nova-controller', 'grains.item', 'grain').iterkeys().next() -%}

{% set result = [] -%}

{% if not salt['grains.item']('public_ip') -%}
{% if ip_node -%}

{% for j in ip_node -%}
{%- do result.append(ip_node[j]['public_ip']) -%}
{%- endfor %}

{%- for ip in ip_list[minion_id]['public_ips'] -%}

{% if ip not in result -%}
public_ip:
  grains.present:
    - value: {{ ip }}
{%- break -%}
{%- endif -%}

{% endfor -%}
{%- else -%}

{% for ip in ip_list[minion_id]['public_ips'] -%}
public_ip:
  grains.present:
    - value: {{ ip }}
{%- break -%}
{%- endfor %}

{%- endif %}

mine.update:
  module.run:
    - require:
      - grains: public_ip

wait:
  cmd.wait:
    - name: 'sleep $(( ( RANDOM % 7 ) + 2 ))'
    - watch:
      - module: mine.update

{%- else -%}

echo 'Grain public_ip exists':
  cmd.run

{%- endif %}
