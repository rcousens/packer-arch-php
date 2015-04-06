set-permissions:
  cmd.run:
    - name: 'SETFACL=`which setfacl`; $SETFACL -R -m u:http:rwX -m u:vagrant:rwX /srv/http; $SETFACL -dR -m u:http:rwX -m u:vagrant:rwX /srv/http'
    - order: last
