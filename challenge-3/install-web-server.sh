#!/bin/bash
apt update
apt install apache2 -y
echo "It works!" > /var/www/html/index.html
