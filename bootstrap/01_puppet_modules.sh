#!/bin/bash

set -e

# install r10k (to manage puppet modules)
if gem list -i r10k | grep --quiet 'true'; then
    echo "r10k already installed"
else
    gem install r10k
fi

# Install puppet modules
VAGRANT_ROOT="/vagrant"
export PUPPETFILE="$VAGRANT_ROOT/Puppetfile"
export PUPPETFILE_DIR="/etc/puppet/modules"

echo "Installing Puppet modules..."
r10k puppetfile install

# ensure apt repositories are up to date before running puppet
apt-get update
