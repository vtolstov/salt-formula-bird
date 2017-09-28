{% from "bird/map.jinja" import settings with context %}

bird_packages:
  pkg.installed:
  - names: {{ settings.pkgs }}

bird_config:
  file.managed:
  - name: {{ settings.config }}
  - source: salt://{{ slspath }}/files/bird.conf
  - template: jinja
  - require:
    - pkg: bird_packages

bird_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  - reload: true

bird_reload:
  cmd.run:
    - name: birdc configure
    - watch:
      - file: bird_config

