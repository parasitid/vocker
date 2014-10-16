#!/bin/bash
# Description: This shell script takes care of starting and stopping the Verticle in a docker container
# chkconfig: - 80 20
#
## Source function library.
#. /etc/rc.d/init.d/functions
source $(dirname $0)/.envrc

SHUTDOWN_WAIT=20

docker_image() {
    echo "${VERTICLE_NAME%~*}/${VERTICLE_NAME#*~}:${VERTICLE_VERSION}"
}

verticle_ip() {
    echo $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $1)
}

verticle_port() {
    echo $VERTICLE_PORT
}

verticle_pid() {
    echo $(docker ps --no-trunc=true | tail -n +2 | grep $(docker_image) | awk '{print $1}')
}

start() {
  pid=$(verticle_pid)
  port=$(verticle_port)
  if [ -n "$pid" ] 
  then
    echo "Verticle is already running (pid: $pid)"
  else
    # Start verticle
    echo "Starting verticle from docker image $(docker_image)"
    docker run -d -p ${port}:${port} $(docker_image)
  fi

  return 0
}

stop() {
  pid=$(verticle_pid)
  if [ -n "$pid" ]
  then
    echo "Stopping Verticle"
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
    echo "Verticle is not running"
  fi
 
  return 0
}

case $1 in
start)
  start
;; 
stop)   
  stop
;; 
restart)
  stop
  start
;;
status)
  pid=$(verticle_pid)
  if [ -n "$pid" ]
  then
      IP=$(verticle_ip $pid)
      PORT=$(verticle_port)
      echo "Verticle is running on ${IP}:${PORT} with pid: $pid"
  else
      echo "Verticle is not running"
  fi
;; 
esac
exit 0
