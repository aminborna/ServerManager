#!/bin/bash

echo "==============================="
echo "🔐 Marzban SSL Installer"
echo "==============================="

read -p "🌐 Enter your domain (e.g. sub.example.com): " DOMAIN

echo "🔄 Installing Certbot..."
apt-get update && apt-get install -y certbot

echo "📥 Getting SSL certificate for $DOMAIN..."
certbot certonly --standalone --agree-tos --register-unsafely-without-email -d "$DOMAIN"

if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
    echo "❌ SSL certificate not found. Installation failed."
    exit 1
fi

mkdir -p /var/lib/marzban/certs/
cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" /var/lib/marzban/certs/fullchain.pem
cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" /var/lib/marzban/certs/privkey.pem

cp /opt/marzban/.env /opt/marzban/.env.bak

sed -i '/^UVICORN_SSL_CERTFILE=/d' /opt/marzban/.env
sed -i '/^UVICORN_SSL_KEYFILE=/d' /opt/marzban/.env


echo "UVICORN_SSL_CERTFILE=/var/lib/marzban/certs/fullchain.pem" >> /opt/marzban/.env
echo "UVICORN_SSL_KEYFILE=/var/lib/marzban/certs/privkey.pem" >> /opt/marzban/.env

echo "✅ Certificates copied to /var/lib/marzban/certs/"
echo "✅ .env file updated with SSL paths."

echo "🔁 Restarting Marzban containers..."
cd /opt/marzban || exit
docker compose down
docker compose up -d

echo "✅ SSL is now configured for Marzban at https://$DOMAIN"
