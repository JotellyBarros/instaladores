# docker pull ubuntu:16.04

FROM ubuntu:16.04

# Step 1 - Updating Ubuntu
RUN apt-get update && upgrade

# Step 2 - Install dependencies and libboost
RUN apt-get install -y \
	sudo \
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
	libdc1394-22-dev \
	&& \ 
    apt-get clean


# Step 3 - Get OpenCV 4 (assuming it is on the master branch) and contrib
RUN mkdir ~/opencv_build && cd ~/opencv_build \\
git clone https://github.com/opencv/opencv.git \\
git clone https://github.com/opencv/opencv_contrib.git

# Step 4 - build and install OpenCV
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_C_EXAMPLES=ON \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_build/opencv_contrib/modules \
	-D WITH_TBB=ON \
	-D WITH_V4L=ON \
	-D WITH_QT=ON \
	-D WITH_OPENGL=ON \
	-D WITH_GDAL=ON \
	-D WITH_XINE=ON \
	-D INSTALL_C_EXAMPLES=ON \
	-D BUILD_EXAMPLES=ON ..

RUN make -j$(nproc)
RUN  make install
RUN /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
	ldconfig


# Step 4 - Install VScode
RUN cd ~

# install VS code (to run vscode in container: code --verbose --disable-gpu)
RUN apt-get update && apt-get install -y \
	libxkbfile1 libsecret-1-0 libnotify4 \
	libgconf-2-4 libnss3 libgtk2.0-0 \
	libxss1 libgconf-2-4 libasound2 \
	libxtst6 libcanberra-gtk-dev libgl1-mesa-glx \
	libgl1-mesa-dri libopenni2-0 && \
	rm -rf /var/lib/apt/lists/* && \
    wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb && \
    dpkg -i vscode.deb && \
    rm vscode.deb && \
    useradd -m developer -g sudo -s /bin/bash

RUN mkdir -p /home/developer/catkin_ws

RUN mkdir -p /home/developer/devsrc

RUN mkdir -p /home/developer/piksilib && \
    cd /home/developer/piksilib && \
    git clone https://github.com/PaulBouchier/libsbp && \
    cd /home/developer/piksilib/libsbp/c && \
    mkdir build && cd build && \ 
    cmake ../ && make && \
    sudo make install

RUN mkdir -p /dev/bus/usb

RUN echo 'source /opt/ros/indigo/setup.bash' >> /home/developer/.bashrc

RUN echo 'source /home/developer/catkin_ws/devel/setup.bash' >> /home/developer/.bashrc

RUN echo 'developer:a' | chpasswd 

RUN export QT_X11_NO_MITSHM=1

USER developer
