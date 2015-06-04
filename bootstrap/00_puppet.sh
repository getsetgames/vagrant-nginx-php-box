#!/bin/bash

set -e

if which puppet > /dev/null 2>&1 -a apt-cache policy | grep --quiet apt.puppetlabs.com; then
  echo "Puppet is already installed."
  exit 0
fi

# Do the initial apt-get update
echo "Initial apt-get update..."
apt-get update >/dev/null

# Install wget if we have to (some older Ubuntu versions)
echo "Installing wget..."
apt-get install -y wget >/dev/null

# Load up the Ubuntu release information
. /etc/lsb-release

# Add Puppet Labs apt repository...
REPO_DEB_URL="http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb"
echo "Configuring PuppetLabs repo..."
repo_deb_path=$(mktemp)
wget --output-document="${repo_deb_path}" "${REPO_DEB_URL}" 2>/dev/null
dpkg -i "${repo_deb_path}" >/dev/null
apt-get update >/dev/null

# Install Puppet from the PuppetLabs repo
echo "Installing Puppet..."
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install puppet >/dev/null
echo "Puppet installed!"

# Install RubyGems for the provider
echo "Installing RubyGems..."
if [ $DISTRIB_CODENAME != "trusty" ]; then
  apt-get install -y rubygems >/dev/null
fi
gem install --no-ri --no-rdoc rubygems-update
update_rubygems >/dev/null

# Configure hiera
echo "Configuring hiera..."
cp /vagrant/templates/hiera.yaml.erb /etc/puppet/hiera.yaml
