#!jinja|yaml

{% from "postgresql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('postgresql:lookup')) %}

{% if 'repo' in datamap %}
postgresql_repo:
  pkgrepo:
    - {{ datamap.repo.state }}
    - humanname: PostgreSQL Repo
    - name: {{ datamap.repo.name }}
    - file: {{ datamap.repo.file }}
    - key_url: {{ datamap.repo.key_url }}
    - refresh: True
{% endif %}
