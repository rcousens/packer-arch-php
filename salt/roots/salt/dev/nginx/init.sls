nginx:
  pkg.latest:
    - refresh: true
  service.running:
    - enable: true
    - restart: true
    - watch:
      - file: /etc/nginx/nginx.conf
      - pkg: nginx

/srv/http/dev:
  file:
    - directory
    - user: vagrant
    - group: vagrant
    - makedirs: true

nginx-conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://_files/nginx/nginx.conf
    - template: jinja
    - require:
      - pkg: nginx