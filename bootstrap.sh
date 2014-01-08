cd /home/vagrant/flipnote

#############################################################
# Update apt-get, get dependencies
#############################################################
sudo apt-get -y clean
sudo apt-get update
sudo apt-get -y upgrade

# We have to install this bullshit because, as always, the standard Ubuntu repo
# has a criminally old version of node
sudo apt-get install -y python-software-properties software-properties-common python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update

echo '==> Installing base os dependencies'
sudo apt-get -y install nginx nodejs git curl htop

#############################################################
# Install the application and start running
#############################################################
echo '==> Installing grunt and loading app dependencies'
npm install -g grunt-cli grunt request
npm install -g
grunt &

#############################################################
# Update nginx configuration
#############################################################
echo '==> Updating nginx'
cp -f ./install/nginx.conf /etc/nginx/nginx.conf
service nginx restart

echo "My IP"
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'

echo "Connect to this proxy server at port 9999"
