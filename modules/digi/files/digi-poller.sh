#!/bin/sh

set -e

if [ ! -r /etc/default/digi-poller ]; then
  echo "Couldn't read defaults file, exiting (did you run me as root?)."
  exit 1
fi

. /etc/default/digi-poller

cd /u/apps/digi/current

POLLER_ARGS="-u ${DIGI_USERNAME} -p ${DIGI_PASSWORD}"

if [ ! -z "${CACHE_FILE}" ]; then
  POLLER_ARGS="${POLLER_ARGS} -c ${CACHE_FILE}"
fi

if [ ! -z "${DISPLAY_FILES}" ]; then
  POLLER_ARGS="${POLLER_ARGS} -o ${DISPLAY_FILES}"
fi

YESTERDAY="$(date --date=yesterday +%F)"
POLLER_ARGS="${POLLER_ARGS} --dated-since=${YESTERDAY}"

ruby1.8 -S /usr/local/bin/bundle exec ewgeco-display-poller ${POLLER_ARGS} "$@" poll
