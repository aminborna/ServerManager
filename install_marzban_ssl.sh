#!/bin/bash

read -p "Enter your subdomain (e.g., sub.example.com): " DOMAIN

apt-get update && apt-get install certbot -y

certbot certonly --standalone --agree-tos --register-unsafely-without-email -d "$DOMAIN"

mkdir -p /var/lib/marzban/certs/

cp /etc/letsencrypt/live/"$DOMAIN"/fullchain.pem /var/lib/marzban/certs/fullchain.pem
cp /etc/letsencrypt/live/"$DOMAIN"/privkey.pem /var/lib/marzban/certs/privkey.pem

cp /opt/marzban/.env /opt/marzban/.env.bak
sed -i '/^SSL_CERT_PATH=/d' /opt/marzban/.env
sed -i '/^SSL_KEY_PATH=/d' /opt/marzban/.env

echo "SSL_CERT_PATH=/var/lib/marzban/certs/fullchain.pem" >> /opt/marzban/.env
echo "SSL_KEY_PATH=/var/lib/marzban/certs/privkey.pem" >> /opt/marzban/.env

echo "✅ SSL configured for $DOMAIN"
