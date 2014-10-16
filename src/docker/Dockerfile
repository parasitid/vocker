FROM    ubuntu:14.04

# install system
RUN     apt-get update
RUN     apt-get install -y unzip curl zip openjdk-7-jdk

# add resources
ADD     . /opt

# install vertx and verticles
RUN     chmod +x /opt/scripts/vertx_install.sh
RUN     chmod +x /opt/scripts/vertx_run.sh
RUN     /opt/scripts/vertx_install.sh

ENV listen_port {{ VERTICLE_PORT }}
#startup
EXPOSE {{ VERTICLE_PORT }}

ENTRYPOINT ["/opt/scripts/vertx_run.sh"]