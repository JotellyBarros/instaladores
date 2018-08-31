#!/bin/bash

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
	libvtk7-dev \
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

sudo mkdir opencv_build && cd opencv_build
git clone https://github.com/opencv/opencv.git
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

if [ -d "$1" ] ; then 
  echo "Error: make compile report a error.";
	exit 0;
fi

sudo make install
if [ -d "$1" ] ; then 
  echo "Error: make install report a error.";
	exit 0;
fi
