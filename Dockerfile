FROM tomcat:7.0.69-jre8
MAINTAINER Thomas Steinbach (@aikq.de)

# install libraries for LaTeX formulas in XWiki
RUN apt-get update && \
            DEBIAN_FRONTEND=noninteractive apt-get install -y \
              texlive-binaries \
              dvipsk-ja \
              imagemagick-common && \
            apt-get clean

# Remove other Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/ROOT && \
    rm -rf /usr/local/tomcat/webapps/docs && \
    rm -rf /usr/local/tomcat/webapps/manager && \
    rm -rf /usr/local/tomcat/webapps/examples && \
    rm -rf /usr/local/tomcat/webapps/host-manager

# download and extract xwiki
RUN curl -o /tmp/xwiki.war -SL 'http://download.forge.ow2.org/xwiki/xwiki-enterprise-web-7.4.5.war' && \
    unzip -qq /tmp/xwiki.war -d /usr/local/tomcat/webapps/ROOT && \
    rm /tmp/xwiki.war

# download and extract mysql connector j to xwiki library directory
RUN curl -SL 'https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.39.tar.gz' | \
      tar xzf - --strip=1 -C /usr/local/tomcat/lib mysql-connector-java-5.1.39/mysql-connector-java-5.1.39-bin.jar

# for testing
# RUN apt-get update && apt-get install -y vim

# Tomcat configuration
ADD files/tomcat_conf/context.xml /usr/local/tomcat/conf/context.xml
RUN echo 'export JAVA_OPTS="${JAVA_OPTS} -Djava.awt.headless=true"' >> /usr/local/tomcat/bin/setenv.sh

# XWiki database configuration
ADD files/xwiki_cfg/hibernate.cfg.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/hibernate.cfg.xml

# Add configuration scripts
ADD files/system/xwiki-config-replace.sh /usr/local/bin/xwiki-config-replace.sh
ADD files/system/xwiki-set-cfg /usr/local/bin/xwiki-set-cfg
ADD files/system/xwiki-set-property /usr/local/bin/xwiki-set-property
RUN cd /usr/local/bin && chmod 0755 xwiki-config-replace.sh xwiki-set-cfg xwiki-set-property

# persistent data directory
RUN mkdir /xwiki_data
VOLUME /xwiki_data

# setup start script
ADD files/system/start.sh /usr/local/bin/start.sh
RUN chmod 0755 /usr/local/bin/start.sh
CMD ["start.sh"]
