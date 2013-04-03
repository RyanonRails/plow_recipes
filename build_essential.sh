#!/bin/bash

# This line is necessary for automated provisioning for Debian/Ubuntu.
# Remove if you're not on Debian/Ubuntu.
export DEBIAN_FRONTEND=noninteractive

aptitude update
aptitude -y safe-upgrade
aptitude -y install git-core ntp
apt-get -y install curl build-essential libssl-dev libreadline6-dev
