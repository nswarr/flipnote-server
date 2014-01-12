all:
	chmod +x ./deploy/os_dependencies.sh
	./deploy/os_dependencies.sh

	npm install
	grunt build

	chown -R $(shell logname) .

	#############################################################
	# Update nginx configuration
	#############################################################
	echo '==> Updating nginx'
	cp -f ./deploy/conf/weloveflipnote /etc/nginx/sites-enabled/weloveflipnote
	service nginx restart
