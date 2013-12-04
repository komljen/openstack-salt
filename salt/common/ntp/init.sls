ntp:
  pkg.installed:
    - name: ntp
  service.running:
    - enable: True
    - require:
      - pkg: ntp
    - watch:
      - file: /etc/ntp.conf

/etc/ntp.conf:
  file.append:
    - text:
      - "server 127.127.1.0"
      - "fudge 127.127.1.0 stratum 10"
    - require:
      - pkg: ntp
