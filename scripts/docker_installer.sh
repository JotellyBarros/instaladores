#!/bin/bash

# Step 1 - Updating Ubuntu
sudo apt-get update
sudo apt-get upgrade

# Step 2 - Install dependency
sudo apt-get install -y \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common


# Step 3 - Add docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"
	
# Step 4 - Install docker
sudo apt-get update
sudo apt-get install docker-ce -y
apt-cache madison docker-ce

# Step 5 - Add docker group and the user
sudo groupadd docker
sudo usermod -aG docker $USER