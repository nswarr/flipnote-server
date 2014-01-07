#############################################################
# Update apt-get
#############################################################
echo '==> Updating apt-get repos, and upgrading apt-get'
sudo apt-get -y clean
sudo apt-get -y update
sudo apt-get -y upgrade
echo '==> Installing base os dependencies'
sudo apt-get -y install nginx node git curl htop

