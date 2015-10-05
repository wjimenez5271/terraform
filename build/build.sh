#!/bin/bash

set -o nounset -o errexit -o pipefail -o errtrace

SRCROOT="/opt/go"
SRCPATH="/opt/gopath"

# Get the ARCH
ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`

# Install Prereq Packages
apt-get update
apt-get install -y build-essential curl git-core libpcre3-dev mercurial pkg-config zip

# Install Go
cd /tmp
wget -q https://storage.googleapis.com/golang/go1.4.2.linux-${ARCH}.tar.gz
tar -xf go1.4.2.linux-${ARCH}.tar.gz
mv go $SRCROOT
chmod 775 $SRCROOT

# Set up the GOPATH
mkdir -p $SRCPATH

cat <<EOF >/tmp/gopath.sh
export GOPATH="$SRCPATH"
export GOROOT="$SRCROOT"
export PATH="$SRCROOT/bin:$SRCPATH/bin:\$PATH"
EOF
mv /tmp/gopath.sh /etc/profile.d/gopath.sh
chmod 0755 /etc/profile.d/gopath.sh
source /etc/profile.d/gopath.sh

mkdir -p $GOPATH/src/github.com/hashicorp
cd $GOPATH/src/github.com/hashicorp
git clone https://github.com/hashicorp/terraform
cd terraform
git checkout $TERRAFORM_REF
