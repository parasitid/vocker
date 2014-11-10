#!/bin/bash
# Description: This shell script takes care of starting and stopping a
# localhost docker registry
# chkconfig: - 80 20
#
## Source function library.
#. /etc/rc.d/init.d/functions
source $(dirname $0)/.envrc

SHUTDOWN_WAIT=20

docker_image() {
    echo "registry"
}

registry_port() {
    if [ "$DOCKER_REGISTRY_ENDPOINT" == "" ]; then
        echo
        "no DOCKER_REGISTRY_ENDPOINT env var defined. (eg: \"localhost:5000\")"
    fi

    echo $(echo $DOCKER_REGISTRY_ENDPOINT | cut -d: -f2 | cut -d\/ -f1)
}

registry_pid() {
    echo $(docker ps --no-trunc=true | tail -n +2 | grep registry | awk '{print $1}')
}

start() {
    pid=$(registry_pid)
    port=$(registry_port)
    if [ -n "$pid" ] 
    then
        echo "Registry is already running (pid: $pid)"
    else
        # Start verticle
        echo "Starting docker registry on $DOCKER_REGISTRY_ENDPOINT"
        docker run -d -p ${port}:${port} -e STORAGE_PATH=~/.dockerreg registry
    fi
    
    return 0
}


stop() {
  pid=$(registry_pid)
  if [ -n "$pid" ]
  then
    echo "Stopping Registry"
    docker stop $pid

    let kwait=$SHUTDOWN_WAIT
    count=0;
    until [ `docker ps | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
      echo -n -e "\nwaiting for processes to exit";
      sleep 1
      let count=$count+1;
    done

    if [ $count -gt $kwait ]; then
      echo -n -e "\nkilling processes which didn't stop after $SHUTDOWN_WAIT seconds"
      docker kill $pid
    fi
  else
    echo "Registry is not running"
  fi
 
  return 0
}

case $1 in
start)
  shift 
  start $*
;; 
startreg)
  shift 
  startreg $*
;; 
stop)   
  stop
;; 
restart)
  stop
  start
;;
status)
  pid=$(registry_pid)
  if [ -n "$pid" ]
  then
      PORT=$(registry_port)
      echo "Registry is running on $DOCKER_REGISTRY_ENDPOINT with pid: $pid"
  else
      echo "Registry is not running"
  fi
;; 
esac
exit 0
