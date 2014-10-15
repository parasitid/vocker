#!/bin/bash
cd /opt/mods
/root/.gvm/vertx/current/bin/vertx runzip /opt/{{ VERTICLE_NAME }}~{{ VERTICLE_VERSION }}.zip
