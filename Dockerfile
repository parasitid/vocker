FROM    ubuntu:14.04

# install system
RUN     apt-get update
RUN     apt-get install -y unzip curl zip openjdk-7-jdk

# add resources
ADD     ./build /opt

# install vertx and verticles
RUN     chmod +x /opt/scripts/vertx_install.sh
RUN     chmod +x /opt/scripts/vertx_run.sh
RUN     /opt/scripts/vertx_install.sh


#startup
EXPOSE 3110

ENTRYPOINT ["/opt/scripts/vertx_run.sh"]