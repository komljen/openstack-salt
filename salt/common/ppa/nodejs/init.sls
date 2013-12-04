include:
  - common.python-software-properties

nodejs:
  pkgrepo.managed:
    - ppa: chris-lea/node.js
    - require:
      - pkg: python-software-properties
