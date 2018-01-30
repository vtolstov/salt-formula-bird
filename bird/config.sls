{%- from "bird/map.jinja" import settings with context %}

{%- if settings.get('ipv4', False) %}

bird_packages_v4:
  pkg.installed:
    - names: {{ settings.pkgs_v4 }}

{%- set ipv4tpl = salt['pillar.get']('bird:settings:ipv4tpl', 'salt://' ~ slspath ~ '/templates/bird_kv.conf.jinja') %}
bird_config_v4:
  file.managed:
    - name: {{ settings.config_v4 }}
    - source: {{ ipv4tpl }}
    - template: jinja
    - context:
        settings: 'bird:ipv4'
    - require:
      - pkg: bird_packages_v4

bird_service_v4:
  service.running:
    - name: {{ settings.service_v4 }}
    - enable: true
    - restart: true
    - unless: test -S /var/run/bird/bird.ctl

bird_reload_v4:
  cmd.run:
    - name: birdc configure
    - onlyif: test -S /var/run/bird/bird.ctl
    - onchanges:
      - file: bird_config_v4

{%- endif %}
{%- if settings.get('ipv6', False) %}

bird_packages_v6:
  pkg.installed:
    - names: {{ settings.pkgs_v6 }}

{%- set ipv6tpl = salt['pillar.get']('bird:settings:ipv6tpl', 'salt://' ~ slspath ~ '/templates/bird_kv.conf.jinja') %}
bird_config_v6:
  file.managed:
    - name: {{ settings.config_v6 }}
    - source: {{ ipv6tpl }}
    - template: jinja
    - context:
        settings: 'bird:ipv6'
    - require:
      - pkg: bird_packages_v6

bird_service_v6:
  service.running:
    - name: {{ settings.service_v6 }}
    - enable: true
    - reload: true

bird_reload_v6:
  cmd.run:
    - name: birdc6 configure
    - onchanges:
      - file: bird_config_v6

{%- endif %}
