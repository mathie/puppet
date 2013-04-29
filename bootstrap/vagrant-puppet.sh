#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

HOSTNAME=${1}
DOMAINNAME=${2}
PUPPET_MANIFEST=${3}
PUPPETMASTER_IP=${4}
FQDN=${HOSTNAME}.${DOMAINNAME}

set_hostname() {
  if grep "${FQDN}" /etc/hostname >/dev/null; then
    return
  fi

  echo ${FQDN} > /etc/hostname
  hostname ${FQDN}
  domainname ${DOMAINNAME}

  echo '127.0.0.1 localhost' > /etc/hosts
  echo "127.0.1.1 ${FQDN} ${HOSTNAME}" >> /etc/hosts

  # This is one of the places Facter will use to get its domain name, so let's
  # have a little defense in depth.
  echo 'nameserver 8.8.8.8'    > /etc/resolv.conf
  echo 'nameserver 8.8.4.4'   >> /etc/resolv.conf
  echo "domain ${DOMAINNAME}" >> /etc/resolv.conf

  # Restart syslog so it starts logging with the right hostname early on.
  service rsyslog restart
}

set_puppetmaster_ip() {
  if ! grep 'puppet' /etc/hosts >/dev/null 2>&1; then
    if [ ! -z "${PUPPETMASTER_IP}" ]; then
      echo "${PUPPETMASTER_IP} puppet.${DOMAINNAME} puppet" >> /etc/hosts
    fi
  fi
}

setup_base_packages() {
  if [ -x /usr/bin/puppet ]; then
    if puppet --version | grep '^3' >/dev/null; then
      return
    fi
  fi

  apt-get update -qq
  apt-get autoremove -qq -y puppet-common puppet
  apt-get dist-upgrade -qq -y

  # Easiest way to add PPA repos, along with their PGP keys
  if [ ! -f /usr/bin/add-apt-repository ]; then
    apt-get install -y -qq python-software-properties
  fi

  # Recent build of Ruby 1.8.7 (REE), 1.9 and a way for them to happily coexist.
  if [ ! -f /etc/apt/sources.list.d/brightbox-ruby-ng-experimental-precise.list ]; then
    add-apt-repository -y ppa:brightbox/ruby-ng-experimental
  fi

  # Of course, we have to do the puppet labs one manually...
  if [ ! -f /etc/apt/sources.list.d/puppetlabs.list ]; then
    curl -s http://apt.puppetlabs.com/pubkey.gpg | apt-key  add -
    cat > /etc/apt/sources.list.d/puppetlabs.list <<EOF
deb http://apt.puppetlabs.com/ precise main dependencies
deb-src http://apt.puppetlabs.com/ precise main dependencies
EOF
  fi

  apt-get update -qq
  apt-get install -qq -y ruby1.9.3 puppet
}

set_hostname
set_puppetmaster_ip
setup_base_packages
