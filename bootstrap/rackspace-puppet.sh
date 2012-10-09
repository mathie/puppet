#!/bin/sh -e

export DEBIAN_FRONTEND=noninteractive

HOSTNAME=${1}
DOMAINNAME=${2}
PUPPET_MANIFEST=${3}
PUPPETMASTER_IP=${4}
FQDN=${HOSTNAME}.${DOMAINNAME}

# Set the hostname
echo ${FQDN} > /etc/hostname
hostname ${FQDN}
domainname ${DOMAINNAME}

echo '127.0.0.1 localhost' > /etc/hosts
echo "127.0.1.1 ${HOSTNAME} ${FQDN}" >> /etc/hosts

# Restart syslog so it starts logging with the right hostname early on.
service rsyslog restart

if ! grep 'puppet' /etc/hosts >/dev/null 2>&1; then
  if [ ! -z "${PUPPETMASTER_IP}" ]; then
    echo "${PUPPETMASTER_IP} puppet.${DOMAINNAME} puppet" >> /etc/hosts
  fi
fi

apt-get update -qq
apt-get autoremove --purge -qq -y puppet-common puppet
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
apt-get install -qq -y ruby1.8 puppet git

mkdir -p ~/.ssh
cat > ~/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAxqJoi5kgSvWpVJduRmOlb6aCCBH4uFqXrqyKhS9hqnCtngY7
R2ecPQeVKZnH16TMNsCkuwRAM6vr2kbhERy3PlXbylk/fS67yTCz0/9JuL6+u5j8
JV50ZErED5lfRvywOrT2IOB+pjG1SMcU8MQXAR3GiYI7egCZwF3Irvz6FGOLdEZF
ivE+49pb5WxKd/sT27p5cqGvLp8/gsTa6v9wiSoaNJDXkuHILgvD8Bm4zd5re4tf
oU6a4Y4bgKuanVAmny3f+R9eIRs36qQdN6jhHr9graOWpm2/c3VjcBdWtOqTBN9q
2/Y0HbKQPDFW+Pc19v7XdlCjh3EJPKkXz861fQIDAQABAoIBAAynZf+Wpq7/zWS9
LOJBENX3BoubEXw1ETqodT6c0Rz5hqXtgbM/z3030XHQASIktnm6dgQP9kMUbbb/
EvFzId1PvOu8GcZQxte/SYV02u5xAFeVHGMJDGMjPDA+NgqgqF1lD9TyWD8gJYtY
W2YnJ8wDaJVz/XP9O848az9ykD/iJsxl2DQLggEkkPydc8Qbjz9SPI5ZNPxQm/qj
aRVmazKaljLrtc3Y1Bd+ZUzM2MdVhXpmvZVBO+JknY18mTJxmzy+o0M8CnJ8uaKC
8KD7R/bpuJu7MQSZ3cz13eaHTopcboRWuzKr09xujAUYMziKToac9o4qMgQ2CGAL
GBM54YECgYEA6nHeUGAUPEpxFZ+mRFn+tbYHnDrUIVkYZlPNwpE2YIGcF72Ijbms
XOvt55HosqXr6XbSh05/Zz0uEjiFlszgGQqmLHyolFo3EHAEdJgsnCbo2sd3ltNO
MWKSM5ZXTPBxYTDM2HT29cMvSuDY5s9EbDimF4GMDwy+quQs2fDM6Z0CgYEA2OWr
jcsKv/f9Kf5+7wcIfKEZ0tHJDrDx86hJ1EzRDvxYzFoYnaKY8NlbUD7pH+Xzj9HQ
sswq7IltGaW1o7oxCdF8uZB/BjQWPjaWZCLk4VDEdrnaCItjl7QSxximKHJPUoZO
kZSdl/vQUbQemLWnUVI21LwgPQQLbT244JZ4pWECgYEA2gg9/bfs+cktdDO+eHDN
vgZk+3mGkOEAHSIxCJLt5ECFf1qoJU4ZK23LGgKLS6GdTclQr79kIwo1z4I7UuyE
OSW7N0JTsWxZK3NR4XEog6x4AAdjg6ROYwVN/KYD2K0AdKfiyie1CQiV8eg8MCNw
eckRRmkXbWOn6tw7jhAxMc0CgYAXHtRctwocUIkSEujg/fTvpBSmnmo6QK5p9MR5
9v5KBKhKkEgTdaOr+N98/FfJaK+/4vPGO3FP6Y5Rr5JfM5fKniQXe8mulZrRYuxB
HF8djYiDx2fwhTtGjpF526zKnvTJrTtu1VK/Qr6AFx0z1hlR19u0baFaH7ZAHNY6
So/twQKBgQCNb/DgKZEGRLWp7PVJZtp7C5/DJg0cw0mR69jBMPMKwLUFVSER5Qwd
MGW/yBAL8d3BY4LcuoNueOJB36ICiA2fmxgXfsyfHnTMjYMSN3zMoT8J7awv9Lpd
49ut4x734L0hhCuqeT55z1ZnvUtXR+S/1CtjIhFMA2QipL2HMnznnQ==
-----END RSA PRIVATE KEY-----
EOF

chmod -R go-rwx ~/.ssh

eval $(ssh-agent)
trap "kill ${SSH_AGENT_PID}" EXIT

mkdir -p /tmp/puppet-bootstrap
cd /tmp/puppet-bootstrap

ssh-keyscan github.com >> ~/.ssh/known_hosts

git clone -q git@github.com:rubaidh/puppet.git puppet

cd puppet
puppet apply --modulepath=`pwd`/modules --manifestdir=`pwd`/manifests `pwd`/manifests/bootstrap/${PUPPET_MANIFEST}.pp

shutdown -r now
