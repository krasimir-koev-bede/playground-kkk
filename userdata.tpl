#!/bin/bash

yum install -y epel-release
yum install -y nginx
systemctl restart nginx

echo "Finished!"