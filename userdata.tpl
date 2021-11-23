#!/bin/bash
echo ${password} | sudo -S su
yum install -y epel-release
yum install -y nginx
systemctl restart nginx

echo "Finished!"