include:
  - common.ubuntu-cloud-keyring

grizzly:
  pkgrepo.managed:
  - name: "deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/grizzly main"
  - require:
    - pkg: ubuntu-cloud-keyring
