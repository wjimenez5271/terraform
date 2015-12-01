#!/bin/bash

set -e

GOVERSION="1.5.1"
SRCROOT="/opt/go"
SRCPATH="/opt/gopath"

# Get the ARCH
ARCH=`uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|'`

# Install Prereq Packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get update
sudo apt-get install -y build-essential curl git-core libpcre3-dev mercurial pkg-config zip

# Install Go
cd /tmp
wget --quiet https://storage.googleapis.com/golang/go${GOVERSION}.linux-${ARCH}.tar.gz
tar -xvf go${GOVERSION}.linux-${ARCH}.tar.gz
sudo mv go $SRCROOT
sudo chmod 775 $SRCROOT
sudo chown ubuntu:ubuntu $SRCROOT

# Setup the GOPATH; even though the shared folder spec gives the working
# directory the right user/group, we need to set it properly on the
# parent path to allow subsequent "go get" commands to work.
sudo mkdir -p $SRCPATH
sudo chown -R ubuntu:ubuntu $SRCPATH

cat <<EOF >/tmp/gopath.sh
export GOPATH="$SRCPATH"
export GOROOT="$SRCROOT"
export PATH="$SRCROOT/bin:$SRCPATH/bin:\$PATH"
EOF
sudo mv /tmp/gopath.sh /etc/profile.d/gopath.sh
sudo chmod 0755 /etc/profile.d/gopath.sh
source /etc/profile.d/gopath.sh

# Clone Terraform into its proper gopath
mkdir -p $SRCPATH/src/github.com/hashicorp/
git clone https://github.com/hashicorp/terraform $SRCPATH/src/github.com/hashicorp/terraform

