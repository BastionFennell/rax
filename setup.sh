#!/bin/bash
apt-get -y update
apt-get -y install curl git-core python-software-properties

# nginx
add-apt-repository ppa:nginx/stable
apt-get -y update
apt-get -y install nginx
service nginx start
