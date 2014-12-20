#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)
ENVIRONMENT="${2:-production}"

sidekiq_pidfile="$DIRECTORY/../tmp/pids/sidekiq.pid"
sidekiq_logfile="$DIRECTORY/../log/sidekiq.log"

COMMAND="RAILS_ENV=$ENVIRONMENT bundle exec thin -C $DIRECTORY/../config/server_$ENVIRONMENT.yml"
SIDEKIQ_START="RAILS_ENV=$ENVIRONMENT bundle exec sidekiq -C $DIRECTORY/../config/sidekiq.yml -e $ENVIRONMENT -P $sidekiq_pidfile -d -L $sidekiq_logfile >> $sidekiq_logfile 2>&1"
SIDEKIQ_STOP="bundle exec sidekiqctl stop $sidekiq_pidfile >> $sidekiq_logfile 2>&1"

case "${1:-''}" in
  'start')
    # put the command to start
    eval "$COMMAND start";
    sleep 3;
    eval $SIDEKIQ_START;
    ;;
  'stop')
    # stop command here
    eval "$COMMAND stop";
    sleep 3;
    eval $SIDEKIQ_STOP;
    ;;
  'restart')
    # restart command here
    eval "$COMMAND restart";
    sleep 3;
    eval "$SIDEKIQ_STOP";
    sleep 3;
    eval $SIDEKIQ_START;
    ;;
  'clear')
    # delete stale pids
    eval "$COMMAND stop";
    eval $SIDEKIQ_STOP;
    ;;
  *)
    echo "Usage: $SELF start|stop|restart|clear"
    exit 1
    ;;
esac
