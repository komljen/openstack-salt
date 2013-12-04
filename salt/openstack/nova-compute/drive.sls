{% set drive = salt['pillar.get']('nova:compute:custom:drive') -%}
{% set vg = salt['pillar.get']('nova:compute:libvirt_images_volume_group') -%}
{% set state_path = salt['pillar.get']('nova:service:state_path') -%}
{% set drive_type = salt['pillar.get']('nova:compute:custom:drive_type') -%}

{% if drive != '/dev/sda' -%}

lvm2:
  pkg.installed

{{ drive }}:
  lvm.pv_present:
    - require:
      - pkg: lvm2

{{ vg }}:
  lvm.vg_present:
    - devices: {{ drive }}
    - require:
      - lvm.pv_present: {{ drive }}

{% if salt['pillar.get']('nova:compute:libvirt_images_type') == 'qcow2' -%}

nova:
  lvm.lv_present:
    - vgname: {{ vg }}
    - size: {{ salt['pillar.get']('nova:compute:custom:drive_size') }}
    - require:
      - lvm.vg_present: {{ vg }}

mkfs:
  cmd.wait:
    {% if drive_type == 'ssd' -%}
    - name: 'mke2fs -F -O ^has_journal -t ext4 /dev/{{ vg }}/nova'
    {%- elif drive_type == 'hdd' -%}
    - name: 'mke2fs -F -t ext4 /dev/{{ vg }}/nova'
    {%- endif %}
    - watch:
      - lvm.lv_present: nova

/nova:
  mount.mounted:
    - device: /dev/{{ vg }}/nova
    - fstype: ext4
    - mkmnt: True
    {% if drive_type == 'ssd' -%}
    - opts:
      - defaults
      - noatime
      - discard
    {%- elif drive_type == 'hdd' -%}
    - opts:
      - defaults
      - noatime
    {%- endif %}
    - require:
      - lvm.lv_present: nova
      - cmd: mkfs

{{ state_path }}:
  file.symlink:
    - target: /nova
    - require:
      - mount: /nova

{% endif -%}
{% endif -%}
