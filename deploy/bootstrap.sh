#!/usr/bin/env bash

GIT_USER=$1
GIT_PASSWORD=$2

#############################################################
# Download and build application
#############################################################
echo '==> GITing the app'
cd /home
git clone https://$GIT_USER:$GIT_PASSWORD@bitbucket.org/nswarr/flipnote-server.git
cd flipnote-server

echo '==> Installing grunt and loading app dependencies'
npm install
grunt build

#############################################################
# Update nginx configuration
#############################################################
echo '==> Updating nginx'
cp -f ./deploy/conf/weloveflipnote /etc/nginx/sites-enabled/weloveflipnote
service nginx restart

#############################################################
# Create application user
#############################################################
echo '==> Creating flipnote user'
useradd -m -p dfbaNl6JWRVrI -s /bin/bash flipnote
chown -R flipnote /home/flipnote-server/

#############################################################
# Create cron job to automatically deploy new code
#############################################################
echo '==> Creating cron job for app updates'
chmod +x ./deploy/conf/cron_update_app
chmod +x ./deploy/update_app.sh
crontab ./deploy/conf/cron_update_app
service cron restart