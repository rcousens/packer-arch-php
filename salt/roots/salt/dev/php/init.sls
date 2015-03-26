php-fpm:
  pkg.latest:
    - names:
      - php-fpm
      - php-intl
      - php-pear
      - php-pgsql
      - xdebug
  service.running:
    - enable: true
    - watch:
      - pkg: php-fpm
      - file: /etc/php.ini
      - file: /etc/php/fpm.d/www.conf
      - file: /etc/php/conf.d/xdebug.ini

php-ini:
  file.managed:
    - name: /etc/php.ini
    - source: salt://_files/php/php.ini
    - template: jinja
    - require:
      - pkg: php-fpm

php-fpm-www-conf:
  file.managed:
    - name: /etc/php/fpm.d/www.conf
    - source: salt://_files/php/fpm.d/www.conf
    - template: jinja
    - require:
      - pkg: php-fpm

php-fpm-conf:
  file.managed:
    - name: /etc/php-fpm.conf
    - source: salt://_files/php/php-fpm.conf
    - template: jinja
    - require:
      - pkg: php-fpm

php-xdebug-ini:
  file.managed:
    - name: /etc/php/conf.d/xdebug.ini
    - source: salt://_files/php/conf.d/xdebug.ini
    - template: jinja
    - require:
      - pkg: php-fpm

php-pecl-redis:
  cmd.run:
    - user: root
    - name: /usr/bin/pecl install redis
    - unless: test -f /usr/lib/php/modules/redis.so

php-redis-ini:
  file.managed:
    - name: /etc/php/conf.d/redis.ini
    - source: salt://_files/php/conf.d/redis.ini
    - template: jinja
    - require:
      - pkg: php-fpm