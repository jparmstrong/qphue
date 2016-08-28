#!/bin/bash

export PORT_NUMBER=8090

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export LOG_DIR=$DIR/log
export LOG_FILE=$LOG_DIR/qphue.log
export LOG_ARCHIVE_FILE=$LOG_DIR/qphue.archive.log
export PID_FILE=$LOG_DIR/qphue.pid

mkdir -p $LOG_DIR

start () {
  if [ -e $PID_FILE ]; then
    local PID=`cat $PID_FILE`
    if ps -p $PID > /dev/null ; then
      echo "qphue ($PID) is already running!"
      return 1
    fi
  fi
	nohup q lights.q -p $PORT_NUMBER >> $LOG_FILE 2>&1  & 
	echo $! > $PID_FILE
  echo "qphue started!"
}

stop () {
  if [ ! -e $PID_FILE ]; then
    echo "No PID file. Must not be running!"
    return 1
  fi
	local PID=`cat $PID_FILE`
	kill $PID
	sleep 1
	if ps -p $PID > /dev/null ; then
		echo "qphue ($PID) is still running"
		kill -9 $PID
	fi
  echo "qphue stopped!"
  cat $LOG_FILE >> $LOG_ARCHIVE_FILE
  rm $LOG_FILE
  rm $PID_FILE
}

status () {
  if [ ! -e $PID_FILE ]; then
    echo "No PID file. Must not be running!"
    exit 1
  fi
	local PID=`cat $PID_FILE`
  if ps -p $PID > /dev/null ; then
	  echo "qphue ($PID) is running, tailing log file : $LOG_FILE"
	  tail $LOG_FILE
  else
    echo "qphue is not running";
  fi
}

case "$1" in
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
      status
      ;;
    *)
      echo $"Usage: $0 {start|stop|restart|status}"
      exit 1
esac
