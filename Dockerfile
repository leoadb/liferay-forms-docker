FROM java:8-jdk

MAINTAINER Leonardo Barros

EXPOSE 8000 8080 11311

RUN mkdir /liferay \
  && mkdir /liferay/data \
  && mkdir /liferay/deploy \
  && mkdir /liferay/logs \
  && mkdir /liferay/osgi \
  && mkdir /liferay/tomcat \
  && chmod -R 777 /liferay

ENV LIFERAY_HOME="/liferay"
ENV TOMCAT_DIR="$LIFERAY_HOME/tomcat"
ENV LIFERAY_CLASSPATH="$TOMCAT_DIR/lib,$TOMCAT_DIR/lib/ext,$TOMCAT_DIR/webapps/ROOT/WEB-INF/lib"
ENV CATALINA_OPTS="$CATALINA_OPTS -Dfile.encoding=UTF8 -Djava.net.preferIPv4Stack=true  -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

COPY ./deploy /liferay/deploy
COPY ./osgi /liferay/osgi
COPY ./tomcat/bin /liferay/tomcat/bin
COPY ./tomcat/conf /liferay/tomcat/conf
COPY ./tomcat/lib /liferay/tomcat/lib
COPY ./tomcat/webapps /liferay/tomcat/webapps

RUN rm -f /liferay/tomcat/webapps/ROOT/WEB-INF/classes/portal-ext.properties \
  && touch /liferay/portal-setup-wizard.properties \
  && echo $'admin.email.from.address=test@liferay.com\n\
     admin.email.from.name=Test Test\n\
     company.default.locale=en_US\n\
     company.default.web.id=liferay.com\n\
     default.admin.email.address.prefix=test\n\
     liferay.home=/liferay\n\
     setup.wizard.add.sample.data=on\n\
     setup.wizard.enabled=false' >> /liferay/portal-setup-wizard.properties

ENTRYPOINT ["/liferay/tomcat/bin/catalina.sh"]

CMD ["run"]
