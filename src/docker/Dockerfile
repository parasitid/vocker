FROM    ubuntu:14.04

# install system
RUN     apt-get update && apt-get install -y zip unzip curl openjdk-8-jdk

# install vertx
ADD     ./scripts/vertx_install.sh /opt/scripts/vertx_install.sh
RUN     chmod +x /opt/scripts/vertx_install.sh
RUN     /opt/scripts/vertx_install.sh

# install verticle
ADD     ./{{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }}.zip /opt/{{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }}.zip

# listen port declaration
ENV listen_port {{ VERTICLE_PORT }}
EXPOSE {{ VERTICLE_PORT }}

# run verticle within a vertx container
ADD     ./scripts/vertx_run.sh     /opt/scripts/vertx_run.sh
RUN     chmod +x /opt/scripts/vertx_run.sh

ENTRYPOINT ["/opt/scripts/vertx_run.sh"]
