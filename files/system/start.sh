#!/bin/bash

function xwiki_first_start(){
  echo "CATALINA_OPTS='-Xmx${TOMCAT_RAM:-1024m}'" >> /usr/local/tomcat/bin/setenv.sh

  configure_xwiki

  touch /usr/local/tomcat/.first_start_competed
}

function configure_xwiki(){
  sed -i "s/replacemysqldatabase/${MYSQL_DATABASE:-xwiki}" /usr/local/tomcat/webapps/ROOT/WEB-INF/hibernate.cfg.xml
  sed -i "s/replacemysqlusername/${MYSQL_USERNAME:-xwiki}" /usr/local/tomcat/webapps/ROOT/WEB-INF/hibernate.cfg.xml
  sed -i "s/replacemysqlpassword/${MYSQL_PASSWORD:-xwiki}" /usr/local/tomcat/webapps/ROOT/WEB-INF/hibernate.cfg.xml

  xwiki-set-cfg 'xwiki.store.attachment.hint' 'file'
  xwiki-set-cfg 'xwiki.store.attachment.versioning.hint' 'file'
  xwiki-set-cfg 'xwiki.store.attachment.recyclebin.hint' 'file'
  xwiki-set-cfg 'xwiki.virtual.usepath' '0'
  xwiki-set-cfg 'xwiki.home' "${XWIKI_HOME:-http://localhost:8082}"
  xwiki-set-cfg 'xwiki.url.protocol' "${XWIKI_URL_PROTOCOL:-http}"
  xwiki-set-cfg 'xwiki.webapppath' ''
  xwiki-set-cfg 'xwiki.showviewaction' '0'
  xwiki-set-cfg 'xwiki.authentication.validationKey' "$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
  xwiki-set-cfg 'xwiki.authentication.encryptionKey' "$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
  xwiki-set-cfg 'xwiki.authentication.cookiedomains' "${XWIKI_AUTHENTICATION_COOKIEDOMAINS:-localhost}"
  xwiki-set-cfg 'xwiki.stats.default' '1'
  xwiki-set-cfg 'xwiki.editcomment.suggested' '0'

  xwiki-set-property 'environment.permanentDirectory' '/xwiki_data'
  xwiki-set-property 'mail.sender.host' "${MAIL_SENDER_HOST:-localhost}"
  xwiki-set-property 'mail.sender.port' "${MAIL_SENDER_PORT:-25}"
  xwiki-set-property 'mail.sender.from' "${MAIL_SENDER_FROM:-john@doe.com}"
  xwiki-set-property 'mail.sender.username' "${XWIKI_SENDER_USERNAME:-someuser}"
  xwiki-set-property 'mail.sender.password' "${XWIKI_SENDER_PASSWORD:-somepassword}"
}

if [[ ! -f /usr/local/tomcat/.first_start_competed ]]; then
  xwiki_first_start
fi

# wait for mysql
sleep 15

catalina.sh run
