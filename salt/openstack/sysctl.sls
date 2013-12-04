{% if 'nova-compute' in grains['roles'] -%}

net.ipv4.ip_forward:
  sysctl:
    - present
    - value: 1

{% endif -%}

net.ipv4.conf.all.rp_filter:
  sysctl:
    - present
    - value: 0

net.ipv4.conf.default.rp_filter:
  sysctl:
    - present
    - value: 0

vm.swappiness:
  sysctl:
    - present
    - value: 10
