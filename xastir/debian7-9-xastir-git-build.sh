#!/bin/bash
 # Build script for Xastir for Debian Wheezy, Jessie & Stretch
 # This script grabs Xastir from the git repository, compiles
 # and installs it.  It also downloads any needed dependent 
 # packages from the Debian repositories and installs those
 # prior to compiling Xastir.
 # November 6, 2017
 
 # check if user is in root mode and abort if yes
 if [ "`whoami`" = "root" ]
 then
   echo -e "\nPlease do not run this script as root.\n\n"
   exit 1
 fi
 
 if grep -q "8." /etc/debian_version; then
   # refresh repositories and grab Xastir dependencies
   echo -e "\nEnter your root password when prompted...\n"
   su -c "apt-get update || exit 1"
   echo -e "\nEnter your root password if prompted...\n"
   su -c "apt-get -y install build-essential automake git libxpm-dev \
   xorg-dev libmotif-dev graphicsmagick gv libcurl4-openssl-dev \
   shapelib libshp-dev gpsman gpsmanshp libpcre3-dev libproj-dev \
   libdb5.3-dev python-dev libwebp-dev libgraphicsmagick1-dev \
   festival festival-dev libax25-dev libgeotiff-dev || exit 1"
 else
   if grep -q "7." /etc/debian_version; then
     echo -e "\nEnter your root password when prompted...\n"
     su -c "apt-get update || exit 1"
     echo -e "\nEnter your root password if prompted...\n"
     su -c "apt-get -y install build-essential automake git xorg-dev tcl8.4 \
     lesstif2-dev graphicsmagick gv libxp-dev libcurl4-openssl-dev shapelib \
     libshp-dev gpsman gpsmanshp libpcre3-dev libproj-dev libdb5.1-dev \
     python-dev libax25-dev libgraphicsmagick1-dev festival festival-dev || exit 1"
   else
     if grep -q "9." /etc/debian_version; then
       # refresh repositories and grab Xastir dependencies
       echo -e "\nEnter your root password when prompted...\n"
       su -c "apt-get update || exit 1"
       echo -e "\nEnter your root password if prompted...\n"
       su -c "apt-get -y install build-essential automake git libxpm-dev \
       xorg-dev libmotif-dev graphicsmagick gv libcurl4-openssl-dev \
       shapelib libshp-dev gpsman gpsmanshp libpcre3-dev libproj-dev \
       libdb5.3-dev python-dev libwebp-dev libgraphicsmagick1-dev \
       festival festival-dev libax25-dev libgeotiff-dev || exit 1"
     else
       echo "\nThis script applies only to Debian 7.x, 8.x, or 9.x.\n\n"
       exit 1
     fi
   fi
 fi
 
 # create directories for source code, etc.
 mkdir -p ~/src ; cd ~/src || exit 1
 
 # retrieve Xastir via git
 git clone https://github.com/Xastir/Xastir.git || exit 1

 # execute the bootstrap shell script
 cd Xastir
 ./bootstrap.sh
 
 # create a build directory and configure
 mkdir build; cd build || exit 1
 ../configure CPPFLAGS="-I/usr/include/geotiff" || exit 1
 
 # compile and install
 make || exit 1
 echo -e "\nEnter your root password when prompted...\n"
 su -c "make install"