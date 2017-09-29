{% from "bird/map.jinja" import settings with context %}

bird_packages:
  pkg.installed:
    - names: {{ settings.pkgs }}

bird_config:
  file.managed:
    - name: {{ settings.config }}
    - source: salt://{{ slspath }}/templates/bird_kv.conf.jinja
    - template: jinja
    - context:
        settings: 'bird:ipv4'
    - require:
      - pkg: bird_packages

bird_service:
  service.running:
    - name: {{ settings.service }}
    - enable: true
    - reload: true

bird_reload:
  cmd.run:
    - name: birdc configure
    - watch:
      - file: bird_config

