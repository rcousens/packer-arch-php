install-postgresql-python:
  pkg.installed:
    - name: python-psycopg2

install-postgresql:
  pkg.latest:
    - names: 
      - postgresql

postgresql-initdb:
  cmd.run:
    - user: postgres
    - name: initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
    - unless: test -f /var/lib/postgres/data/postgresql.conf

run-postgresql:
  service.running:
    - enable: true
    - restart: true
    - name: postgresql
    - require:
      - pkg: install-postgresql

postgresql-auth:
  file.managed:
    - name: /var/lib/postgres/data/pg_hba.conf
    - source: salt://_files/postgres/pg_hba.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: install-postgresql
    - watch_in:
      - service: postgresql

postgresql-config:
  file.managed:
    - name: /var/lib/postgres/data/postgresql.conf
    - source: salt://_files/postgres/postgresql.conf
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - pkg: install-postgresql
    - watch_in:
      - service: postgresql

default-user:
  postgres_user.present:
    - name: dbuser
    - password: dbuser
    - superuser: true
    - runas: postgres
    - require:
      - service: postgresql

default-user-db:
  postgres_database.present:
    - name: dbuser
    - encoding: UTF8
    - lc_ctype: en_US.UTF8
    - lc_collate: en_US.UTF8
    - owner: dbuser
    - template: template0
    - runas: postgres
    - require:
        - postgres_user: default-user
