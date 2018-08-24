# Step 1 - Updating Ubuntu
sudo apt-get update
sudo apt-get upgrade

# Step 2 - Install dependencies and libboost
sudo apt-get install -y \
	wget \
	git \
	pkg-config \
	build-essential \
	libboost-all-dev \
	libvtk5-dev \
	cmake \
	gedit \
	libboost-all-dev \
	# OpenCV:
	freeglut3 \
	freeglut3-dev \
	libtbb-dev \
	libqt4-dev \
	libjpeg-dev \
	libtiff-dev \
	libjasper-dev \
	libpng-dev \
	libavcodec-dev \
	libavformat-dev \
	libswscale-dev \
	libv4l-dev \
	libatlas-base-dev \
	gfortran \
	libgtk2.0-dev \
	libxvidcore-dev \
	libx264-dev \
	openexr \
	libtbb2 \
	libtbb-dev \
	libdc1394-22-dev

#sudo apt-get install libjpeg8-dev libtiff4-dev libjasper-dev libpng12-dev

# Step 3 - Get OpenCV 4 (assuming it is on the master branch) and contrib
sudo mkdir ~/opencv_build && cd ~/opencv_build \\
git clone https://github.com/opencv/opencv.git \\
git clone https://github.com/opencv/opencv_contrib.git

# Step 4 - build and install OpenCV
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=ON \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
	-D WITH_TBB=ON \
	-D WITH_V4L=ON \
	-D WITH_QT=ON \
	-D WITH_OPENGL=ON \
	-D BUILD_EXAMPLES=ON ..

make -j$(nproc)
sudo make install

sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig

# Step 5 - Install docker
sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"
	
sudo apt-get update
sudo apt-get install docker-ce -y
apt-cache madison docker-ce

# Post-installation steps
sudo groupadd docker
sudo usermod -aG docker $USER

