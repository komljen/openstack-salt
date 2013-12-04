kvm-pkgs:
  pkg.installed:
    - names:
      - bridge-utils
      - dnsmasq
      - libvirt-bin
      - kvm
      - sysfsutils
      - bridge-utils
      - dnsmasq

libvirt-bin:
  service.running:
    - enable: True
    - require:
      - pkg: kvm-pkgs
    - watch:
      - file: /etc/libvirt/libvirtd.conf
      - file: /etc/init/libvirt-bin.conf
      - file: /etc/default/libvirt-bin

/etc/libvirt/libvirtd.conf:
  file.managed:
    - source: salt://openstack/nova-compute/files/libvirtd.conf
    - mode: 640
    - template: jinja
    - require:
      - pkg: kvm-pkgs

/etc/init/libvirt-bin.conf:
  file.managed:
    - source: salt://openstack/nova-compute/files/libvirt-bin.conf
    - mode: 640
    - template: jinja
    - require:
      - pkg: kvm-pkgs

/etc/default/libvirt-bin:
  file.managed:
    - source: salt://openstack/nova-compute/files/libvirt-bin
    - mode: 640
    - template: jinja
    - require:
      - pkg: kvm-pkgs

/etc/libvirt/check:
  file.managed:
    - mode: 640
    - require:
      - pkg: kvm-pkgs

net_destroy:
  cmd.wait:
    - name: 'virsh net-destroy default && echo -n "\nchanged=yes"'
    - onlyif: 'sleep 10 && file /var/run/libvirt/libvirt-sock'
    - stateful: True
    - watch:
      - file: /etc/libvirt/check
    - require:
      - service: libvirt-bin

net_undefine:
  cmd.wait:
    - name: 'virsh net-undefine default'
    - watch:
      - cmd: net_destroy

vhost_net:
  kmod.present
