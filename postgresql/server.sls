#!jinja|yaml

{% from "postgresql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('postgresql:lookup')) %}

{% set srv = datamap.server %}

postgresql_server:
  pkg:
    - installed
    - pkgs: {{ srv.pkgs }}
  service:
    - running
    - name: {{ srv.service.name|default('postgresql') }}
    - enable: {{ srv.service.enable|default(True) }}

{#TODO: initdb on rhel #}

{% if 'postgresql' in srv.config.manage|default([]) %}
{{ srv.config.postgresql.path }}:
  file:
    - managed
    - source: {{ srv.config.postgresql.template_path|default('salt://postgresql/files/postgresql.conf') }}
    - template: {{ srv.config.postgresql.template_renderer|default('jinja') }}
    - mode: {{ srv.config.postgresql.mode|default('644') }}
    - user: {{ srv.config.postgresql.user|default('postgres') }}
    - group: {{ srv.config.postgresql.group|default('postgres') }}
    - watch_in:
      - service: postgresql_server
{% endif %}

{% if 'pg_hba' in srv.config.manage|default([]) %}
{{ srv.config.pg_hba.path }}:
  file:
    - managed
    - source: {{ srv.config.pg_hba.template_path|default('salt://postgresql/files/pg_hba.conf') }}
    - template: {{ srv.config.pg_hba.template_renderer|default('jinja') }}
    - mode: {{ srv.config.pg_hba.mode|default('640') }}
    - user: {{ srv.config.pg_hba.user|default('postgres') }}
    - group: {{ srv.config.pg_hba.group|default('postgres') }}
    - watch_in:
      - service: postgresql_server
{% endif %}

{% for u in salt['pillar.get']('postgresql:users', []) %}
user_{{ u.name }}:
  postgres_user:
    - {{ u.ensure|default('present') }}
    - name: {{ u.name }}
    - password: {{ u.password }}
  {% if 'groups' in u %}
    - groups: {{ u.groups }}
  {% endif %}
    - encrypt: {{ u.encrypt|default(True) }}
    - createdb: {{ u.createdb|default(False) }}
    - createroles: {{ u.createroles|default(False) }}
    - createuser: {{ u.createuser|default(False) }}
    - login: {{ u.login|default(True) }}
    - inherit: {{ u.inherit|default(False) }}
    - superuser: {{ u.superuser|default(False) }}
    - replication: {{ u.replication|default(False) }}
    - user: {{ u.user|default('postgres') }}
    - require:
      - service: postgresql_server
{% endfor %}

{% for d in salt['pillar.get']('postgresql:databases', []) %}
database_{{ d.name }}:
  postgres_database:
    - {{ d.ensure|default('present') }}
    - name: {{ d.name }}
    - owner: {{ d.owner|default(d.name) }}
  {% if 'tablespace' in d %}
    - tablespace: {{ d.tablespace }}
  {% endif %}
    - encoding: {{ d.encoding|default('UTF8') }}
    - template: {{ d.template|default('template0') }}
    - lc_collate: {{ d.lc_collate|default('en_US.UTF-8') }}
    - lc_ctype: {{ d.lc_ctype|default('en_US.UTF-8') }}
    - user: {{ d.user|default('postgres') }}
    - require:
      - service: postgresql_server
{% endfor %}
