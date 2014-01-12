all:
	./deploy/os_dependencies.sh

	CURRENT_USER=who am i
	
	npm install
	grunt build

	chown -R . $(CURRENT_USER)

	#############################################################
	# Update nginx configuration
	#############################################################
	echo '==> Updating nginx'
	cp -f ./deploy/conf/weloveflipnote /etc/nginx/sites-enabled/weloveflipnote
	service nginx restart
