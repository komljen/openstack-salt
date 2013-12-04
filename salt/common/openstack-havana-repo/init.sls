include:
  - common.ubuntu-cloud-keyring

havana:
  pkgrepo.managed:
  - name: "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main"
  - require:
    - pkg: ubuntu-cloud-keyring
