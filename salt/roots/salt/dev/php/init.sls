php-install:
  pkg.latest:
    - names:
      - php
      - php-fpm
      - php-intl
      - php-pear
      - php-pgsql
      - xdebug
  service.running:
    - name: php-fpm
    - enable: true
    - watch:
      - pkg: php-install
      - file: /etc/php/php.ini
      - file: /etc/php/php-fpm.conf
      - file: /etc/php/fpm.d/www.conf
      - file: /etc/php/conf.d/xdebug.ini

php-ini:
  file.managed:
    - name: /etc/php/php.ini
    - source: salt://_files/php/php.ini
    - template: jinja
    - require:
      - pkg: php-install

php-fpm-www-conf:
  file.managed:
    - name: /etc/php/fpm.d/www.conf
    - source: salt://_files/php/fpm.d/www.conf
    - template: jinja
    - require:
      - pkg: php-install

php-fpm-conf:
  file.managed:
    - name: /etc/php/php-fpm.conf
    - source: salt://_files/php/php-fpm.conf
    - template: jinja
    - require:
      - pkg: php-install

php-xdebug-ini:
  file.managed:
    - name: /etc/php/conf.d/xdebug.ini
    - source: salt://_files/php/conf.d/xdebug.ini
    - template: jinja
    - require:
      - pkg: php-install

php-git-phpredis:
  git.latest:
    - name: https://github.com/phpredis/phpredis.git
    - rev: 2.2.7
    - target: /tmp/phpredis
    - unless: test -f /usr/lib/php/modules/redis.so
    - require:
      - pkg: php-install

php-phpredis-build:
  cmd.run:
    - cwd: /tmp/phpredis
    - name: 'PHPIZE=`which phpize`; $PHPIZE && ./configure && make && make install; rm -fr /tmp/phpredis'
    - user: root
    - require:
      - git: php-git-phpredis

php-redis-ini:
  file.managed:
    - name: /etc/php/conf.d/redis.ini
    - source: salt://_files/php/conf.d/redis.ini
    - template: jinja
    - onlyif: test -f /usr/lib/php/modules/redis.so
