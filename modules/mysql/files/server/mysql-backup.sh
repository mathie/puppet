#!/bin/sh

set -e

if [ ! -r /etc/default/mysql-server-backup ]; then
  echo "Couldn't read defaults file, exiting (did you run me as root?)."
  exit 1
fi

. /etc/default/mysql-server-backup

MODE="${1}"

if [ -z "${MODE}" ]; then
  echo "Must specify a mode."
  exit 1
fi

if [ ${MODE} != 'full' -a ${MODE} != 'differential' ]; then
  echo "Invalid mode: ${MODE}"
  echo "Usage: ${0} <full|differential>"
  exit 1
fi

BACKUP_DIR=${BACKUP_BASE}/${MODE}

if [ ${MODE} = 'differential' ]; then
  MOST_RECENT_FULL_BACKUP_TIMESTAMP="$(ls -1c ${FULL_BACKUP_DIR} | head -1)"
  MOST_RECENT_FULL_BACKUP="${FULL_BACKUP_DIR}/${MOST_RECENT_FULL_BACKUP_TIMESTAMP}"

  echo "Taking a differential backup from last full backup ${MOST_RECENT_FULL_BACKUP_TIMESTAMP}"

  /usr/bin/innobackupex ${COMMON_INNOBACKUPEX_OPTIONS} --incremental --incremental-basedir=${MOST_RECENT_FULL_BACKUP} ${BACKUP_DIR}
else
  echo "Taking a full backup"

  /usr/bin/innobackupex ${COMMON_INNOBACKUPEX_OPTIONS} ${BACKUP_DIR}
  MOST_RECENT_FULL_BACKUP_TIMESTAMP="$(ls -1c ${FULL_BACKUP_DIR} | head -1)"
fi

NEW_BACKUP_TIMESTAMP="$(ls -1c ${BACKUP_DIR} | head -1)"
NEW_BACKUP_DIR="${BACKUP_DIR}/${NEW_BACKUP_TIMESTAMP}"
TAR_FILENAME="${MODE}-${NEW_BACKUP_TIMESTAMP}.tar.bz2"
TAR_FILE="${BACKUP_TMP}/${TAR_FILENAME}"

(cd ${BACKUP_DIR} && tar jcf ${TAR_FILE} ${NEW_BACKUP_TIMESTAMP})

S3_DESTINATION="s3://${AWS_BUCKET}/${S3_PREFIX}/${MOST_RECENT_FULL_BACKUP_TIMESTAMP}/${TAR_FILENAME}"

(cd ${BACKUP_DIR} && s3cmd ${S3CMD_OPTIONS} put ${TAR_FILE} ${S3_DESTINATION})

rm -f ${TAR_FILE}

if [ ${MODE} = 'differential' ]; then
  echo "Removing differential backup files."
  rm -rf ${NEW_BACKUP_DIR}
else
  PREVIOUS_FULL_BACKUP_TIMESTAMPS="$(ls -1c ${FULL_BACKUP_DIR} | grep -v ${MOST_RECENT_FULL_BACKUP_TIMESTAMP})"
  echo "Removing previous full backup files: ${PREVIOUS_FULL_BACKUP_TIMESTAMPS}"
  for i in ${PREVIOUS_FULL_BACKUP_TIMESTAMPS}; do
    rm -rf ${FULL_BACKUP_DIR}/${i}
  done
fi

echo "Done. Backup (probably) successful."
