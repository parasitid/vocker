#!/bin/bash

echo "running verticle {{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }} on port {{ VERTICLE_PORT }}"
/root/.gvm/vertx/current/bin/vertx runzip /opt/{{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }}.zip
