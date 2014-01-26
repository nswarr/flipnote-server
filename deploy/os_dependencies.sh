#!/usr/bin/env bash

VMWARE_DEPLOY=$1

#Speeds up local deployments for me significantly
if [ $VMWARE_DEPLOY ]; then
    echo 'deb http://mirrors.mit.edu/ubuntu/ precise main universe' > /etc/apt/sources.list
    echo 'deb-src http://mirrors.mit.edu/ubuntu/ precise main universe' >> /etc/apt/sources.list
    echo 'deb http://mirrors.mit.edu/ubuntu/ precise-updates main universe' >> /etc/apt/sources.list
    echo 'deb-src http://mirrors.mit.edu/ubuntu/ precise-updates main universe' >> /etc/apt/sources.list
fi

#############################################################
# Build OS environment and get dependencies
#############################################################
apt-get update
apt-get -y upgrade

# We have to install this bullshit because, as always, the standard Ubuntu repo
# has a criminally old version of node
apt-get install -y python-software-properties software-properties-common python g++ make
add-apt-repository -y ppa:chris-lea/node.js
apt-get update

echo '==> Installing base os dependencies'
apt-get -y install nginx nodejs git curl htop monit mongodb

npm install -g grunt-cli grunt request forever