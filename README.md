vocker
======

### Description
  run vertx verticle inside docker container

### Requirements
  * a JDK
  * a proper vertx install
    look at [src/scripts/vertx_install.sh] to install vertx on your host via gvm
  * a proper docker install [with non-root access](https://docs.docker.com/installation/ubuntulinux/#giving-non-root-access)
  * direnv, but not mandatory 

### Usage
  * $ make build-img
    builds docker image ready to work with vertx (including verticle deps)
  * $ ./vocker.sh start
    launches image with ping pong verticle sample
