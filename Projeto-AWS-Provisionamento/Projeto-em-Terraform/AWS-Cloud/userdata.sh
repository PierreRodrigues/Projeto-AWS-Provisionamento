#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Servidor rodando em $(hostname -f)</h1>" > /var/www/html/index.html
chown apache:apache /var/www/html/index.html