#!/bin/bash
apt-get -y update
apt-get -y install curl
apt-get -y install git-core
apt-get -y install python-software-properties

# nginx
add-apt-repository ppa:nginx/stable
apt-get -y update
apt-get -y install nginx
service nginx start
