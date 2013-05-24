#!/bin/sh

set -e

if [ ! -r /etc/default/mysql-server-backup ]; then
  echo "Couldn't read defaults file, exiting (did you run me as root?)."
  exit 1
fi

. /etc/default/mysql-server-backup

BACKUP_HOSTNAME="${1}"
FULL_TIMESTAMP="${2}"
DIFFERENTIAL_TIMESTAMP="${3}"

if [ -z "${BACKUP_HOSTNAME}" ]; then
  echo "Must specify the hostname of the backup to be restored."
  exit 1
fi

if [ -z "${FULL_TIMESTAMP}" ]; then
  echo "Must specify the timestamp of the full backup to be restored."
  exit 1
fi

cd ${BACKUP_TMP}

FULL_BACKUP_DIRECTORY="${BACKUP_TMP}/${FULL_TIMESTAMP}"
FULL_BACKUP_TAR_FILE="full-${FULL_TIMESTAMP}.tar.bz2"
S3_FULL_BACKUP="s3://${AWS_BUCKET}/${BACKUP_HOSTNAME}/${FULL_TIMESTAMP}/${FULL_BACKUP_TAR_FILE}"

if [ ! -f "${FULL_BACKUP_TAR_FILE}" ]; then
  s3cmd ${S3CMD_OPTIONS} get ${S3_FULL_BACKUP} ${FULL_BACKUP_TAR_FILE}
fi

tar jxf ${FULL_BACKUP_TAR_FILE}
innobackupex --apply-log --redo-only ${FULL_BACKUP_DIRECTORY}

if [ ! -z "${DIFFERENTIAL_TIMESTAMP}" ]; then
  DIFFERENTIAL_BACKUP_DIRECTORY="${BACKUP_TMP}/${DIFFERENTIAL_TIMESTAMP}"
  DIFFERENTIAL_BACKUP_TAR_FILE="differential-${DIFFERENTIAL_TIMESTAMP}.tar.bz2"
  S3_DIFFERENTIAL_BACKUP="s3://${AWS_BUCKET}/${BACKUP_HOSTNAME}/${FULL_TIMESTAMP}/${DIFFERENTIAL_BACKUP_TAR_FILE}"

  if [ ! -f "${DIFFERENTIAL_BACKUP_TAR_FILE}" ]; then
    s3cmd ${S3CMD_OPTIONS} get ${S3_DIFFERENTIAL_BACKUP} ${DIFFERENTIAL_BACKUP_TAR_FILE}
  fi

  tar jxf ${DIFFERENTIAL_BACKUP_TAR_FILE}
  innobackupex --apply-log --redo-only ${FULL_BACKUP_DIRECTORY} --incremental-dir=${DIFFERENTIAL_BACKUP_DIRECTORY}
  rm -rf ${DIFFERENTIAL_BACKUP_DIRECTORY}
fi

innobackupex --apply-log ${FULL_BACKUP_DIRECTORY}

service mysql stop
rm -rf /var/lib/mysql/*
innobackupex --copy-back ${FULL_BACKUP_DIRECTORY}
chown -R mysql:mysql /var/lib/mysql
chmod -R ug=rwX,o-rwx /var/lib/mysql
service mysql start

DEBIAN_SYS_MAINT_PASSWORD=$(awk '/password/ { print $3;exit }' /etc/mysql/debian.cnf)
if [ ! -z "${DEBIAN_SYS_MAINT_PASSWORD}" ]; then
  mysql -u root -p -e "UPDATE mysql.user SET Password=PASSWORD('${DEBIAN_SYS_MAINT_PASSWORD}') WHERE User='debian-sys-maint'; FLUSH PRIVILEGES;"
fi

rm -rf ${FULL_BACKUP_DIRECTORY}
