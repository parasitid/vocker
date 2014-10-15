#!/bin/bash
VERSION={{ VERTX_VERSION }}
curl -s get.gvmtool.net | bash
source "/root/.gvm/bin/gvm-init.sh"
gvm install vertx ${VERSION:-2.1.2}
gvm use vertx ${VERSION:-2.1.2}
