# docker_xwiki

Dockerfile for XWiki

## Usage

See `docker-compose.yml` for example.

## Variables

### Tomcat configuration

| Variable | Default | Description|
|-----------|---|----|
| TOMCAT_RAM | 1024m | equivalent to CATALINA_OPTS='-Xmx1024m' |

### xwiki.cfg parameters

All variable like `XWIKI_PARAM_NAME` are equivalents of the configuration parameters in xwiki.cfg like `xwiki.param.name`.

| Variable | Default | Description|
|-----------|---|----|
| XWIKI_HOME | http://localhost:8080 | The domain name to use when creating URLs to the default wiki. |
| XWIKI_AUTHENTICATION_COOKIEDOMAINS | localhost | For which part of the Wiki domain the cookie is valid for (E.g. if set to 'mydomain.com' it is also valid for 'xwiki1.mydomain.com', 'xwiki2.mydomain.com' and so on.) |
| XWIKI_URL_PROTOCOL | http | Force the protocol to use in the generated URLs. |

### xwiki.properties parameters

All variable like `XWIKI_PARAM_NAME` are equivalents of the configuration parameters in xwiki.properties like `xwiki.param.name`.

| Variable | Default | Description|
|-----------|---|----|
| MAIL_SENDER_HOST | localhost | SMTP host when sending emails. |
| MAIL_SENDER_PORT | 25 | SMTP port when sending emails. |
| MAIL_SENDER_FROM | john@doe.com | From email address to use. |
| XWIKI_SENDER_USERNAME | someuser | Username to authenticate on the SMTP server. |
| XWIKI_SENDER_PASSWORD | somepassword | Password to authenticate on the SMTP server. |

## Backup

* Backup permanentDirectory `/xwiki_data`
* Backup Database
