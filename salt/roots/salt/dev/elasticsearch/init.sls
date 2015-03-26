java-jre:
  pkg.latest:
    - name: jre8-openjdk
    - refresh: true

elasticsearch:
  pkg.latest:
    - refresh: true
  service.running:
    - enable: true
    - restart: true
  require:
    - pkg: java-jre