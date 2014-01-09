GIT_USER=$1
GIT_PASSWORD=$2

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
sudo apt-get -y install nginx nodejs git curl htop monit

#############################################################
# Install the application and start running
#############################################################
echo '==> GITing the app'
cd /home
git clone https://$GIT_USER:$GIT_PASSWORD@bitbucket.org/nswarr/flipnote-server.git
cd flipnote-server

echo '==> Installing grunt and loading app dependencies'
npm install -g grunt-cli grunt request
npm install
grunt build

#############################################################
# Update nginx configuration
#############################################################
echo '==> Updating nginx'
cp -f ./install/weloveflipnote /etc/nginx/sites-enabled/weloveflipnote
service nginx restart

echo "My IP"
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'

echo "Connect to this proxy server at port 9999"
