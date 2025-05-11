FROM debian:10

WORKDIR /mnt/website
EXPOSE 8080/tcp

COPY java.deb /tmp/java.deb

RUN apt update \
 && apt install -y curl \
 && (dpkg -i /tmp/java.deb || (apt install -fy && dpkg -i /tmp/java.deb)) \
 && apt-get clean \
 && rm -rf \
      /var/lib/apt/lists/* \
      /tmp/* \
      /var/tmp/* \
;

HEALTHCHECK --interval=5m CMD curl --fail http://127.0.0.1:8080/ping

CMD ["java", \
    "-Dserver.forward-headers-strategy=native", \
    "-Dserver.tomcat.basedir=/tmp/tomcat", \
    "-Dserver.tomcat.accesslog.directory=logs", \
    "-Dserver.tomcat.accesslog.enabled=true", \
    "-jar", "website.jar", \
""]
