{% set flat_interface = salt['pillar.get']('nova:network:flat_interface') -%}
{% set public_interface = salt['pillar.get']('nova:network:public_interface') -%}
{% set public_gateway = salt['pillar.get']('nova:network:custom:public_gateway') -%}
{% set public_netmask = salt['pillar.get']('nova:network:custom:public_netmask') -%}

{% set interfaces = salt['network.interfaces']() -%}
{% for interface in interfaces -%}

{% if interface == flat_interface -%}

{{ interface }}:
  file.append:
    - name: /etc/network/interfaces
    - text:
      - "auto {{ interface }}"
      - "iface {{ interface }} inet manual"
      - "up ifconfig {{ interface }} up"

restart_network_{{ interface }}:
  cmd.wait:
    - name: 'service network-interface restart INTERFACE={{ interface }}'
    - watch:
      - file: {{ interface }}

{% elif interface == public_interface -%}

{{ interface }}:
  file.append:
    - name: /etc/network/interfaces
    - text:
      - "auto {{ interface }}"
      - "iface {{ interface }} inet static"
      - "address {{ grains['public_ip'] }}"
      - "netmask {{ public_netmask }}"
      - "gateway {{ public_gateway }}"

restart_network_{{ interface }}:
  cmd.wait:
    - name: 'service network-interface restart INTERFACE={{ interface }}'
    - watch:
      - file: {{ interface }}

{% endif -%}
{% endfor -%}
