#!/bin/bash

echo "running verticle {{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }} on port {{ VERTICLE_PORT }}"
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

if [ ! -x $JAVA_HOME/bin/javac ]; then 
   echo "no proper jdk found. check install. exiting"
   exit 1
fi

/root/.gvm/vertx/{{ VERTX_VERSION }}/bin/vertx runzip /opt/{{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }}.zip
