#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

HOSTNAME=${1}
DOMAINNAME=${2}
PUPPETMASTER_IP=${3}

# Set the hostname
if [ $(hostname) != ${HOSTNAME} ]; then
  echo ${HOSTNAME} > /etc/hostname
  hostname ${HOSTNAME}
  domainname ${DOMAINNAME}

  sed -i "s/vagrant-ubuntu-precise-pangolin/${HOSTNAME}.${DOMAINNAME} ${HOSTNAME}/g" /etc/hosts

  # Restart syslog so it starts logging with the right hostname early on.
  service rsyslog restart
fi

if ! grep 'puppet$' /etc/hosts >/dev/null 2>&1; then
  echo "${PUPPETMASTER_IP} puppet.${DOMAINNAME} puppet" >> /etc/hosts
fi

# Easiest way to add PPA repos, along with their PGP keys
if [ ! -f /usr/bin/add-apt-repository ]; then
  apt-get update -qq
  apt-get install -y -qq -o DPkg::Options::=--force-confnew python-software-properties
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
apt-get install -qq -y -o DPkg::Options::=--force-confnew ruby1.8 puppet

# At this point, we should have a bleeding edge stable puppet and Ruby, ready
# for Puppet to start doing its thing.
