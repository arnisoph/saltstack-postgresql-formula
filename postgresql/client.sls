#!jinja|yaml

{% from "postgresql/defaults.yaml" import rawmap with context %}
{% set datamap = salt['grains.filter_by'](rawmap, merge=salt['pillar.get']('postgresql:lookup')) %}

postgresql_client:
  pkg:
    - installed
    - pkgs:
{% for p in datamap.client.pkgs %}
      - {{ p }}
{% endfor %}
